import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';

/// Payment is NOT integrated yet.
/// The "Pay Now" button is disabled; "Pay Later" skips payment — the ad is
/// saved as a draft on the backend and won't appear in the feed.
class AdPaymentScreen extends StatelessWidget {
  final double price;
  final String adId;

  const AdPaymentScreen({
    super.key,
    required this.price,
    required this.adId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.onSurface),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text(
          strings.completePayment,
          style: TextStyle(
            color: theme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.campaign_outlined,
                        size: 48.sp, color: theme.primary),
                    SizedBox(height: 12.h),
                    Text(
                      strings.adCreatedPendingPayment,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      strings.adSavedCompletePayment,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(strings.totalAmount,
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.grey[600])),
                        Text(
                          strings.priceEGP(price.toStringAsFixed(0)),
                          style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: theme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(strings.pricePerDay('5'),
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.amber[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.amber[700], size: 20.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        strings.paymentIntegrationComingSoon,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.amber[900],
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              CustomElevatedButton(
                text: strings.payNowComingSoon,
                onPressed: () {}, // disabled — payment not integrated
                enabled: false,
              ),
              SizedBox(height: 12.h),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.primary),
                    foregroundColor: theme.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    strings.payLaterDraft,
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}