import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/inline_lesson_video_player.dart';
import 'package:sports_in/features/main/courses/view/presentation/provider/edit_lesson_screen.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/enrollees_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/revenue_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/provider/upload_video_screen.dart';
import 'package:sports_in/features/main/courses/view/widgets/shimmer_widget.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/features/main/courses/view/widgets/inline_edit_dialog.dart';
import 'package:sports_in/generated/l10n.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  CourseModel? _course;
  LessonModel? _currentPlayingLesson;
  bool _isEditMode = false;
  bool _hasUnsavedChanges = false;
  bool _lessonsReordered = false;
  File? _newThumbnail;
  // Temporary edit values (only used in edit mode)
  late TextEditingController _titleEditController;
  late TextEditingController _descriptionEditController;
  late TextEditingController _priceEditController;
  bool _isFreeEdit = false;
  List<LessonModel> _allLessons = [];

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(
      FetchCourseDetail(courseId: widget.courseId),
    );
    _tabController = TabController(length: 2, vsync: this);
    _titleEditController = TextEditingController();
    _descriptionEditController = TextEditingController();
    _priceEditController = TextEditingController();
  }

  @override
  void dispose() {
    _titleEditController.dispose();
    _descriptionEditController.dispose();
    _priceEditController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  // ==================== EDIT MODE METHODS ====================

  void _enterEditMode(CourseModel course) {
    setState(() {
      _isEditMode = true;
      _titleEditController.text = course.title;
      _descriptionEditController.text = course.description ?? '';
      _priceEditController.text = course.price.toString();
      _isFreeEdit = course.isFree;
      _newThumbnail = null; // ✅ Reset thumbnail
      _hasUnsavedChanges = false;
    });
  }

  void _cancelEditMode() {
    setState(() {
      _isEditMode = false;
      _hasUnsavedChanges = false;
    });
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }
  Future<void> _pickThumbnail() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1920,
    maxHeight: 1080,
    imageQuality: 85,
  );

  if (image != null) {
    setState(() {
      _newThumbnail = File(image.path);
      _onFieldChanged();
    });
  }
}
  Future<void> _saveAllChanges(CourseModel course) async {
    // Validate
    if (_titleEditController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Title cannot be empty',
        backgroundColor: Colors.orange,
      );
      return;
    }

    if (!_isFreeEdit) {
      final price = double.tryParse(_priceEditController.text);
      if (price == null || price < 0) {
        Fluttertoast.showToast(
          msg: 'Invalid price',
          backgroundColor: Colors.orange,
        );
        return;
      }
    }

    // Save all changes
    final newPrice = _isFreeEdit
        ? 0.0
        : double.parse(_priceEditController.text);

    context.read<CoursesBloc>().add(
      UpdateCourse(
        courseId: course.id,
        title: _titleEditController.text.trim(),
        description: _descriptionEditController.text.trim(),
        price: newPrice,
        sportTypeId: course.sportTypeId,
        thumbnail: _newThumbnail ?? course.thumbnailUrl ?? '',
      ),
    );

    setState(() {
      _isEditMode = false;
      _hasUnsavedChanges = false;
      _newThumbnail = null;
    });

    Fluttertoast.showToast(
      msg: 'Saving changes...',
      backgroundColor: Colors.blue,
    );
  }

  void _updateTabController(CourseModel course) {
    if (_course == null ||
        _course!.isOwner != course.isOwner ||
        _course!.isEnrolled != course.isEnrolled) {
      _tabController.dispose();

      int tabLength = 2; // Default: Lessons, Description
      if (course.isOwner) {
        tabLength = 4; // Lessons, Description, Enrolled, Revenue
      } else if (course.isEnrolled) {
        tabLength = 3; // Lessons, Description, Progress
      }

      _tabController = TabController(length: tabLength, vsync: this);
      _course = course;

      // Fetch lessons
      context.read<CoursesBloc>().add(
        FetchCourseLessons(courseId: widget.courseId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return BlocConsumer<CoursesBloc, CoursesState>(
      listener: (context, state) {
        if (state is EnrollmentSuccess) {
          Fluttertoast.showToast(
            msg: 'Enrolled successfully',
            backgroundColor: Colors.green,
          );
          context.read<CoursesBloc>().add(
            FetchCourseDetail(courseId: widget.courseId),
          );
        } else if (state is CourseDeleted) {
          Fluttertoast.showToast(
            msg: 'Course deleted',
            backgroundColor: Colors.green,
          );
          Navigator.pop(context, true);
        } else if (state is CoursesError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
          );
        }
      },
      buildWhen: (previous, current) {
        return current is CourseDetailLoading ||
            current is CourseDetailLoaded ||
            (current is CoursesError && previous is! CourseDetailLoaded);
      },
      builder: (context, state) {
        if (_course != null &&
            (state is CoursesLoading || state is LessonsLoaded)) {
          return _buildDetailScreen(_course!, theme, string);
        }

        if (state is CourseDetailLoading) {
          return Scaffold(appBar: AppBar(), body: const CourseDetailShimmer());
        }

        if (state is CourseDetailLoaded) {
          _updateTabController(state.course);
          return _buildDetailScreen(state.course, theme, string);
        }

        if (state is CoursesError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: theme.colorScheme.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(state.message, textAlign: TextAlign.center),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoursesBloc>().add(
                        FetchCourseDetail(courseId: widget.courseId),
                      );
                    },
                    child: Text(string.retry),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(appBar: AppBar(), body: const CourseDetailShimmer());
      },
    );
  }

  Widget _buildDetailScreen(CourseModel course, ThemeData theme, S string) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (course.isOwner)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  if (_isEditMode) {
                    _cancelEditMode();
                  } else {
                    _enterEditMode(course);
                  }
                } else if (value == 'delete') {
                  _showDeleteConfirmation(course.id);
                } else if (value == 'add_lesson') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<CoursesBloc>(),
                        child: UploadVideoScreen(
                          courseId: course.id,
                          existingLessonsCount: course.lessonsCount,
                        ),
                      ),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'add_lesson',
                  child: Row(
                    children: [
                      Icon(Icons.video_library),
                      SizedBox(width: 8),
                      Text('Add Lesson'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(_isEditMode ? Icons.close : Icons.edit),
                      const SizedBox(width: 8),
                      Text(_isEditMode ? 'Cancel Edit' : 'Edit Course'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red[700])),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(child: _buildVideoOrThumbnail(course)),
            SliverPersistentHeader(
              pinned: true, // This keeps the tabs visible at the top
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: _buildTabs(course, string),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _buildTabViews(course, theme, string),
        ),
      ),
      bottomNavigationBar: !course.isOwner && !course.isEnrolled
          ? _buildEnrollButton(course, theme, string)
          : null,
    );
  }

  Widget _buildVideoOrThumbnail(CourseModel course) {
    return Container(
      // Ensure the background is black for videos
      color: Colors.black,
      constraints: BoxConstraints(
        // Limits height on large screens but allows it to be responsive
        maxHeight: 0.4.sh,
      ),
      width: double.infinity,
      child: _currentPlayingLesson != null
          ? AspectRatio(
              aspectRatio: 16 / 9, // Force standard video ratio
              child: InlineLessonVideoPlayer(
                lesson: _currentPlayingLesson!,
                courseId: widget.courseId,
                allLessons: _allLessons,
                onBack: () => setState(() => _currentPlayingLesson = null),
                onNextLesson: (next) =>
                    setState(() => _currentPlayingLesson = next),
                onPreviousLesson: (prev) =>
                    setState(() => _currentPlayingLesson = prev),
              ),
            )
          : course.thumbnailUrl != null
          ? Image.network(
              course.thumbnailUrl!,
              fit: BoxFit.cover,
              height: 200.h,
              errorBuilder: (context, _, __) => Container(
                height: 200.h,
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported, size: 48.sp),
              ),
            )
          : SizedBox(height: 100.h), // Placeholder if no thumbnail
    );
  }

  List<Widget> _buildTabs(CourseModel course, S string) {
    final tabs = <Widget>[
      const Tab(text: 'Lessons'),
      Tab(text: string.description),
    ];

    if (course.isOwner) {
      tabs.addAll([const Tab(text: 'Enrolled'), const Tab(text: 'Revenue')]);
    } else if (course.isEnrolled) {
      tabs.add(const Tab(text: 'Progress'));
    }

    return tabs;
  }

  List<Widget> _buildTabViews(CourseModel course, ThemeData theme, S string) {
    final views = <Widget>[
      _buildLessonsTab(course, theme, string),
      _buildDescriptionTab(course, theme, string),
    ];

    if (course.isOwner) {
      views.addAll([
        EnrolleesScreen(courseId: course.id),
        RevenueScreen(courseId: course.id),
      ]);
    } else if (course.isEnrolled) {
      views.add(_buildProgressTab(course, theme, string));
    }

    return views;
  }

// ==================== LESSONS TAB WITH REORDER & UPDATE ====================

Widget _buildLessonsTab(CourseModel course, ThemeData theme, S string) {
  return BlocBuilder<CoursesBloc, CoursesState>(
    builder: (context, state) {
      if (state is LessonsLoaded) {
        if (state.lessons != _allLessons) {
          _allLessons = List.from(state.lessons);
          _lessonsReordered = false;
        }
        
        if (_allLessons.isEmpty) {
          return _buildEmptyLessonsState(course, theme, string);
        }

        return Column(
          children: [
            // ✅ Save Changes button (appears when reordered in edit mode)
            if (_lessonsReordered && course.isOwner && _isEditMode)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                color: Colors.blue.withOpacity(0.1),
                child: ElevatedButton.icon(
                  onPressed: () => _saveReorderedLessons(),
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),

            // ✅ Lessons list - reorderable ONLY in edit mode
            Expanded(
              child: course.isOwner && _isEditMode
                  ? _buildReorderableLessonsList(course, theme, string)
                  : _buildRegularLessonsList(course, theme, string),
            ),
          ],
        );
      }

      if (state is CoursesError) {
        return _buildLessonsErrorState(state.message, theme, string);
      }

      return const LessonsListShimmer();
    },
  );
}
// ==================== SAVE REORDERED LESSONS ====================

void _saveReorderedLessons() {
  // Update all lessons with new order
  for (int i = 0; i < _allLessons.length; i++) {
    final lesson = _allLessons[i];
    final newOrder = i + 1;
    
    if (lesson.order != newOrder) {
      context.read<CoursesBloc>().add(
        UpdateLesson(
          lessonId: lesson.id,
          title: lesson.title,
          description: lesson.description ?? '',
          duration: lesson.duration,
          order: newOrder,
          video: lesson.videoUrl ?? '',
        ),
      );
    }
  }

  setState(() {
    _lessonsReordered = false;
  });

  Fluttertoast.showToast(
    msg: 'Saving lesson order...',
    backgroundColor: Colors.green,
  );

  // Refresh lessons
  Future.delayed(const Duration(seconds: 1), () {
    if (mounted) {
      context.read<CoursesBloc>().add(
        FetchCourseLessons(courseId: widget.courseId),
      );
    }
  });
}

// ==================== REORDERABLE LESSONS (OWNERS) ====================

Widget _buildReorderableLessonsList(CourseModel course, ThemeData theme, S string) {
  return RefreshIndicator(
    onRefresh: () async {
      context.read<CoursesBloc>().add(
            FetchCourseLessons(courseId: widget.courseId),
          );
      await Future.delayed(const Duration(milliseconds: 500));
    },
    child: ReorderableListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: _allLessons.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          
          // Reorder locally
          final lesson = _allLessons.removeAt(oldIndex);
          _allLessons.insert(newIndex, lesson);
          
          // Mark as reordered
          _lessonsReordered = true;
        });
      },
      itemBuilder: (context, index) {
        final lesson = _allLessons[index];
        final isCurrentlyPlaying = _currentPlayingLesson?.id == lesson.id;
        
        return _buildOwnerLessonCard(
          lesson,
          course.isEnrolled,
          isCurrentlyPlaying,
          theme,
          string,
          index,
        );
      },
    ),
  );
}

// ==================== OWNER LESSON CARD (with Update menu) ====================

Widget _buildOwnerLessonCard(
  LessonModel lesson,
  bool isEnrolled,
  bool isCurrentlyPlaying,
  ThemeData theme,
  S string,
  int index,
) {
  // ✅ Owner can always watch their own videos (no enrollment check)
  final canPlay = true; // Provider can always watch

  return Container(
    key: ValueKey(lesson.id),
    margin: EdgeInsets.only(bottom: 12.h),
    child: InkWell(
      onTap: () {
        setState(() {
          _currentPlayingLesson = lesson;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isCurrentlyPlaying
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isCurrentlyPlaying
                ? theme.colorScheme.primary
                : Colors.grey[300]!,
            width: isCurrentlyPlaying ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Drag handle
            Icon(
              Icons.drag_handle,
              color: Colors.grey[600],
              size: 24.sp,
            ),
            SizedBox(width: 12.w),

            // Status icon (play button)
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_circle_outline,
                color: theme.colorScheme.primary,
                size: 32.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Lesson info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lesson ${lesson.order}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
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
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDuration(lesson.duration),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ✅ Menu with Update and Delete options
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 20.sp),
              onSelected: (value) {
                if (value == 'update') {
                  _navigateToEditLesson(lesson);
                } else if (value == 'delete') {
                  _deleteLesson(lesson);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'update',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18.sp),
                      SizedBox(width: 8.w),
                      const Text('Update'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18.sp, color: Colors.red[700]),
                      SizedBox(width: 8.w),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// ==================== ADD Delete Lesson Method ====================

Future<void> _deleteLesson(LessonModel lesson) async {
  final confirmed = await InlineEditDialog.showConfirmation(
    context: context,
    title: 'Delete Lesson',
    message: 'Are you sure you want to delete "${lesson.title}"? This action cannot be undone.',
    confirmText: 'Delete',
    isDestructive: true,
  );

  if (confirmed) {
    context.read<CoursesBloc>().add(
      DeleteLesson(lessonId: lesson.id),
    );
    
    Fluttertoast.showToast(
      msg: 'Deleting lesson...',
      backgroundColor: Colors.orange,
    );
    
    // Refresh lessons after deletion
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.read<CoursesBloc>().add(
          FetchCourseLessons(courseId: widget.courseId),
        );
      }
    });
  }
}
// ==================== NAVIGATE TO EDIT LESSON ====================

void _navigateToEditLesson(LessonModel lesson) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: context.read<CoursesBloc>(),
        child: EditLessonScreen(
          lesson: lesson,
          courseId: widget.courseId,
        ),
      ),
    ),
  ).then((updated) {
    // Refresh lessons if updated
    if (updated == true) {
      context.read<CoursesBloc>().add(
        FetchCourseLessons(courseId: widget.courseId),
      );
    }
  });
}
Widget _buildOwnerRegularLessonCard(
  LessonModel lesson,
  bool isCurrentlyPlaying,
  ThemeData theme,
  S string,
) {
  return Container(
    key: ValueKey(lesson.id),
    margin: EdgeInsets.only(bottom: 12.h),
    child: InkWell(
      onTap: () {
        setState(() {
          _currentPlayingLesson = lesson;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isCurrentlyPlaying
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isCurrentlyPlaying
                ? theme.colorScheme.primary
                : Colors.grey[300]!,
            width: isCurrentlyPlaying ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // ✅ NO drag handle when not in edit mode
            // Play icon
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_circle_outline,
                color: theme.colorScheme.primary,
                size: 32.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Lesson info (same as before)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lesson ${lesson.order}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
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
                    ],
                  ),
                ],
              ),
            ),

            // Update/Delete menu (always visible for owner)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 20.sp),
              onSelected: (value) {
                if (value == 'update') {
                  _navigateToEditLesson(lesson);
                } else if (value == 'delete') {
                  _deleteLesson(lesson);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'update',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18.sp),
                      SizedBox(width: 8.w),
                      const Text('Update'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18.sp, color: Colors.red[700]),
                      SizedBox(width: 8.w),
                      Text('Delete', style: TextStyle(color: Colors.red[700])),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
// ==================== REGULAR LESSONS (NON-OWNERS) ====================
Widget _buildRegularLessonsList(CourseModel course, ThemeData theme, S string) {
  return RefreshIndicator(
    onRefresh: () async {
      context.read<CoursesBloc>().add(
            FetchCourseLessons(courseId: widget.courseId),
          );
      await Future.delayed(const Duration(milliseconds: 500));
    },
    child: ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: _allLessons.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final lesson = _allLessons[index];
        final isCurrentlyPlaying = _currentPlayingLesson?.id == lesson.id;
        
        // ✅ CHANGE: Show owner card (with menu) or student card
        return course.isOwner
            ? _buildOwnerRegularLessonCard(lesson, isCurrentlyPlaying, theme, string)
            : _buildLessonCard(lesson, course.isEnrolled, isCurrentlyPlaying, theme, string);
      },
    ),
  );
}
  Widget _buildEmptyLessonsState(
    CourseModel course,
    ThemeData theme,
    S string,
  ) {
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
            'No lessons available',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
          if (course.isOwner) ...[
            SizedBox(height: 8.h),
            Text(
              'Tap the + button to add your first lesson',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildLessonCard(
    LessonModel lesson,
    bool isEnrolled,
    bool isCurrentlyPlaying,
    ThemeData theme,
    S string,
  ) {
    final canPlay = isEnrolled;

    return InkWell(
      onTap: canPlay
          ? () {
              setState(() {
                _currentPlayingLesson = lesson;
              });
            }
          : null,
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
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: lesson.isWatched
                    ? Colors.green.withOpacity(0.2)
                    : theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                lesson.isWatched
                    ? Icons.check_circle
                    : Icons.play_circle_outline,
                color: lesson.isWatched
                    ? Colors.green
                    : theme.colorScheme.primary,
                size: 32.sp,
              ),
            ),
            SizedBox(width: 16.w),

            Expanded(
              child: Column(
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
                      if (lesson.isWatched) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      if (isCurrentlyPlaying) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Playing',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDuration(lesson.duration),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (lesson.progressPercentage > 0 &&
                          !lesson.isWatched) ...[
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                      minHeight: 4.h,
                    ),
                  ],
                ],
              ),
            ),

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


  // ==================== ENHANCED DESCRIPTION TAB ====================
Widget _buildDescriptionTab(CourseModel course, ThemeData theme, S string) {
  return SingleChildScrollView(
    padding: EdgeInsets.all(16.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Thumbnail (editable in edit mode)
        if (_isEditMode) ...[
          Text(
            'Course Thumbnail',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: _pickThumbnail,
            child: Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: _newThumbnail != null 
                      ? Colors.green 
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: _newThumbnail != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.file(
                            _newThumbnail!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    )
                  : course.thumbnailUrl != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                course.thumbnailUrl!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 40.sp,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'Tap to change',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 48.sp,
                              color: Colors.grey[600],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Tap to upload thumbnail',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
            ),
          ),
          SizedBox(height: 16.h),
        ],

        // ✅ Title (editable in edit mode)
        if (_isEditMode)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Title',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _titleEditController,
                onChanged: (_) => _onFieldChanged(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  hintText: 'Enter course title',
                ),
                style: theme.textTheme.titleLarge,
              ),
            ],
          )
        else
          Text(
            course.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        SizedBox(height: 16.h),

          // Owner info
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: course.owner.profilePictureUrl != null
                    ? NetworkImage(course.owner.profilePictureUrl!)
                    : null,
                child: course.owner.profilePictureUrl == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.owner.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${course.enrolledUsersCount} students',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Course stats
          Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 16.sp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 4.w),
              Text(
                '${course.lessonsCount} lessons',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(width: 16.w),
              Icon(
                Icons.access_time,
                size: 16.sp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 4.w),
              Text(course.formattedDuration, style: theme.textTheme.bodyMedium),
            ],
          ),
          SizedBox(height: 16.h),

          // ✅ Price (editable in edit mode)
          if (_isEditMode)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Checkbox(
                      value: _isFreeEdit,
                      onChanged: (value) {
                        setState(() {
                          _isFreeEdit = value ?? false;
                          if (_isFreeEdit) {
                            _priceEditController.text = '0';
                          }
                          _onFieldChanged();
                        });
                      },
                    ),
                    Text('Free Course'),
                    SizedBox(width: 16.w),
                    if (!_isFreeEdit)
                      Expanded(
                        child: TextField(
                          controller: _priceEditController,
                          onChanged: (_) => _onFieldChanged(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            hintText: 'Price',
                            suffixText: 'EGP',
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: course.isFree
                    ? Colors.green.withOpacity(0.1)
                    : theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                course.isFree ? 'FREE' : '${course.price} EGP',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: course.isFree
                      ? Colors.green
                      : theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          SizedBox(height: 24.h),

          // ✅ Description (editable in edit mode)
          Text(
            string.description,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          if (_isEditMode)
            TextField(
              controller: _descriptionEditController,
              onChanged: (_) => _onFieldChanged(),
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                hintText: 'Enter course description',
              ),
            )
          else if (course.description != null && course.description!.isNotEmpty)
            Text(course.description!, style: theme.textTheme.bodyMedium)
          else
            Text(
              'No description available.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),

          // ✅ Save/Cancel buttons in edit mode
          if (_isEditMode) ...[
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelEditMode,
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hasUnsavedChanges
                        ? () => _saveAllChanges(course)
                        : null,
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressTab(CourseModel course, ThemeData theme, S string) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Text(
                  '${formatProgress(course.progress)}%',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Course Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 16.h),
                LinearProgressIndicator(
                  value: course.progress / 100,
                  minHeight: 8.h,
                  backgroundColor: theme.colorScheme.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ColorManager.warning,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          Row(
            children: [
              Expanded(
                child: _buildProgressStat(
                  'Completed',
                  '${(course.lessonsCount * course.progress / 100).round()}/${course.lessonsCount}',
                  Icons.check_circle,
                  Colors.green,
                  theme,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildProgressStat(
                  'Time Spent',
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

  Widget _buildProgressStat(
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

  String _formatDuration(double durationSeconds) {
    final totalSeconds = durationSeconds.round();
    if (totalSeconds < 60) {
      return '${totalSeconds}s';
    }
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes < 60) {
      return seconds > 0 ? '${minutes}m ${seconds}s' : '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return remainingMinutes > 0
        ? '${hours}h ${remainingMinutes}m'
        : '${hours}h';
  }

  Widget _buildLessonsErrorState(String message, ThemeData theme, S string) {
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
            message,
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

  Widget _buildEnrollButton(CourseModel course, ThemeData theme, S string) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) {
            final isLoading = state is EnrollmentLoading;
            return CustomElevatedButton(
              text: course.isFree
                  ? 'Enroll Now'
                  : 'Enroll for ${course.price} EGP',
              isLoading: isLoading,
              onPressed: isLoading
                  ? () => {}
                  : () {
                      context.read<CoursesBloc>().add(
                        EnrollInCourse(courseId: course.id),
                      );
                    },
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String courseId) {
    ConfirmationDialog.show(
      context: context,
      title: 'Delete Course',
      message:
          'Are you sure you want to delete this course? This action cannot be undone.',
      onConfirm: () {
        context.read<CoursesBloc>().add(DeleteCourse(courseId: courseId));
      },
      confirmText: S.of(context).delete,
      cancelText: S.of(context).cancel,
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }

  String formatProgress(num value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Matches screen bg
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
