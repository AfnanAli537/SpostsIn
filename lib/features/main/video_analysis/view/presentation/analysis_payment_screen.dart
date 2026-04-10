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
import 'package:sports_in/features/main/video_analysis/data/repo/analysis_repo.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/widgets/processing_dailog.dart';
import 'package:sports_in/generated/l10n.dart';

import '../../data/enums/analysis_type.dart';
import 'analysis_processing_screen.dart';

/// Shown when:
///   (a) Backend returns isPaid:false after submitting analysis → new analysis
///   (b) User taps "Pay Now" on an existing unpaid AnalysisListItemCard
///
/// Owns its own [PaymentBloc] and calls [IAnalysisRepo.executePaidAnalysis]
/// directly — does NOT depend on [CreateAnalysisBloc] being alive in the tree.
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
  bool _isProcessingDialogOpen = false;
  String? _handledPaymentStateType;
  String? _transId;
  bool _isExecutingAnalysis = false;

  // ── Dialog helpers ──────────────────────────────────────────────────────────

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

  // ── Execute analysis (called after credit-card ProcessSuccessful) ────────────

  Future<void> _executeAnalysis(BuildContext ctx, String transactionId) async {
    if (_isExecutingAnalysis) return;
    _isExecutingAnalysis = true;

    if (transactionId.isNotEmpty) {
      try {
        await getIt<IAnalysisRepo>().executePaidAnalysis(transactionId);
      } catch (e) {
        // Non-fatal — backend webhook may have already queued it.
        debugPrint('⚠️ executePaidAnalysis error (non-fatal): $e');
      }
    }

    if (!mounted) return;
    _navigateToProcessing(ctx);
  }

  void _navigateToProcessing(BuildContext ctx) {
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => AnalysisProcessingScreen(type: widget.analysisType),
      ),
      (route) => route.isFirst,
    );
  }

  // ── Pay now ─────────────────────────────────────────────────────────────────

  Future<void> _onPayNow(BuildContext payCtx) async {
    setState(() => _handledPaymentStateType = null);
    final paymentBloc = payCtx.read<PaymentBloc>();
    await initiatePaymentFlow(
      context: payCtx,
      paymentBloc: paymentBloc,
      targetId: widget.analysisId,
      targetType: PaymentTargetType.videoAnalysis,
      price: widget.price,
    );
  }

  String _getLocalizedAnalysisTypeLabel(S strings) {
    switch (widget.analysisType) {
      case AnalysisType.goalkeeper:
        return strings.goalkeeperAnalysis;
      case AnalysisType.passing:
        return strings.passingAnalysis;
      case AnalysisType.dribbling:
        return strings.dribblingAnalysis;
      case AnalysisType.match:
        return strings.matchAnalysis;
    }
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

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return BlocProvider(
      create: (_) => getIt<PaymentBloc>(),
      child: Builder(
        builder: (payCtx) {
          return BlocListener<PaymentBloc, PaymentState>(
            listener: (ctx, state) {
              // ── Processing overlay ──────────────────────────────────────
              if (state is PaymentInitiating || state is ManualActivating) {
                _showProcessingDialog();
              }

              // ── Credit card: redirect to WebView ────────────────────────
              if (state is PaymentRedirectReady) {
                final key = state.runtimeType.toString() + state.redirectUrl;
                if (key == _handledPaymentStateType) return;
                _handledPaymentStateType = key;
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

              // ── Credit card ProcessSuccessful (free plan / webhook confirm)
              // executePaidAnalysis is called here because for credit card,
              // ManualActivate is NOT called — the webhook confirms directly.
              if (state is ProcessSuccessful) {
                final key = state.runtimeType.toString();
                if (key == _handledPaymentStateType) return;
                _handledPaymentStateType = key;
                _dismissProcessingDialog();
                if (!mounted) return;
                _executeAnalysis(ctx, _transId ?? state.transactionId ?? '');
              }

              // ── Fawry / Vodafone: ManualActivateSuccess ─────────────────
              // PaymentBloc already called executePaidAnalysis in _onManualActivate.
              // We just navigate to the processing screen.
              if (state is ManualActivateSuccess) {
                _dismissProcessingDialog();
                if (!mounted) return;
                final key = state.runtimeType.toString();
                if (key == _handledPaymentStateType) return;
                _handledPaymentStateType = key;
                _navigateToProcessing(ctx);
              }

              // ── Errors ──────────────────────────────────────────────────
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
            child: BlocBuilder<PaymentBloc, PaymentState>(
              builder: (ctx, paymentState) {
                final isProcessing = paymentState is PaymentInitiating ||
                    paymentState is ManualActivating ||
                    _isExecutingAnalysis;

                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: theme.onSurface),
                      onPressed: isProcessing
                          ? null
                          : () => Navigator.of(ctx)
                              .popUntil((r) => r.isFirst),
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
                          // ── Summary card ────────────────────────────────
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: theme.surface,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                  color: theme.outline.withOpacity(0.25)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(children: [
                              Container(
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(_typeIcon,
                                    size: 36.sp, color: theme.primary),
                              ),
                              SizedBox(height: 14.h),
                              Text(
                                _getLocalizedAnalysisTypeLabel(strings),
                                style: GoogleFonts.poppins(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: theme.onSurface,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                strings.analysisSavedCompletePayment,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20.h),
                              Divider(
                                  color: theme.outline.withOpacity(0.2)),
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
                                    strings.priceEGP(
                                        widget.price.toStringAsFixed(0)),
                                    style: GoogleFonts.poppins(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      color: theme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                          SizedBox(height: 20.h),

                          // ── What happens next ───────────────────────────
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: theme.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                  color: theme.primary.withOpacity(0.15)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.whatHappensNext,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                _Step(
                                    number: '1',
                                    text: strings.stepCompletePayment,
                                    strings: strings,
                                ),
                                _Step(
                                    number: '2',
                                    text: strings.stepAiProcessing,
                                    strings: strings,
                                ),
                                _Step(
                                    number: '3',
                                    text: strings.stepReportNotified,
                                    strings: strings,
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // ── Pay Now ─────────────────────────────────────
                          CustomElevatedButton(
                            text: isProcessing
                                ? strings.processing
                                : strings.payNow,
                            isLoading: isProcessing,
                            enabled: !isProcessing,
                            onPressed:
                                isProcessing ? () {} : () => _onPayNow(ctx),
                          ),
                          SizedBox(height: 12.h),

                          // ── Pay Later ───────────────────────────────────
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
                                padding:
                                    EdgeInsets.symmetric(vertical: 14.h),
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
            ),
          );
        },
      ),
    );
  }
}

// ── Step indicator ────────────────────────────────────────────────────────────

class _Step extends StatelessWidget {
  final String number;
  final String text;
  final S strings;

  const _Step({
    required this.number,
    required this.text,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 22.w,
          height: 22.w,
          decoration: BoxDecoration(
            color: theme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(number,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700)),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.onSurface.withOpacity(0.65),
                  height: 1.5)),
        ),
      ]),
    );
  }
}