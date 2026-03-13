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
              ? _buildImageWidget(thumbnailUrl!)
              : _buildPlaceholder(),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            height: 200.h,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200.h,
      color: Colors.grey[300],
      child: Center(
        child: Icon(Icons.image_not_supported, size: 48.sp, color: Colors.grey[600]),
      ),
    );
  }
}