import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';

class EnrolleeCard extends StatelessWidget {
  final EnrolledUserModel enrollee; // ✅ Changed from EnrolleeModel
  final VoidCallback onTap;

  const EnrolleeCard({
    super.key,
    required this.enrollee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24.r,
          backgroundImage: enrollee.profilePictureUrl != null
              ? NetworkImage(enrollee.profilePictureUrl!)
              : null,
          child: enrollee.profilePictureUrl == null
              ? Icon(Icons.person, size: 24.sp)
              : null,
        ),
        title: Text(
          enrollee.fullName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12.sp, color: Colors.grey),
                SizedBox(width: 4.w),
                Text(
                  _formatDate(enrollee.enrolledAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: enrollee.progress / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(enrollee.progress),
              ),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 60.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${enrollee.progress}%',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: _getProgressColor(enrollee.progress),
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _getProgressColor(enrollee.progress).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  _getPerformanceLabel(enrollee.progress),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: _getProgressColor(enrollee.progress),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  String _getPerformanceLabel(int progress) {
    if (progress >= 75) {
      return 'Excellent';
    } else if (progress >= 50) {
      return 'Good';
    } else if (progress >= 25) {
      return 'Average';
    } else {
      return 'Needs Work';
    }
  }

  Color _getProgressColor(int progress) {
    if (progress >= 75) {
      return Colors.green;
    } else if (progress >= 50) {
      return Colors.blue;
    } else if (progress >= 25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}