// widgets/course_progress_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/generated/l10n.dart';

class CourseProgressTab extends StatelessWidget {
  final CourseModel course;

  const CourseProgressTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressCard(theme, string),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildStat(
                  string.completed,
                  '${(course.lessonsCount * course.progress / 100).round()}/${course.lessonsCount}',
                  Icons.check_circle,
                  Colors.green,
                  theme,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildStat(
                  string.timeSpent,
                  '${(course.totalDurationHours * course.progress / 100).toStringAsFixed(1)}h',
                  Icons.access_time,
                  Colors.blue,
                  theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(ThemeData theme, S string) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            '${_formatProgress(course.progress)}%',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            string.courseProgress,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: 16.h),
          LinearProgressIndicator(
            value: course.progress / 100,
            minHeight: 8.h,
            backgroundColor: theme.colorScheme.surface,
            valueColor: const AlwaysStoppedAnimation<Color>(ColorManager.warning),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32.sp, color: color),
          SizedBox(height: 8.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatProgress(num value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}