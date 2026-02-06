import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildOpportunityPreviewCard() {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    // Card uses 'shape' for border radius and 'elevation' for shadows
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
    ),
    elevation: 2, // Controls the shadow depth
    shadowColor: Colors.black.withOpacity(0.2),
    child: Padding(
      // Card doesn't have padding, so we wrap the child
      padding: EdgeInsets.all(12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              "https://placeholder.com/100", 
              width: 100.w,
              height: 120.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100.w,
                height: 120.h,
                color: Colors.grey[200],
                child: const Icon(Icons.image),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Content Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Summer Training Camp",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "End: April 20",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  "Location: City Arena",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 12.h),
                // Apply Now Button
                SizedBox(
                  width: double.infinity, // Makes the button fill the available width
                  child: ElevatedButton(
                    onPressed: () {},
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: const Color(0xFF1A2B3C), // Dark Navy Blue
                    //   foregroundColor: Colors.white,
                    //   // shape: RoundedRectangleBorder(
                    //   //   borderRadius: BorderRadius.circular(20.r),
                    //   // ),
                    //   elevation: 0,
                    // ),
                    child: Text(
                      "Apply",
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}