import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final bool showProgress; // For enrolled courses
  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.showProgress = false,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          boxShadow: [/* ... */],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: Image.network(
                    course.thumbnailUrl ?? '',
                    height: 120.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Free badge
                if (course.isFree)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text('FREE'),
                    ),
                  ),
              ],
            ),
            
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  
                  // Provider info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12.r,
                        backgroundImage: NetworkImage(
                          course.provider.profilePictureUrl ?? '',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        course.provider.fullName,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  
                  // Stats row
                  Row(
                    children: [
                      Icon(Icons.play_circle_outline, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text('${course.totalLessons} lessons'),
                      SizedBox(width: 16.w),
                      Icon(Icons.star, size: 16.sp, color: Colors.amber),
                      SizedBox(width: 4.w),
                      Text('${course.rating}'),
                    ],
                  ),
                  
                  // Progress bar (if enrolled and showProgress)
                  if (showProgress && course.progressPercent != null) ...[
                    SizedBox(height: 8.h),
                    LinearProgressIndicator(
                      value: course.progressPercent! / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${course.progressPercent}% complete',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                  
                  // Price or enrolled badge
                  SizedBox(height: 8.h),
                  if (!course.isEnrolled)
                    Text(
                      course.isFree ? 'FREE' : '${course.price} ${course.currency}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: course.isFree ? Colors.green : Colors.black,
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Enrolled',
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
}