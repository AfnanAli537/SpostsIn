import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/color_manager.dart';

class RegisterErrorMessage extends StatelessWidget {
  final String message;

  const RegisterErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: ColorManager.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: ColorManager.error, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: ColorManager.error, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ColorManager.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
