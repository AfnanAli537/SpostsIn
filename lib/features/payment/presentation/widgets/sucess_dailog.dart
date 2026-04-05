import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sports_in/generated/l10n.dart';

class PaymentSuccessDialog extends StatefulWidget {
  final String transactionId;
  final VoidCallback? onDismissed;
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 36.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                  width: 110.w,
                  height: 110.h,
                  fit: BoxFit.contain,
                  repeat: false,
                  frameBuilder: (context, child, composition) {
                    if (composition == null) {
                      return SizedBox(
                        width: 110.w,
                        height: 110.h,
                        child: Center(
                          child: Icon(
                            Icons.check_circle_outline,
                            color: const Color(0xFF4CAF50),
                            size: 64.sp,
                          ),
                        ),
                      );
                    }
                    return child;
                  },
                ),

                SizedBox(height: 16.h),

                Text(
                  S.of(context).payment_success_title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),

                SizedBox(height: 10.h),

                Text(
                  S.of(context).payment_success_subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF757575),
                    height: 1.6,
                  ),
                ),

                SizedBox(height: 14.h),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color:Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    S.of(context).payment_success_transaction_id(
                       widget.transactionId,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF9E9E9E),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
                const _CountdownDots(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
        Tween<double>(
          begin: 0,
          end: -6,
        ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut)),
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
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: 7.w,
              height: 7.w,
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
