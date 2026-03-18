import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A full-screen blocking dialog shown while a payment is being processed.
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   barrierDismissible: false,
///   builder: (_) => const ProcessingPaymentDialog(),
/// );
/// ```
class ProcessingPaymentDialog extends StatelessWidget {
  const ProcessingPaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.network(
              'https://assets10.lottiefiles.com/packages/lf20_szviypry.json',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              frameBuilder: (context, child, composition) {
                if (composition == null) {
                  return const SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFF424242),
                    ),
                  );
                }
                return child;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Processing Payment...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please do not close the app',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}