// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/widgets/processing_dailog.dart';
import 'package:sports_in/features/payment/presentation/widgets/sucess_dailog.dart';
import 'package:sports_in/generated/l10n.dart';

class FawryScreen extends StatefulWidget {
  final SubscriptionPlanModel plan;
  final String mobileNumber;
  final PaymentTargetType targetType;

  const FawryScreen({
    super.key,
    required this.plan,
    required this.mobileNumber,
    this.targetType = PaymentTargetType.supscription,
  });

  @override
  State<FawryScreen> createState() => _FawryScreenState();
}

class _FawryScreenState extends State<FawryScreen> {
  String? _referenceCode;
  String? _pendingTxId; // stored so we can dispatch ManualActivate
  bool _isLoading = false;
  bool _codeCopied = false;
  bool _successShown = false;
  bool _isProcessingDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initiatePayment());
  }

  // ── Payment actions ────────────────────────────────────────────────────────

  void _initiatePayment() {
    context.read<PaymentBloc>().add(
      InitiatePaymentEvent(
        targetId: widget.plan.id,
        targetType: widget.targetType,
        method: PaymentMethod.fawryPay,
        mobileNumber: widget.mobileNumber,
      ),
    );
  }

  /// Dispatched by THIS screen once [PaymentInitiatedAwaitingActivation]
  /// is received and the reference code is displayed.
  void _triggerManualActivation(String txId) {
    context.read<PaymentBloc>().add(ManualActivateEvent(orderId: txId));
  }

  void _copyCode() {
    if (_referenceCode == null) return;
    Clipboard.setData(ClipboardData(text: _referenceCode!));
    setState(() => _codeCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).fawry_screen_copied),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(12.w),
      ),
    );
  }

  // ── Dialog helpers ─────────────────────────────────────────────────────────

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

  void _showSuccessDialog() {
    if (_successShown || !mounted) return;
    _successShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentSuccessDialog(
        transactionId: _pendingTxId ?? S.of(context).unKnown,
        // Stays on screen so the user can keep the reference code visible.
        onDismissed: () {},
      ),
    );
  }

  void _goHome() {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.mainLayout, (route) => false);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        // ── 1. Initiating payment ────────────────────────────────────────
        if (state is PaymentInitiating) {
          setState(() => _isLoading = true);
          _showProcessingDialog();
        }

        // ── 2. Reference code received → show it, then trigger activation ─
        if (state is PaymentInitiatedAwaitingActivation) {
          _dismissProcessingDialog();
          setState(() {
            _isLoading = false;
            _referenceCode = state.referenceCode;
            _pendingTxId = state.transactionId;
          });
          // Now that the code is on screen, trigger manual activation.
          // In real production you'd wait for actual payment confirmation;
          // in manual-test mode we activate immediately.
          _triggerManualActivation(state.transactionId);
        }

        // ── 3. Activating ────────────────────────────────────────────────
        if (state is ManualActivating) {
          setState(() => _isLoading = true);
          _showProcessingDialog();
        }

        // ── 4. Success ───────────────────────────────────────────────────
        if (state is ManualActivateSuccess || state is ProcessSuccessful) {
          _dismissProcessingDialog();
          if (mounted) setState(() => _isLoading = false);
          _showSuccessDialog();
        }

        // ── 5. Errors ────────────────────────────────────────────────────
        if (state is PaymentInitiateError || state is ManualActivateError) {
          _dismissProcessingDialog();
          if (mounted) setState(() => _isLoading = false);
          final msg = state is PaymentInitiateError
              ? (state as PaymentInitiateError).message
              : (state as ManualActivateError).message;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                margin: EdgeInsets.all(12.w),
              ),
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            // Back arrow clears the stack → main layout
            onPressed: _goHome,
            icon: Icon(Icons.arrow_back, color: theme.onSurface),
          ),
          title: Text(
            s.fawry_screen_appbar_title,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ── Scrollable content ───────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      // Brand banner
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          width: double.infinity,
                          height: 180.h,
                          color: const Color(0xFFF5C400),
                          child: Center(
                            child: Container(
                              width: 130.w,
                              height: 130.w,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.sync_rounded,
                                  size: 80.sp,
                                  color: const Color(0xFF0055A5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 28.h),
                      Text(
                        s.fawry_screen_label,
                        style: TextStyle(fontSize: 15.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        s.fawry_screen_terms,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // ── Reference code / spinner / error ──────────────
                      if (_isLoading)
                        Container(
                          width: double.infinity,
                          height: 120.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7D4),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: const Color(0xFFF5C400),
                              strokeWidth: 2.5.w,
                            ),
                          ),
                        )
                      else if (_referenceCode != null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 28.h,
                            horizontal: 20.w,
                          ),
                          decoration: BoxDecoration(
                            color: theme.onError,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _referenceCode!,
                                style: TextStyle(
                                  fontSize: 34.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black87,
                                  letterSpacing: 1.5,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                s.fawry_screen_pay_instruction,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.5.sp,
                                  color: Colors.black54,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3F3),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 36.sp,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                s.fawry_screen_failed_code,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              TextButton(
                                onPressed: _initiatePayment,
                                child: Text(
                                  s.fawry_screen_retry,
                                  style: TextStyle(
                                    color: theme.primary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    
                    ],
                  ),
                ),
              ),
              // ── Bottom action buttons ──────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                child: SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton.icon(
                    onPressed: _referenceCode != null ? _copyCode : null,
                    icon: Icon(
                      _codeCopied ? Icons.check : Icons.copy_rounded,
                      size: 18.sp,
                      color: const Color(0xFFCCFF00),
                    ),
                    label: Text(
                      _codeCopied
                          ? s.fawry_screen_copied_btn
                          : s.fawry_screen_copy_btn,
                      style: TextStyle(
                        color: const Color(0xFFCCFF00),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _codeCopied
                          ? theme.primary.withOpacity(0.85)
                          : theme.primary,
                      disabledBackgroundColor: theme.primary.withOpacity(
                        0.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
