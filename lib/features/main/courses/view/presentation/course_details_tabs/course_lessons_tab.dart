import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/widgets/lesson_card.dart';
import 'package:sports_in/features/main/courses/view/widgets/owner_lesson_card.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class CourseLessonsTab extends StatefulWidget {
  final CourseModel course;
  final List<LessonModel> lessons;
  final LessonModel? currentPlayingLesson;
  final bool isEditMode;
  final VoidCallback onRefresh;
  final Function(LessonModel) onLessonTap;
  final Function(LessonModel) onUpdateLesson;
  final Function(LessonModel) onDeleteLesson;

  const CourseLessonsTab({
    super.key,
    required this.course,
    required this.lessons,
    this.currentPlayingLesson,
    required this.isEditMode,
    required this.onRefresh,
    required this.onLessonTap,
    required this.onUpdateLesson,
    required this.onDeleteLesson,
  });

  @override
  State<CourseLessonsTab> createState() => _CourseLessonsTabState();
}

class _CourseLessonsTabState extends State<CourseLessonsTab> {
  late List<LessonModel> _lessons;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Sort by current order so the list always starts in the correct order
    _lessons = [...widget.lessons]..sort((a, b) => a.order.compareTo(b.order));
  }

  @override
  void didUpdateWidget(CourseLessonsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync if parent pushed a fresh lesson list (e.g. after refresh)
    if (oldWidget.lessons != widget.lessons) {
      setState(() {
        _lessons = [...widget.lessons]
          ..sort((a, b) => a.order.compareTo(b.order));
      });
    }
  }

  // ── Reorder ───────────────────────────────────────────────────────────────

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      // ReorderableListView gives newIndex AFTER the removal of oldIndex,
      // so we correct for that here.
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _lessons.removeAt(oldIndex);
      _lessons.insert(newIndex, item);
    });
  }

  void _saveReorder() {
    context.read<CoursesBloc>().add(
          ReorderLessons(
            courseId: widget.course.id,
            reorderedLessons: _lessons,
          ),
        );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    if (_lessons.isEmpty) {
      return _buildEmptyState(Theme.of(context), strings);
    }

    return BlocConsumer<CoursesBloc, CoursesState>(
      listenWhen: (_, current) =>
          current is LessonsReorderSuccess ||
          current is LessonsReorderLoading ||
          current is CoursesError,
      listener: (context, state) {
        if (state is LessonsReorderLoading) {
          setState(() => _isSaving = true);
        } else if (state is LessonsReorderSuccess) {
          setState(() {
            _isSaving = false;
            _lessons = [...state.lessons]
              ..sort((a, b) => a.order.compareTo(b.order));
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(strings.lessonOrderSaved),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is CoursesError) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final hasUnsavedChanges = _hasOrderChanged();

        return Column(
          children: [
            if (widget.course.isOwner &&
                widget.isEditMode &&
                hasUnsavedChanges)
              _buildSaveBar(strings),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => widget.onRefresh(),
                child: widget.course.isOwner && widget.isEditMode
                    ? _buildReorderableList()
                    : _buildRegularList(strings),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _hasOrderChanged() {
    for (int i = 0; i < _lessons.length; i++) {
      if (_lessons[i].order != i + 1) return true;
    }
    return false;
  }


  Widget _buildSaveBar(S string) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      color: theme.colorScheme.onError.withOpacity(0.1),
      child: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton.icon(
              onPressed: _saveReorder,
              icon: const Icon(Icons.save),
              label: Text(string.save, style: TextStyle(color: theme.colorScheme.onPrimary)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
    );
  }

  Widget _buildRegularList(S string) {
    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: _lessons.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        final isPlaying = widget.currentPlayingLesson?.id == lesson.id;
        if (widget.course.isOwner) {
          return OwnerLessonCard(
            lesson: lesson,
            isCurrentlyPlaying: isPlaying,
            onTap: () => widget.onLessonTap(lesson),
            onUpdate: () => widget.onUpdateLesson(lesson),
            onDelete: () => widget.onDeleteLesson(lesson),
            showDragHandle: false,
          );
        }
        return LessonCard(
          lesson: lesson,
          isEnrolled: widget.course.isEnrolled,
          isCurrentlyPlaying: isPlaying,
          onTap: () => widget.onLessonTap(lesson),
          string: string,
        );
      },
    );
  }

  Widget _buildReorderableList() {
    return ReorderableListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: _lessons.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        final isPlaying = widget.currentPlayingLesson?.id == lesson.id;
        return OwnerLessonCard(
          key: ValueKey(lesson.id),
          lesson: lesson,
          isCurrentlyPlaying: isPlaying,
          onTap: () => widget.onLessonTap(lesson),
          onUpdate: () => widget.onUpdateLesson(lesson),
          onDelete: () => widget.onDeleteLesson(lesson),
          showDragHandle: true,
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, S strings) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined,
              size: 64.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(strings.noLessonsAvailable,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: Colors.grey[600])),
          if (widget.course.isOwner) ...[
            SizedBox(height: 8.h),
            Text(strings.tapToAddFirstLesson,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.grey[500])),
          ],
        ],
      ),
    );
  }
}