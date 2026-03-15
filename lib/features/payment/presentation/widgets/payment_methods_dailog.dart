import 'package:flutter/material.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';

/// A dialog for selecting a payment method.
///
/// Returns the chosen [PaymentMethod] via [Navigator.pop], or null if dismissed.
///
/// Usage:
/// ```dart
/// final method = await showPaymentMethodDialog(context);
/// if (method != null) { /* handle selection */ }
/// ```
Future<PaymentMethod?> showPaymentMethodDialog(BuildContext context) {
  return showDialog<PaymentMethod>(
    context: context,
    builder: (_) => const PaymentMethodDialog(),
  );
}

class PaymentMethodDialog extends StatelessWidget {
  const PaymentMethodDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0D1B2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Choose Payment Method',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white54,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Divider ──
            Divider(color: Colors.white.withOpacity(0.08), height: 24),

            // ── Method tiles ──
            ...PaymentMethod.values.map(
              (m) => _MethodTile(method: m),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final PaymentMethod method;

  const _MethodTile({required this.method});

  Color get _iconBg {
    switch (method) {
      case PaymentMethod.creditCard:
        return const Color(0xFF1A3A6E);
      case PaymentMethod.mobileWallet:
        return const Color(0xFF6E1A1A);
      case PaymentMethod.fawryPay:
        return const Color(0xFF4A3800);
    }
  }

  Color get _iconColor {
    switch (method) {
      case PaymentMethod.creditCard:
        return const Color(0xFF1A6EE8);
      case PaymentMethod.mobileWallet:
        return const Color(0xFFE53935);
      case PaymentMethod.fawryPay:
        return const Color(0xFFFFB300);
    }
  }

  IconData get _icon {
    switch (method) {
      case PaymentMethod.creditCard:
        return Icons.credit_card;
      case PaymentMethod.mobileWallet:
        return Icons.account_balance_wallet;
      case PaymentMethod.fawryPay:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(method),
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.06),
        highlightColor: Colors.white.withOpacity(0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              // ── Icon container ──
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon, color: _iconColor, size: 22),
              ),

              const SizedBox(width: 14),

              // ── Label ──
              Expanded(
                child: Text(
                  method.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // ── Chevron ──
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}