import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/video_player_screen.dart';
import 'package:sports_in/features/main/courses/view/widgets/lesson_tile.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class LessonsScreen extends StatefulWidget {
  final String courseId;
  final bool isEnrolled;

  const LessonsScreen({
    super.key,
    required this.courseId,
    required this.isEnrolled,
  });

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(FetchCourseLessons(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state is CoursesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LessonsLoaded) {
          if (state.lessons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library_outlined,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    // string.noLessons ?? 
                    'No lessons available',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CoursesBloc>().add(
                    FetchCourseLessons(courseId: widget.courseId),
                  );
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: state.lessons.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final lesson = state.lessons[index];
                final canPlay = state.isEnrolled || (lesson.videoUrl != null);

                return LessonTile(
                  lesson: lesson,
                  isEnrolled: state.isEnrolled,
                  onTap: canPlay
                      ? () => _navigateToVideoPlayer(lesson, state.lessons)
                      : () => _showEnrollmentRequired(context),
                );
              },
            ),
          );
        }

        if (state is CoursesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: theme.colorScheme.error,
                ),
                SizedBox(height: 16.h),
                Text(
                  state.message,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<CoursesBloc>().add(
                          FetchCourseLessons(courseId: widget.courseId),
                        );
                  },
                  child: Text(string.retry),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _navigateToVideoPlayer(LessonModel lesson, List<LessonModel> allLessons) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CoursesBloc>(),
          child: VideoPlayerScreen(
            lesson: lesson,
            allLessons: allLessons,
            courseId: widget.courseId,
          ),
        ),
      ),
    );
  }

  void _showEnrollmentRequired(BuildContext context) {
    final string = S.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          // string.enrollmentRequired ?? 
          'Enrollment Required'),
        content: Text(
          // string.enrollmentRequiredMessage ??
              'You need to enroll in this course to access this lesson.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(string.ok),
          ),
        ],
      ),
    );
  }
}