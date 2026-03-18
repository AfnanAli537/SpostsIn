// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/widgets/sucess_dailog.dart';
import 'package:sports_in/generated/l10n.dart';

class VodafoneCashScreen extends StatefulWidget {
  final SubscriptionPlanModel plan;

  const VodafoneCashScreen({super.key, required this.plan});

  @override
  State<VodafoneCashScreen> createState() => _VodafoneCashScreenState();
}

class _VodafoneCashScreenState extends State<VodafoneCashScreen> {
  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _onSendPayment() {
    if (!_formKey.currentState!.validate()) return;
    context.read<PaymentBloc>().add(
      InitiatePaymentEvent(
        targetId: widget.plan.id,
        targetType: PaymentTargetType.supscription,
        method: PaymentMethod.mobileWallet,
        mobileNumber: _mobileController.text.trim(),
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
                // Navigator.of(context).pop();
                 Navigator.of(context).pushNamed(
                    AppRoutes.subscription,
                
                  ) ;
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
                borderRadius: BorderRadius.circular(10.r),
              ),
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
            s.vodafone_appbar_title,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      height: 180.h,
                      color: const Color(0xFFE60000),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _VodafoneCashIcon(),
                          SizedBox(height: 14.h),
                          Text(
                            s.vodafone_name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  Text(s.vodafone_label, style: TextStyle(fontSize: 15.sp)),
                  SizedBox(height: 4.h),
                  Text(
                    s.vodafone_terms,
                    style: TextStyle(
                      fontSize: 13.sp,
                      // color: Colors.black45,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _mobileController,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 15.sp, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: s.vodafone_hint,
                      hintStyle: TextStyle(
                        color: theme.onError,
                        fontSize: 14.sp,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 18.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(color: Color(0xFFE60000)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFE60000),
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return s.vodafone_validation_empty;
                      }
                      if (!RegExp(r'^01[0125]\d{8}$').hasMatch(v.trim())) {
                        return s.vodafone_validation_invalid;
                      }
                      return null;
                    },
                  ),

                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onSendPayment,
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: const Color(0xFF1A2A3A),
                        backgroundColor: theme.primary,
                        disabledBackgroundColor:
                            // const Color(0xFF1A2A3A).withOpacity(0.6),
                            theme.primary.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                color: const Color(0xFFCCFF00),
                              ),
                            )
                          : Text(
                              s.vodafone_send_btn,
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
      ),
    );
  }
}

class _VodafoneCashIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.w,
      height: 72.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 44.w,
            height: 66.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ColorManager.white, width: 2.w),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 6.h),
                  width: 12.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE60000),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 2.h,
            right: 7.w,
            child: Icon(
              Icons.check_circle,
              color: const Color(0xFFE60000),
              size: 26.sp,
            ),
          ),
        ],
      ),
    );
  }
}
