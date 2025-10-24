import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sports_in/core/constants/strings_manager.dart';
import 'package:sports_in/data/models/onboarding_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel model;
  final bool isLast;
  final bool isFirst;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;
  final VoidCallback onSkip;
  final PageController pageController;

  const OnboardingPageItem({
    super.key,
    required this.model,
    required this.isLast,
    required this.isFirst,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(model.imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45), // soft overlay
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Skip button (top-right)
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  "Skip",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
             SizedBox(height: 38.h,),
            // const Spacer(),

            // --- Title
            Text(
              StringsManager.getLocalizedString(context, model.title),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.greenAccent,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),

            // --- Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                StringsManager.getLocalizedString(context, model.description),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                
                  color: Colors.white,
                  fontSize: 15.sp,
                  height: 1.4,
                ),
              ),
            ),

            const Spacer(),

            // --- Controls row (previous, indicator, next)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button (nullable)
               // Previous button (disabled style if first page)
   TextButton(
     onPressed: isFirst ? null : onPrevious,
     style: TextButton.styleFrom(
    foregroundColor: isFirst ? Colors.white54 : Colors.white,
     ),
     child: Row(
      spacing: 5,
       children: [
              Icon(
         Icons.arrow_back_ios,
         color: isFirst ? Colors.white54 : Colors.white,
         size: 12, 
       ),
         Text(
                 "Previous",
                 style: GoogleFonts.inter(
          fontSize: 15.sp,
          color: isFirst ? Colors.white54 : Colors.white,
          fontWeight: FontWeight.w500,
                 ),
         ),
       ],
     ),
   ),

                // Indicator
                // Page Indicator
SmoothPageIndicator(
  controller: pageController,
  count: totalPages,
  effect: ExpandingDotsEffect(
    expansionFactor: 3,
    dotHeight: 8.h,
    dotWidth: 8.w,
    spacing: 6.w,
    activeDotColor: Colors.greenAccent,
    dotColor: Colors.white54,
    radius: 8.r,
  ),
),

                // Next / Get Started button
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    spacing: 5,
                    children: [
     
                      Text(
                        isLast ? "Get Started" : "Next",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                                         Icon(
         Icons.arrow_forward_ios,
         size: 12, 
         color:Colors.black ,
       ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
