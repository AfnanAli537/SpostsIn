import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';

// class LessonTile extends StatelessWidget {
//   final LessonModel lesson;
//   final bool isEnrolled;
//   final VoidCallback onTap;
//   const LessonTile({
//     super.key,
//     required this.lesson,
//     required this.isEnrolled,
//     required this.onTap,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final canPlay = isEnrolled || (lesson.isPreview ?? false);
    
//     return ListTile(
//       leading: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Thumbnail
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8.r),
//             child: Image.network(
//               lesson.thumbnailUrl ?? '',
//               width: 60.w,
//               height: 45.h,
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Play/Lock icon
//           CircleAvatar(
//             radius: 16.r,
//             backgroundColor: Colors.black.withOpacity(0.7),
//             child: Icon(
//               canPlay ? Icons.play_arrow : Icons.lock,
//               color: Colors.white,
//               size: 20.sp,
//             ),
//           ),
//         ],
//       ),
//       title: Text(
//         '${lesson.order}. ${lesson.title}',
//         maxLines: 2,
//         overflow: TextOverflow.ellipsis,
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(lesson.durationFormatted),
//           if (lesson.isWatched)
//             Row(
//               children: [
//                 Icon(Icons.check_circle, size: 16.sp, color: Colors.green),
//                 SizedBox(width: 4.w),
//                 Text('Completed', style: TextStyle(color: Colors.green)),
//               ],
//             )
//           else if (lesson.watchedDurationSeconds > 0)
//             LinearProgressIndicator(
//               value: lesson.progressPercentage / 100,
//               backgroundColor: Colors.grey[200],
//             ),
//         ],
//       ),
//       trailing: lesson.isWatched
//           ? Icon(Icons.check_circle, color: Colors.green)
//           : null,
//       onTap: canPlay ? onTap : null,
//     );
//   }
// }

class LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final bool isEnrolled;
  final VoidCallback? onTap;
  const LessonTile({
    super.key,
    required this.lesson,
    required this.isEnrolled,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          Icon(Icons.play_circle_outline, size: 48.sp),
          if (!isEnrolled)
            Icon(Icons.lock, size: 24.sp), // Locked
        ],
      ),
      title: Text('${lesson.order}. ${lesson.title}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lesson.description != null)
            Text(lesson.description!),
          Text(lesson.formattedDuration),
          if (lesson.isWatched)
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                Text('Completed'),
              ],
            )
          else if (lesson.watchedTime > 0)
            LinearProgressIndicator(
              value: lesson.progressPercentage / 100,
            ),
        ],
      ),
      trailing: lesson.isWatched
          ? Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: isEnrolled ? onTap : null, // Only clickable if enrolled
    );
  }
}