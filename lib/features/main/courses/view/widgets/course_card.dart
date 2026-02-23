import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // ✅ Fix overflow in Column
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: Image.network(
                course.thumbnailUrl ?? '',
                height: 160.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported, size: 48.sp),
                ),
              ),
            ),

            // ✅ Use Flexible/Expanded for content to prevent overflow
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      course.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),

                    // Description
                    if (course.description != null && course.description!.isNotEmpty)
                      Text(
                        course.description!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 8.h),

                    // // Provider info
                    // Row(
                    //   children: [
                    //     CircleAvatar(
                    //       radius: 12.r,
                    //       backgroundImage: course.owner.profilePictureUrl != null
                    //           ? NetworkImage(course.owner.profilePictureUrl!)
                    //           : null,
                    //       child: course.owner.profilePictureUrl == null
                    //           ? Icon(Icons.person, size: 16.sp)
                    //           : null,
                    //     ),
                    //     SizedBox(width: 8.w),
                    //     Expanded(
                    //       child: Text(
                    //         course.owner.fullName,
                    //         style: theme.textTheme.bodySmall,
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 8.h),

                    // ✅ FIXED: Stats row with Flexible widgets to prevent overflow
                    // Row(
                    //   children: [
                    //     // Lessons count
                    //     Flexible(
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Icon(Icons.play_circle_outline, size: 14.sp),
                    //           SizedBox(width: 4.w),
                    //           Flexible(
                    //             child: Text(
                    //               '${course.lessonsCount}',
                    //               style: theme.textTheme.bodySmall,
                    //               overflow: TextOverflow.ellipsis,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     SizedBox(width: 8.w),
                        
                    //     // Duration
                    //     Flexible(
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Icon(Icons.access_time, size: 14.sp),
                    //           SizedBox(width: 4.w),
                    //           Flexible(
                    //             child: Text(
                    //               course.formattedDuration,
                    //               style: theme.textTheme.bodySmall,
                    //               overflow: TextOverflow.ellipsis,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     SizedBox(width: 8.w),
                        
                    //     // Enrolled users count
                    //     Flexible(
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Icon(Icons.people_outline, size: 14.sp),
                    //           SizedBox(width: 4.w),
                    //           Flexible(
                    //             child: Text(
                    //               '${course.enrolledUsersCount}',
                    //               style: theme.textTheme.bodySmall,
                    //               overflow: TextOverflow.ellipsis,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 8.h),

                    // Progress bar (if enrolled)
                    if (course.isEnrolled) ...[
                      LinearProgressIndicator(
                        value: course.progress / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${course.progress}% complete',
                        style: theme.textTheme.bodySmall,
                      ),
                      // SizedBox(height: 8.h),
                    ],

                    // Price or enrolled badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!course.isEnrolled)
                          Flexible(
                            child: Text(
                              course.isFree ? 'FREE' : '${course.price} EGP',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: course.isFree ? Colors.green : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        // else
                        //   Container(
                        //     padding: EdgeInsets.symmetric(
                        //       horizontal: 8.w,
                        //       vertical: 4.h,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: theme.colorScheme.primary,
                        //       borderRadius: BorderRadius.circular(4.r),
                        //     ),
                        //     child: Text(
                        //       'Enrolled',
                        //       style: theme.textTheme.bodySmall?.copyWith(
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),

                        // Provider controls
                        if (course.isOwner && (onEdit != null || onDelete != null))
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (onEdit != null)
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  iconSize: 20.sp,
                                  onPressed: onEdit,
                                  padding: EdgeInsets.all(4.w),
                                  constraints: const BoxConstraints(),
                                  tooltip: 'Edit',
                                ),
                              if (onDelete != null)
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red[700],
                                  ),
                                  iconSize: 20.sp,
                                  onPressed: onDelete,
                                  padding: EdgeInsets.all(4.w),
                                  constraints: const BoxConstraints(),
                                  tooltip: 'Delete',
                                ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}