import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomElevatedButton extends StatelessWidget {
  
  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  const CustomElevatedButton({super.key, required this.text, required this.onPressed,  this.enabled=true});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize:  Size(double.infinity, 50.h),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryFixed, 
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
