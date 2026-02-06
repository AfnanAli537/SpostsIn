import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectButton extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onPressed;
  final String connectedText;
  final String connectText;

  const ConnectButton({
    Key? key,
    required this.isConnected,
    required this.onPressed,
    this.connectedText = 'Connected',
    this.connectText = 'Connect',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: isConnected
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.primary,
        side: BorderSide(
          color: isConnected
              ? theme.colorScheme.outline
              : theme.colorScheme.primary,
          width: 1.5.w,
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        isConnected ? connectedText : connectText,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isConnected
              ? theme.colorScheme.outline
              : theme.colorScheme.primary,
        ),
      ),
    );
  }
}