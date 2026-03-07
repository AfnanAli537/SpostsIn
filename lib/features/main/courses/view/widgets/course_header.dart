import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/inline_lesson_video_player.dart';

class CourseHeader extends StatelessWidget {
  final LessonModel? currentPlayingLesson;
  final List<LessonModel> allLessons;
  final String courseId;
  final String? thumbnailUrl;
  final VoidCallback onBack;
  final Function(LessonModel) onNextLesson;
  final Function(LessonModel) onPreviousLesson;

  const CourseHeader({
    Key? key,
    required this.currentPlayingLesson,
    required this.allLessons,
    required this.courseId,
    this.thumbnailUrl,
    required this.onBack,
    required this.onNextLesson,
    required this.onPreviousLesson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      constraints: BoxConstraints(maxHeight: 0.4.sh),
      width: double.infinity,
      child: currentPlayingLesson != null
          ? AspectRatio(
              aspectRatio: 16 / 9,
              child: InlineLessonVideoPlayer(
                lesson: currentPlayingLesson!,
                courseId: courseId,
                allLessons: allLessons,
                onBack: onBack,
                onNextLesson: onNextLesson,
                onPreviousLesson: onPreviousLesson,
              ),
            )
          : thumbnailUrl != null
              ? Image.network(
                  thumbnailUrl!,
                  fit: BoxFit.cover,
                  height: 200.h,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                )
              : SizedBox(height: 100.h),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200.h,
      color: Colors.grey[300],
      child: Icon(Icons.image_not_supported, size: 48.sp),
    );
  }
}