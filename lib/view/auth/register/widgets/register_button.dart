import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';

class RegisterButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  const RegisterButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        enabled ? ColorManager.lightPrimary : Colors.grey.shade300;
    final textColor =
        enabled ? ColorManager.lightAccent : Colors.grey.shade500;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: enabled ? onPressed : null,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
