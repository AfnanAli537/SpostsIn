import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sports_in/generated/l10n.dart';

class ProcessingPaymentDialog extends StatelessWidget {
  const ProcessingPaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.network(
              'https://assets10.lottiefiles.com/packages/lf20_szviypry.json',
              width: 100.w,
              height: 100.h,
              fit: BoxFit.contain,
              frameBuilder: (context, child, composition) {
                if (composition == null) {
                  return SizedBox(
                    width: 100.w,
                    height: 100.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.w,
                      color: const Color(0xFF424242),
                    ),
                  );
                }
                return child;
              },
            ),
            SizedBox(height: 24.h),
            Text(
              S.of(context).processing_payment_title,
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
              S.of(context).processing_payment_subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF757575),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}