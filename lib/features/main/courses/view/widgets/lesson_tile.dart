import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/generated/l10n.dart';

class LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final bool isEnrolled;
  final VoidCallback onTap;
  final S string;

  const LessonTile({
    super.key,
    required this.lesson,
    required this.isEnrolled,
    required this.onTap,
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPlay = isEnrolled;

    return InkWell(
      onTap: canPlay ? onTap : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: lesson.isWatched
                ? theme.colorScheme.primary.withOpacity(0.3)
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            // Play icon with watched indicator
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: lesson.isWatched
                    ? theme.colorScheme.primary.withOpacity(0.2) 
                    : theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                lesson.isWatched ? Icons.check_circle : Icons.play_arrow,
                color: lesson.isWatched
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withOpacity(0.7),
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Lesson info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        string.lessonNumber(lesson.order), 
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (lesson.isWatched) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            string.watched, 
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (lesson.description != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      lesson.description!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        lesson.formattedDuration,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (lesson.progressPercentage > 0) ...[
                        SizedBox(width: 16.w),
                        Text(
                          string.percentageWatched(
                            lesson.progressPercentage.toInt().toString(),
                          ), 
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (lesson.progressPercentage > 0 && !lesson.isWatched)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: LinearProgressIndicator(
                        value: lesson.progressPercentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                        minHeight: 4.h,
                      ),
                    ),
                ],
              ),
            ),

            // Arrow or lock icon
            Icon(
              canPlay ? Icons.arrow_forward_ios : Icons.lock_outline, 
              size: 16.sp,
              color: canPlay
                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                  : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}