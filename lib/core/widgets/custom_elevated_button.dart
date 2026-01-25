import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/color_manager.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;
  final bool isLoading;
  final IconData? icon;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = enabled && !isLoading; 

    return ElevatedButton(
      onPressed: isButtonEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: Size(double.infinity, 50.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            SizedBox(
              width: 22.w,
              height: 22.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            SizedBox(width: 10.w),
          ] else if (icon != null) ...[
            Icon(icon,
                color: Theme.of(context).colorScheme.onPrimary, size: 22),
            SizedBox(width: 8.w),
          ],
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isButtonEnabled 
                      ? Theme.of(context).colorScheme.onSecondaryFixed
                      : ColorManager.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
