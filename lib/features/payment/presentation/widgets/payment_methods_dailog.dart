// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/generated/l10n.dart';

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
      // backgroundColor: const Color(0xFF0D1B2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding:  EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                 Expanded(
                  child: Text(
                    S.of(context).chooseMethod,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child:  Icon(
                      Icons.close,
                      // color: Colors.white54,
                      color:Theme.of(context).colorScheme.onError ,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),

             SizedBox(height: 8.h),
            Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08), height: 24.h),
            ...PaymentMethod.values.map(
              (m) => _MethodTile(method: m),
            ),

             SizedBox(height: 4.h),
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
        borderRadius: BorderRadius.circular(12.r),
        splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
        highlightColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(_icon, color: _iconColor, size: 22.sp),
              ),

               SizedBox(width: 14.h),
              Expanded(
                child: Text(
                  method.displayName,
                  style:  TextStyle(
                    // color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color:Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}