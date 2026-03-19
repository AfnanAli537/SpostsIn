import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/presentation/fawray_screen.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class FawryMobileScreen extends StatefulWidget {
  final SubscriptionPlanModel plan;

  /// Defaults to [PaymentTargetType.supscription] to keep backward
  /// compatibility with the existing subscription flow.
  final PaymentTargetType targetType;

  const FawryMobileScreen({
    super.key,
    required this.plan,
    this.targetType = PaymentTargetType.supscription,
  });

  @override
  State<FawryMobileScreen> createState() => _FawryMobileScreenState();
}

class _FawryMobileScreenState extends State<FawryMobileScreen> {
  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (!_formKey.currentState!.validate()) return;
    final mobile = _mobileController.text.trim();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<PaymentBloc>(),
          child: FawryScreen(
            plan: widget.plan,
            mobileNumber: mobile,
            targetType: widget.targetType, // ← forward targetType
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: theme.onSurface),
        ),
        title: Text(
          s.fawry_mobile_appbar_title,
          style:
              TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
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
                    color: const Color(0xFFF5C400),
                    child: Center(
                      child: Container(
                        width: 130.w,
                        height: 130.w,
                        decoration: BoxDecoration(
                          color: ColorManager.white,
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
                Text(s.fawry_mobile_label,
                    style: TextStyle(fontSize: 15.sp)),
                SizedBox(height: 4.h),
                Text(
                  s.fawry_mobile_terms,
                  style: TextStyle(
                      fontSize: 13.sp, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  style: TextStyle(fontSize: 15.sp),
                  decoration: InputDecoration(
                    hintText: s.fawry_mobile_hint,
                    hintStyle: TextStyle(
                        color: theme.onError, fontSize: 14.sp),
                    prefixIcon: Icon(Icons.phone_android,
                        color: const Color(0xFFF5C400), size: 22.sp),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 18.h),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: theme.onSurface),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(
                          color: Color(0xFFF5C400), width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(
                          color: Colors.red, width: 1.5),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return s.fawry_mobile_validation_empty;
                    }
                    if (!RegExp(r'^01[0125]\d{8}$').hasMatch(v.trim())) {
                      return s.fawry_mobile_validation_invalid;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _onConfirm(),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      elevation: 0,
                    ),
                    child: Text(
                      s.fawry_mobile_confirm_btn,
                      style: TextStyle(
                        color: const Color(0xFFF5C400),
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