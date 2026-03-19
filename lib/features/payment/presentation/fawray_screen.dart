// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/widgets/sucess_dailog.dart';
import 'package:sports_in/generated/l10n.dart';

class FawryScreen extends StatefulWidget {
  final SubscriptionPlanModel plan;
  final String mobileNumber;

  /// Defaults to [PaymentTargetType.supscription] to keep backward
  /// compatibility with the existing subscription flow.
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initiatePayment());
  }

  void _initiatePayment() {
    context.read<PaymentBloc>().add(InitiatePaymentEvent(
          targetId: widget.plan.id,
          targetType: widget.targetType, // ← uses passed targetType
          method: PaymentMethod.fawryPay,
          mobileNumber: widget.mobileNumber,
        ));
  }

  void _copyCode() {
    if (_referenceCode == null) return;
    Clipboard.setData(ClipboardData(text: _referenceCode!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).fawry_screen_copied),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r)),
        margin: EdgeInsets.all(12.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final s = S.of(context);
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentInitiating || state is ManualActivating) {
          setState(() => _isLoading = true);
        } else if (state is PaymentInitiatedAwaitingActivation) {
          setState(() {
            _isLoading = false;
            _referenceCode = state.referenceCode;
          });
        } else {
          setState(() => _isLoading = false);
        }

        if (state is ManualActivateSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => PaymentSuccessDialog(
              transactionId: s.unKnown,
              onDismissed: () {
                context.read<PaymentBloc>().add(const FetchPlansEvent());
                if (widget.targetType == PaymentTargetType.supscription) {
                  Navigator.of(context).pushNamed(AppRoutes.subscription);
                } else {
                  // Ads / courses: pop back to home
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
          );
        }

        if (state is PaymentInitiateError || state is ManualActivateError) {
          final msg = state is PaymentInitiateError
              ? (state as PaymentInitiateError).message
              : (state as ManualActivateError).message;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              margin: EdgeInsets.all(12.w),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              context.read<PaymentBloc>().add(const FetchPlansEvent());
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: theme.onSurface),
          ),
          title: Text(
            s.fawry_screen_appbar_title,
            style:
                TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
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
                          child: Icon(Icons.sync_rounded,
                              size: 80.sp,
                              color: const Color(0xFF0055A5)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                Text(s.fawry_screen_label,
                    style: TextStyle(fontSize: 15.sp)),
                SizedBox(height: 4.h),
                Text(
                  s.fawry_screen_terms,
                  style: TextStyle(
                      fontSize: 13.sp, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 24.h),
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
                        vertical: 28.h, horizontal: 20.w),
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
                        Icon(Icons.error_outline,
                            color: Colors.red, size: 36.sp),
                        SizedBox(height: 10.h),
                        Text(
                          s.fawry_screen_failed_code,
                          style: TextStyle(
                              color: Colors.red, fontSize: 14.sp),
                        ),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: _initiatePayment,
                          child: Text(
                            s.fawry_screen_retry,
                            style: TextStyle(
                                color: theme.primary, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed:
                        _referenceCode != null ? _copyCode : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      disabledBackgroundColor:
                          theme.primary.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      elevation: 0,
                    ),
                    child: Text(
                      s.fawry_screen_copy_btn,
                      style: TextStyle(
                        color: const Color(0xFFCCFF00),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}