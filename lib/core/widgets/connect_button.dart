// core/widgets/connect_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ConnectionButtonState { connect, pendingSent, pendingReceived, accepted }

class ConnectButton extends StatelessWidget {
  final String? connectionStatus;
  final VoidCallback onPressed;          // Used for Connect / Remove Contact
  final VoidCallback? onAccept;          // Called when Accept is tapped
  final VoidCallback? onReject;          // Called when Reject is tapped

  final String connectText;
  final String pendingText;
  final String removeContactText;
  final String acceptText;
  final String rejectText;

  const ConnectButton({
    super.key,
    required this.connectionStatus,
    required this.onPressed,
    this.onAccept,
    this.onReject,
    this.connectText = 'Connect',
    this.pendingText = 'Pending',
    this.removeContactText = 'Remove Contact',
    this.acceptText = 'Accept',
    this.rejectText = 'Reject',
  });

  ConnectionButtonState get _state {
    switch (connectionStatus) {
      case 'Accepted':
        return ConnectionButtonState.accepted;
      case 'Pending_Sent':
      case 'Pending':
        return ConnectionButtonState.pendingSent;
      case 'Pending_Received':
        return ConnectionButtonState.pendingReceived;
      default:
        return ConnectionButtonState.connect;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show Accept / Reject row for incoming requests
    if (_state == ConnectionButtonState.pendingReceived) {
      return _AcceptRejectRow(
        onAccept: onAccept ?? () {},
        onReject: onReject ?? () {},
        acceptText: acceptText,
        rejectText: rejectText,
      );
    }

    // Single button for all other states
    final theme = Theme.of(context);

    String label;
    Color foreground;
    Color borderColor;
    Color? bgColor;
    bool enabled = true;

    switch (_state) {
      case ConnectionButtonState.connect:
        label = connectText;
        foreground = theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary;
        bgColor = Colors.transparent;
        break;
      case ConnectionButtonState.pendingSent:
        label = pendingText;
        foreground = theme.colorScheme.onError;
        borderColor = theme.colorScheme.onError;
        bgColor = theme.colorScheme.surfaceVariant.withOpacity(0.4);
        enabled = false; // Disabled while pending
        break;
      case ConnectionButtonState.accepted:
        label = removeContactText;
        foreground = theme.colorScheme.error;
        borderColor = theme.colorScheme.error.withOpacity(0.6);
        bgColor = Colors.transparent;
        break;
      default:
        label = connectText;
        foreground = theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary;
        bgColor = Colors.transparent;
    }

    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: foreground,
        disabledForegroundColor: foreground,
        disabledBackgroundColor: bgColor,
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

// Two‑button row for incoming requests
class _AcceptRejectRow extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final String acceptText;
  final String rejectText;

  const _AcceptRejectRow({
    required this.onAccept,
    required this.onReject,
    required this.acceptText,
    required this.rejectText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onAccept,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              acceptText,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: OutlinedButton(
            onPressed: onReject,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(
                color: theme.colorScheme.error.withOpacity(0.6),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              rejectText,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}