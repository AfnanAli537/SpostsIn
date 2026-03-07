import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final bool isEnrolled;
  final bool isCurrentlyPlaying;
  final VoidCallback? onTap;

  const LessonCard({
    Key? key,
    required this.lesson,
    required this.isEnrolled,
    required this.isCurrentlyPlaying,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPlay = isEnrolled;

    return InkWell(
      onTap: canPlay ? onTap : null,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isCurrentlyPlaying
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: lesson.isWatched
                ? theme.colorScheme.primary.withOpacity(0.3)
                : (isCurrentlyPlaying
                    ? theme.colorScheme.primary
                    : Colors.grey[300]!),
            width: isCurrentlyPlaying ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            _buildStatusIcon(theme),
            SizedBox(width: 16.w),
            Expanded(child: _buildContent(theme)),
            Icon(
              canPlay ? Icons.arrow_forward_ios : Icons.lock_outline,
              size: 20.sp,
              color: canPlay
                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                  : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(ThemeData theme) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: lesson.isWatched
            ? Colors.green.withOpacity(0.2)
            : theme.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        lesson.isWatched ? Icons.check_circle : Icons.play_circle_outline,
        color: lesson.isWatched ? Colors.green : theme.colorScheme.primary,
        size: 32.sp,
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Lesson ${lesson.order}',
              style: TextStyle(
                fontSize: 12.sp,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (lesson.isWatched) _buildLabel('Completed', Colors.green),
            if (isCurrentlyPlaying) _buildLabel('Playing', theme.colorScheme.primary),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          lesson.title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.access_time, size: 14.sp, color: Colors.grey[600]),
            SizedBox(width: 4.w),
            Text(
              _formatDuration(lesson.duration),
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            if (lesson.progressPercentage > 0 && !lesson.isWatched) ...[
              SizedBox(width: 16.w),
              Text(
                '${lesson.progressPercentage.toInt()}% watched',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        if (lesson.progressPercentage > 0 && !lesson.isWatched) ...[
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: lesson.progressPercentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            minHeight: 4.h,
          ),
        ],
      ],
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      margin: EdgeInsets.only(left: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  String _formatDuration(double seconds) {
    final total = seconds.round();
    if (total < 60) return '${total}s';
    final minutes = total ~/ 60;
    final secs = total % 60;
    if (minutes < 60) return secs > 0 ? '${minutes}m ${secs}s' : '${minutes}m';
    final hours = minutes ~/ 60;
    final remMins = minutes % 60;
    return remMins > 0 ? '${hours}h ${remMins}m' : '${hours}h';
  }
}