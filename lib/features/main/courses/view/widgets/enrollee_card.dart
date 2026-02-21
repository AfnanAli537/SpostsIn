import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';

class EnrolleeCard extends StatelessWidget {
  final EnrolleeModel enrollee;
  final VoidCallback onTap;
const EnrolleeCard({super.key, 
    required this.enrollee,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(enrollee.profilePictureUrl ?? ''),
        ),
        title: Text(enrollee.fullName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(enrollee.role),
            SizedBox(height: 4.h),
            LinearProgressIndicator(
              value: enrollee.progressPercent / 100,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${enrollee.progressPercent}%',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              enrollee.performanceLabel,
              style: TextStyle(
                fontSize: 12.sp,
                color: _getPerformanceColor(enrollee.performanceLabel),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getPerformanceColor(String label) {
    switch (label.toLowerCase()) {
      case 'good':
        return Colors.green;
      case 'average':
        return Colors.orange;
      case 'needs improvement':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}