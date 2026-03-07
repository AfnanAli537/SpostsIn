import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/widgets/lesson_card.dart';
import 'package:sports_in/features/main/courses/view/widgets/owner_lesson_card.dart';
import 'package:sports_in/generated/l10n.dart';

class CourseLessonsTab extends StatelessWidget {
  final CourseModel course;
  final List<LessonModel> lessons;
  final LessonModel? currentPlayingLesson;
  final bool isEditMode;
  final bool lessonsReordered;
  final VoidCallback onRefresh;
  final Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onSaveReorder;
  final Function(LessonModel) onLessonTap;
  final Function(LessonModel) onUpdateLesson;
  final Function(LessonModel) onDeleteLesson;

  const CourseLessonsTab({
    Key? key,
    required this.course,
    required this.lessons,
    this.currentPlayingLesson,
    required this.isEditMode,
    required this.lessonsReordered,
    required this.onRefresh,
    required this.onReorder,
    required this.onSaveReorder,
    required this.onLessonTap,
    required this.onUpdateLesson,
    required this.onDeleteLesson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    if (lessons.isEmpty) {
      return _buildEmptyState(theme, string);
    }

    return Column(
      children: [
        if (lessonsReordered && course.isOwner && isEditMode)
          _buildSaveBar(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => onRefresh(),
            child: course.isOwner && isEditMode
                ? _buildReorderableList(theme)
                : _buildRegularList(theme, string),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      color: Colors.blue.withOpacity(0.1),
      child: ElevatedButton.icon(
        onPressed: onSaveReorder,
        icon: const Icon(Icons.save),
        label: const Text('Save Changes'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildRegularList(ThemeData theme, S string) {
    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: lessons.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        final isPlaying = currentPlayingLesson?.id == lesson.id;
        if (course.isOwner) {
          return OwnerLessonCard(
            lesson: lesson,
            isCurrentlyPlaying: isPlaying,
            onTap: () => onLessonTap(lesson),
            onUpdate: () => onUpdateLesson(lesson),
            onDelete: () => onDeleteLesson(lesson),
            showDragHandle: false,
          );
        } else {
          return LessonCard(
            lesson: lesson,
            isEnrolled: course.isEnrolled,
            isCurrentlyPlaying: isPlaying,
            onTap: () => onLessonTap(lesson),
          );
        }
      },
    );
  }

  Widget _buildReorderableList(ThemeData theme) {
    return ReorderableListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: lessons.length,
      onReorder: onReorder,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        final isPlaying = currentPlayingLesson?.id == lesson.id;
        return OwnerLessonCard(
          key: ValueKey(lesson.id),
          lesson: lesson,
          isCurrentlyPlaying: isPlaying,
          onTap: () => onLessonTap(lesson),
          onUpdate: () => onUpdateLesson(lesson),
          onDelete: () => onDeleteLesson(lesson),
          showDragHandle: true,
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, S string) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined, size: 64.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text('No lessons available', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
          if (course.isOwner) ...[
            SizedBox(height: 8.h),
            Text('Tap the + button to add your first lesson',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
          ],
        ],
      ),
    );
  }
}