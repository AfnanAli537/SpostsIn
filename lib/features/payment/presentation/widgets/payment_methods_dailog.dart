import 'package:flutter/material.dart';

// ─── Model ────────────────────────────────────
class PaymentMethod {
  final String id;
  final String title;
  final Widget icon;
  final Widget badges;

  const PaymentMethod({
    required this.id,
    required this.title,
    required this.icon,
    required this.badges,
  });
}

// ─── Dialog ───────────────────────────────────
/// A dialog presenting the available payment methods.
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => PaymentMethodsDialog(
///     onMethodSelected: (method) {
///       // method.id → 'card' | 'wallet' | 'fawry'
///     },
///   ),
/// );
/// ```
class PaymentMethodsDialog extends StatelessWidget {
  final ValueChanged<PaymentMethod>? onMethodSelected;

  const PaymentMethodsDialog({super.key, this.onMethodSelected});

  // ── Static payment method definitions ──────
  static final List<PaymentMethod> methods = [
    PaymentMethod(
      id: 'card',
      title: 'Credit / Debit Card',
      icon: _MethodIcon(
        color: const Color(0xFF1565C0),
        child: const Icon(Icons.credit_card, color: Colors.white, size: 22),
      ),
      badges: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // VISA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F71),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'VISA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Mastercard overlapping circles
          SizedBox(
            width: 34,
            height: 22,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEB001B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF79E1B).withOpacity(0.88),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    PaymentMethod(
      id: 'wallet',
      title: 'Mobile Wallet',
      icon: _MethodIcon(
        color: const Color(0xFFD32F2F),
        child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 22),
      ),
      badges: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vodafone
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                'V',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Orange
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6D00),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'O',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    ),

    PaymentMethod(
      id: 'fawry',
      title: 'Fawry Pay',
      icon: _MethodIcon(
        color: const Color(0xFFFFF8E1),
        border: Border.all(color: const Color(0xFFFFD600), width: 1.5),
        child: const Center(
          child: Text(
            'F',
            style: TextStyle(
              color: Color(0xFFF57F17),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      badges: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 16),
          const SizedBox(width: 3),
          const Text(
            'fawry',
            style: TextStyle(
              color: Color(0xFFFFB300),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header with blue border ──
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        size: 20, color: Color(0xFF424242)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                // Title with blue border box
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 52),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF1565C0), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Payment Methods',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Method list ──
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: methods.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
            itemBuilder: (context, index) {
              final method = methods[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  onMethodSelected?.call(method);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                  child: Row(
                    children: [
                      method.icon,
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          method.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF212121),
                          ),
                        ),
                      ),
                      method.badges,
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ─── Reusable icon container ──────────────────
class _MethodIcon extends StatelessWidget {
  final Color color;
  final Widget child;
  final BoxBorder? border;

  const _MethodIcon({
    required this.color,
    required this.child,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: border,
      ),
      child: child,
    );
  }
}