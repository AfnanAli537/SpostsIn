// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/payment_flow_helper.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/web_view_screen.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/widgets/processing_dailog.dart';
import 'package:sports_in/features/payment/presentation/widgets/sucess_dailog.dart';
import 'package:sports_in/generated/l10n.dart';

class AdPaymentScreen extends StatefulWidget {
  final double price;
  final String adId;

  const AdPaymentScreen({
    super.key,
    required this.price,
    required this.adId,
  });

  @override
  State<AdPaymentScreen> createState() => _AdPaymentScreenState();
}

class _AdPaymentScreenState extends State<AdPaymentScreen> {
  String? _resolvedAdId;
  bool _isResolvingId = false;
  String? _resolveError;
  String? _transId;

  // Processing dialog guard + de-dupe — same pattern as SubscriptionScreen
  bool _isProcessingDialogOpen = false;
  String? _handledPaymentStateType;

  @override
  void initState() {
    super.initState();
    _resolveAdId();
  }

  Future<void> _resolveAdId() async {
    if (widget.adId.isNotEmpty) {
      setState(() => _resolvedAdId = widget.adId);
      return;
    }
    setState(() {
      _isResolvingId = true;
      _resolveError = null;
    });
    try {
      final result = await getIt<AdsRepositoryImpl>().getUserAds(
        isActive: false,
        page: 1,
        size: 1,
      );
      if (result.items.isNotEmpty) {
        setState(() {
          _resolvedAdId = result.items.first.id;
          _isResolvingId = false;
        });
      } else {
        setState(() {
          _resolveError = 'Could not find the created ad. Please try again.';
          _isResolvingId = false;
        });
      }
    } catch (e) {
      setState(() {
        _resolveError = 'Failed to load ad details: $e';
        _isResolvingId = false;
      });
    }
  }

  // ── Processing dialog helpers (same as SubscriptionScreen) ────────────────

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

  // ── Pay now ───────────────────────────────────────────────────────────────

  Future<void> _onPayNow(BuildContext payContext) async {
    if (_resolvedAdId == null) return;

    // Reset the guard so the listener reacts to a fresh payment attempt.
    setState(() => _handledPaymentStateType = null);

    final paymentBloc = payContext.read<PaymentBloc>();
    await initiatePaymentFlow(
      context: payContext,
      paymentBloc: paymentBloc,
      targetId: _resolvedAdId!,
      targetType: PaymentTargetType.advertisement,
      price: widget.price,
    );
    // Fawry/Vodafone sub-screens have managed their own dialogs and navigated
    // to mainLayout by the time this await returns. Nothing more to do.
  }

  // ── Build ──────────────────────────────────────────────────────────────────

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
              // ── Processing overlay for credit card initiation only ────
              // Fawry and Vodafone handle their own processing dialogs.
              if (state is PaymentInitiating) {
                _showProcessingDialog();
              }

              // ── Credit card: redirect to WebView ──────────────────────
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
                      url: state.redirectUrl,
                      title: strings.completePayment,
                    ),
                  ),
                );
              }

              // ── Free / direct success (ProcessSuccessful) ─────────────
              if (state is ProcessSuccessful) {
                final stateKey = state.runtimeType.toString();
                if (stateKey == _handledPaymentStateType) return;
                _handledPaymentStateType = stateKey;

                _dismissProcessingDialog();
                if (!mounted) return;
                showDialog(
                  context: ctx,
                  barrierDismissible: false,
                  builder: (_) => PaymentSuccessDialog(
                    transactionId: _transId ?? strings.unKnown,
                    onDismissed: () {
                      if (mounted) {
                        Navigator.of(ctx).pushNamedAndRemoveUntil(
                          AppRoutes.mainLayout,
                          (route) => false,
                        );
                      }
                    },
                  ),
                );
              }

              // ── FAWRY / VODAFONE success (ManualActivateSuccess) ──────────────
              // Do NOT show a dialog here — Fawry shows it on its own screen and
              // Vodafone shows it on its own screen then navigates away.
              // We just dismiss the processing overlay (safety) and reset state.
              if (state is ManualActivateSuccess) {
                _dismissProcessingDialog();
                // Reset guard so the next payment attempt is fresh.
                setState(() => _handledPaymentStateType = null);
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
            child: BlocBuilder<PaymentBloc, PaymentState>(
              builder: (ctx, paymentState) {
                final isProcessing = paymentState is PaymentInitiating;

                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: theme.onSurface),
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
                          // ── Summary card ─────────────────────────────────
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: theme.surface,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.grey[300]!),
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
                                Icon(Icons.campaign_outlined,
                                    size: 48.sp, color: theme.primary),
                                SizedBox(height: 12.h),
                                Text(
                                  strings.adCreatedPendingPayment,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  strings.adSavedCompletePayment,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20.h),
                                Divider(color: Colors.grey[300]),
                                SizedBox(height: 16.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(strings.totalAmount,
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.grey[600])),
                                    Text(
                                      strings.priceEGP(
                                          widget.price.toStringAsFixed(0)),
                                      style: GoogleFonts.poppins(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w700,
                                        color: theme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(strings.pricePerDay('5'),
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey[500])),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // ── Resolution status ─────────────────────────────
                          if (_isResolvingId)
                            Row(
                              children: [
                                SizedBox(
                                  width: 16.w,
                                  height: 16.w,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: theme.primary),
                                ),
                                SizedBox(width: 10.w),
                                Text('Preparing payment...',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[600])),
                              ],
                            ),
                          if (_resolveError != null)
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.red[300]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: Colors.red, size: 18.sp),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_resolveError!,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.red[700])),
                                        SizedBox(height: 6.h),
                                        GestureDetector(
                                          onTap: _resolveAdId,
                                          child: Text('Tap to retry',
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: theme.primary,
                                                  fontWeight:
                                                      FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const Spacer(),

                          // ── Pay Now ───────────────────────────────────────
                          CustomElevatedButton(
                            text: isProcessing
                                ? 'Processing...'
                                : strings.payNow,
                            isLoading: isProcessing,
                            enabled: _resolvedAdId != null &&
                                !_isResolvingId &&
                                !isProcessing,
                            onPressed: (_resolvedAdId != null &&
                                    !_isResolvingId &&
                                    !isProcessing)
                                ? () => _onPayNow(ctx)
                                : () {},
                          ),
                          SizedBox(height: 12.h),

                          // ── Pay Later ─────────────────────────────────────
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: isProcessing
                                  ? null
                                  : () => Navigator.of(ctx)
                                      .popUntil((route) => route.isFirst),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: theme.primary),
                                foregroundColor: theme.primary,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r)),
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