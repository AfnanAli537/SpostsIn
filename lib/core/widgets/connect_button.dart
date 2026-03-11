import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ConnectionButtonState { connect, pending, accepted }

class ConnectButton extends StatelessWidget {
  /// Pass the raw connectionStatus string from the profile: null / "Pending" / "Accepted"
  final String? connectionStatus;
  final VoidCallback onPressed;

  // Optional label overrides
  final String connectText;
  final String pendingText;
  final String removeContactText;

  const ConnectButton({
    Key? key,
    required this.connectionStatus,
    required this.onPressed,
    this.connectText = 'Connect',
    this.pendingText = 'Pending',
    this.removeContactText = 'Remove Contact',
  }) : super(key: key);

  ConnectionButtonState get _state {
    switch (connectionStatus) {
      case 'Accepted':
        return ConnectionButtonState.accepted;
      case 'Pending':
        return ConnectionButtonState.pending;
      default:
        return ConnectionButtonState.connect;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String label;
    final Color foreground;
    final Color borderColor;
    final Color? bgColor;

    switch (_state) {
      case ConnectionButtonState.connect:
        label = connectText;
        foreground = theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary;
        bgColor = Colors.transparent;
        break;
      case ConnectionButtonState.pending:
        label = pendingText;
        foreground = theme.colorScheme.onSurfaceVariant;
        borderColor = theme.colorScheme.outline;
        bgColor = theme.colorScheme.surfaceVariant.withOpacity(0.4);
        break;
      case ConnectionButtonState.accepted:
        label = removeContactText;
        foreground = theme.colorScheme.error;
        borderColor = theme.colorScheme.error.withOpacity(0.6);
        bgColor = Colors.transparent;
        break;
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: foreground,
        side: BorderSide(color: borderColor, width: 1.5.w),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}