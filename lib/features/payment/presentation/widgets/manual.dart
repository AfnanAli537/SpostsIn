import 'package:flutter/material.dart';

/// A simple success dialog used after manual payment activation
/// (Vodafone Cash / Fawry paths). Auto-dismisses after 3 seconds
/// and calls [onDone].
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   barrierDismissible: false,
///   builder: (_) => ManualActivationSuccessDialog(
///     message: 'Your subscription has been activated!',
///     onDone: () {
///       Navigator.pop(context); // close screen
///     },
///   ),
/// );
/// ```
class ManualActivationSuccessDialog extends StatelessWidget {
  final String message;
  final VoidCallback onDone;

  const ManualActivationSuccessDialog({
    super.key,
    required this.message,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), onDone);

    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0xFF4CAF50),
              size: 72,
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}