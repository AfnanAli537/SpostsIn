import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A dialog shown when payment completes successfully.
/// Auto-dismisses after [autoDismissAfter] duration (default 3 seconds).
/// Has no button — caller controls dismissal via [onDismissed] callback.
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   barrierDismissible: false,
///   builder: (_) => PaymentSuccessDialog(
///     transactionId: 'RTXN-SPORTSIN-998877',
///     onDismissed: () { /* navigate or continue */ },
///   ),
/// );
/// ```
class PaymentSuccessDialog extends StatefulWidget {
  final String transactionId;

  /// Called after the animation finishes and the dialog auto-closes.
  final VoidCallback? onDismissed;

  /// How long to wait before auto-dismissing (default: 3 seconds).
  final Duration autoDismissAfter;

  const PaymentSuccessDialog({
    super.key,
    required this.transactionId,
    this.onDismissed,
    this.autoDismissAfter = const Duration(seconds: 3),
  });

  @override
  State<PaymentSuccessDialog> createState() => _PaymentSuccessDialogState();
}

class _PaymentSuccessDialogState extends State<PaymentSuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();

    // Fade + slide-up entrance
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();

    // Auto-dismiss
    Future.delayed(widget.autoDismissAfter, () {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onDismissed?.call();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideIn,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Lottie success animation ──
                // Swap with local asset:
                // Lottie.asset('assets/lottie/payment_success.json', width: 110, height: 110, repeat: false)
                Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                  width: 110,
                  height: 110,
                  fit: BoxFit.contain,
                  repeat: false,
                  frameBuilder: (context, child, composition) {
                    if (composition == null) {
                      return const SizedBox(
                        width: 110,
                        height: 110,
                        child: Center(
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF4CAF50),
                            size: 64,
                          ),
                        ),
                      );
                    }
                    return child;
                  },
                ),

                const SizedBox(height: 16),

                // ── Title ──
                const Text(
                  'Payment Successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 10),

                // ── Body copy ──
                const Text(
                  'Your video analysis will start shortly.\nSit tight — we\'re on it! 🎬',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 14),

                // ── Transaction ID ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Transaction ID: ${widget.transactionId}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Auto-dismiss indicator ──
                const _CountdownDots(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated bouncing dots indicating auto-dismiss is in progress
class _CountdownDots extends StatefulWidget {
  const _CountdownDots();

  @override
  State<_CountdownDots> createState() => _CountdownDotsState();
}

class _CountdownDotsState extends State<_CountdownDots>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _anims = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      _controllers.add(ctrl);
      _anims.add(
        Tween<double>(begin: 0, end: -6).animate(
          CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
        ),
      );
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _anims[i],
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _anims[i].value),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}