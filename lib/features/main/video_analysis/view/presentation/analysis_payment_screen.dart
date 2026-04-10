import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/payment_flow_helper.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/web_view_screen.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_bloc.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_event.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_state.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/widgets/processing_dailog.dart';
import 'package:sports_in/generated/l10n.dart';

import '../../data/enums/analysis_type.dart';
import 'analysis_processing_screen.dart';

/// Shown when the backend responds with isPaid:false.
/// Mirrors [AdPaymentScreen] pattern exactly — same dialog guards,
/// same BlocProvider/BlocListener structure.
class AnalysisPaymentScreen extends StatefulWidget {
  final String analysisId;
  final double price;
  final AnalysisType analysisType;

  const AnalysisPaymentScreen({
    super.key,
    required this.analysisId,
    required this.price,
    required this.analysisType,
  });

  @override
  State<AnalysisPaymentScreen> createState() => _AnalysisPaymentScreenState();
}

class _AnalysisPaymentScreenState extends State<AnalysisPaymentScreen> {
  // Processing dialog guard + de-dupe — same pattern as AdPaymentScreen
  bool _isProcessingDialogOpen = false;
  String? _handledPaymentStateType;
  String? _transId;

  void _showProcessingDialog() {
    if (_isProcessingDialogOpen) return;
    _isProcessingDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ProcessingPaymentDialog(),
    ).then((_) => _isProcessingDialogOpen = false);
  }

  void _dismissProcessingDialog() {
    if (_isProcessingDialogOpen && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      _isProcessingDialogOpen = false;
    }
  }

  Future<void> _onPayNow(BuildContext payContext) async {
    setState(() => _handledPaymentStateType = null);

    final paymentBloc = payContext.read<PaymentBloc>();
    await initiatePaymentFlow(
      context: payContext,
      paymentBloc: paymentBloc,
      targetId: widget.analysisId,
      targetType: PaymentTargetType.videoAnalysis,
      price: widget.price,
    );
  }

  IconData get _typeIcon {
    switch (widget.analysisType) {
      case AnalysisType.goalkeeper:
        return Icons.sports_handball_outlined;
      case AnalysisType.passing:
        return Icons.compare_arrows_rounded;
      case AnalysisType.dribbling:
        return Icons.sports_soccer;
      case AnalysisType.match:
        return Icons.stadium_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return BlocProvider(
      create: (_) => getIt<PaymentBloc>(),
      child: Builder(
        builder: (payContext) {
          return BlocListener<PaymentBloc, PaymentState>(
            listener: (ctx, state) {
              // ── Processing overlay (credit card only) ─────────────────
              if (state is PaymentInitiating) {
                _showProcessingDialog();
              }

              // ── Credit card → WebView ─────────────────────────────────
              if (state is PaymentRedirectReady) {
                final stateKey =
                    state.runtimeType.toString() + state.redirectUrl;
                if (stateKey == _handledPaymentStateType) return;
                _handledPaymentStateType = stateKey;

                _dismissProcessingDialog();
                _transId = state.transactionId;
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                      prevScreen: AppRoutes.mainLayout,
                      url: state.redirectUrl,
                      title: strings.completePayment,
                    ),
                  ),
                );
              }

              // ── Direct success (ProcessSuccessful) ────────────────────
              if (state is ProcessSuccessful) {
                final stateKey = state.runtimeType.toString();
                if (stateKey == _handledPaymentStateType) return;
                _handledPaymentStateType = stateKey;

                _dismissProcessingDialog();
                if (!mounted) return;

                // After payment confirmed → trigger execute-paid-analysis
                // We use the parent CreateAnalysisBloc if it's still alive,
                // or call the repo directly via a fresh event.
                _executeAnalysisAfterPayment(
                  ctx,
                  _transId ?? state.transactionId ?? '',
                );
              }

              // ── Fawry / Vodafone success (ManualActivateSuccess) ──────
              if (state is ManualActivateSuccess) {
                _dismissProcessingDialog();
                // The Fawry/Vodafone screen shows its own success dialog
                // and navigates away. After manual-activate the backend
                // already queued the analysis. Navigate to processing screen.
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => AnalysisProcessingScreen(
                        type: widget.analysisType),
                  ),
                  (route) => route.isFirst,
                );
              }

              // ── Errors ────────────────────────────────────────────────
              if (state is PaymentInitiateError) {
                _dismissProcessingDialog();
                Fluttertoast.showToast(
                    msg: state.message, backgroundColor: Colors.red);
              }
              if (state is ManualActivateError) {
                _dismissProcessingDialog();
                Fluttertoast.showToast(
                    msg: state.message, backgroundColor: Colors.red);
              }
            },
            child: BlocConsumer<CreateAnalysisBloc, CreateAnalysisState>(
              listener: (ctx, state) {
                if (state is PaidAnalysisExecuted) {
                  Navigator.pushAndRemoveUntil(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => AnalysisProcessingScreen(
                          type: widget.analysisType),
                    ),
                    (route) => route.isFirst,
                  );
                } else if (state is CreateAnalysisError) {
                  Fluttertoast.showToast(
                      msg: state.message, backgroundColor: Colors.red);
                }
              },
              builder: (ctx, analysisState) {
                return BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (ctx, paymentState) {
                    final isProcessing = paymentState is PaymentInitiating ||
                        analysisState is CreateAnalysisLoading;

                    return Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        leading: IconButton(
                          icon:
                              Icon(Icons.arrow_back, color: theme.onSurface),
                          onPressed: () => Navigator.of(ctx)
                              .popUntil((route) => route.isFirst),
                        ),
                        title: Text(
                          strings.completePayment,
                          style: TextStyle(
                            color: theme.onSurface,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        centerTitle: true,
                      ),
                      body: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Summary card ──────────────────────────
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: theme.surface,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                      color: theme.outline
                                          .withOpacity(0.25)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.08),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(14.w),
                                      decoration: BoxDecoration(
                                        color:
                                            theme.primary.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(_typeIcon,
                                          size: 36.sp,
                                          color: theme.primary),
                                    ),
                                    SizedBox(height: 14.h),
                                    Text(
                                      '${widget.analysisType.label} Analysis',
                                      style: GoogleFonts.poppins(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w700,
                                        color: theme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      'Your video has been saved. Complete payment to run the AI analysis.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.sp,
                                        color: Colors.grey[600],
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.h),
                                    Divider(
                                        color: theme.outline
                                            .withOpacity(0.2)),
                                    SizedBox(height: 16.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          strings.totalAmount,
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.grey[600]),
                                        ),
                                        Text(
                                          strings.priceEGP(widget.price
                                              .toStringAsFixed(0)),
                                          style: GoogleFonts.poppins(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w700,
                                            color: theme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // ── What happens next ─────────────────────
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(0.05),
                                  borderRadius:
                                      BorderRadius.circular(14.r),
                                  border: Border.all(
                                      color: theme.primary
                                          .withOpacity(0.15)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'What happens next',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: theme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    _Step(
                                        number: '1',
                                        text:
                                            'Complete payment using your preferred method'),
                                    _Step(
                                        number: '2',
                                        text:
                                            'Our AI engine starts processing your video'),
                                    _Step(
                                        number: '3',
                                        text:
                                            'Report appears in your profile — you\'ll be notified'),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // ── Pay Now ───────────────────────────────
                              CustomElevatedButton(
                                text: isProcessing
                                    ? 'Processing...'
                                    : strings.payNow,
                                isLoading: isProcessing,
                                enabled: !isProcessing,
                                onPressed: isProcessing
                                    ? () {}
                                    : () => _onPayNow(ctx),
                              ),
                              SizedBox(height: 12.h),

                              // ── Pay Later ─────────────────────────────
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: isProcessing
                                      ? null
                                      : () => Navigator.of(ctx)
                                          .popUntil((r) => r.isFirst),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: theme.primary),
                                    foregroundColor: theme.primary,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 14.h),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r)),
                                  ),
                                  child: Text(
                                    strings.payLaterDraft,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _executeAnalysisAfterPayment(BuildContext ctx, String transactionId) {
    if (transactionId.isEmpty) {
      // Fallback: show processing screen anyway — backend may have already
      // queued it via the webhook.
      Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(
          builder: (_) =>
              AnalysisProcessingScreen(type: widget.analysisType),
        ),
        (route) => route.isFirst,
      );
      return;
    }

    ctx.read<CreateAnalysisBloc>().add(
          ExecutePaidAnalysisEvent(transactionId),
        );
  }
}

// ── Step indicator widget ─────────────────────────────────────────────────────

class _Step extends StatelessWidget {
  final String number;
  final String text;

  const _Step({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              color: theme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: theme.onSurface.withOpacity(0.65),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}