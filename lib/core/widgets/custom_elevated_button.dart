import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
       final textColor =
        enabled ? ColorManager.lightAccent : ColorManager.grey;

    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
