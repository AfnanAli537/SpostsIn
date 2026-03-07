// course_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/course_description_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/course_lessons_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/course_progress_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/enrollees_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/revenue_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/provider/edit_lesson_screen.dart';
import 'package:sports_in/features/main/courses/view/presentation/provider/upload_video_screen.dart';
import 'package:sports_in/features/main/courses/view/widgets/course_header.dart';
import 'package:sports_in/features/main/courses/view/widgets/inline_edit_dialog.dart';
import 'package:sports_in/features/main/courses/view/widgets/shimmer_widget.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';
import 'dart:io';

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
  List<LessonModel> _allLessons = [];
  LessonModel? _currentPlayingLesson;

  // Edit mode state
  bool _isEditMode = false;
  bool _hasUnsavedChanges = false;
  bool _lessonsReordered = false;
  File? _newThumbnail;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  bool _isFreeEdit = false;

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(
      FetchCourseDetail(courseId: widget.courseId),
    );
    _tabController = TabController(length: 2, vsync: this);
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CourseDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseId != widget.courseId) {
      // Course changed – reset all local state
      setState(() {
        _course = null;
        _allLessons = [];
        _currentPlayingLesson = null;
        _isEditMode = false;
        _hasUnsavedChanges = false;
        _lessonsReordered = false;
        _newThumbnail = null;
      });
      // Fetch new course details
      context.read<CoursesBloc>().add(
        FetchCourseDetail(courseId: widget.courseId),
      );
    }
  }

  void _updateTabController(CourseModel course) {
    // If the course ID changed, clear lessons
    if (_course?.id != course.id) {
      _allLessons = [];
      _lessonsReordered = false;
      _currentPlayingLesson = null;
    }

    // Rebuild tabs only if ownership/enrollment changed
    if (_course == null ||
        _course!.isOwner != course.isOwner ||
        _course!.isEnrolled != course.isEnrolled) {
      _tabController.dispose();
      int length = 2;
      if (course.isOwner)
        length = 4;
      else if (course.isEnrolled)
        length = 3;
      _tabController = TabController(length: length, vsync: this);
    }

    _course = course;
    // Always fetch fresh lessons for the current course
    context.read<CoursesBloc>().add(
      FetchCourseLessons(courseId: widget.courseId),
    );
  }

  // Edit mode methods
  void _enterEditMode(CourseModel course) {
    setState(() {
      _isEditMode = true;
      _titleController.text = course.title;
      _descriptionController.text = course.description ?? '';
      _priceController.text = course.price.toString();
      _isFreeEdit = course.isFree;
      _newThumbnail = null;
      _hasUnsavedChanges = false;
    });
  }

  void _cancelEditMode() => setState(() {
    _isEditMode = false;
    _hasUnsavedChanges = false;
  });
  void _onFieldChanged() => setState(() => _hasUnsavedChanges = true);
  Future<void> _pickThumbnail() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (picked != null)
      setState(() {
        _newThumbnail = File(picked.path);
        _onFieldChanged();
      });
  }

  Future<void> _saveAllChanges(CourseModel course) async {
    if (_titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Title cannot be empty',
        backgroundColor: Colors.orange,
      );
      return;
    }
    if (!_isFreeEdit) {
      final price = double.tryParse(_priceController.text);
      if (price == null || price < 0) {
        Fluttertoast.showToast(
          msg: 'Invalid price',
          backgroundColor: Colors.orange,
        );
        return;
      }
    }
    final newPrice = _isFreeEdit ? 0.0 : double.parse(_priceController.text);
    context.read<CoursesBloc>().add(
      UpdateCourse(
        courseId: course.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: newPrice,
        sportTypeId: course.sportTypeId,
        thumbnail: _newThumbnail?.path ?? course.thumbnailUrl ?? '',
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

  void _saveReorderedLessons() {
    for (int i = 0; i < _allLessons.length; i++) {
      final l = _allLessons[i];
      if (l.order != i + 1) {
        context.read<CoursesBloc>().add(
          UpdateLesson(
            lessonId: l.id,
            title: l.title,
            description: l.description ?? '',
            duration: l.duration,
            order: i + 1,
            video: l.videoUrl ?? '',
          ),
        );
      }
    }
    setState(() => _lessonsReordered = false);
    Fluttertoast.showToast(
      msg: 'Saving lesson order...',
      backgroundColor: Colors.green,
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted)
        context.read<CoursesBloc>().add(
          FetchCourseLessons(courseId: widget.courseId),
        );
    });
  }

  Future<void> _deleteLesson(LessonModel lesson) async {
    final confirmed = await InlineEditDialog.showConfirmation(
      context: context,
      title: 'Delete Lesson',
      message:
          'Are you sure you want to delete "${lesson.title}"? This action cannot be undone.',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed) {
      context.read<CoursesBloc>().add(DeleteLesson(lessonId: lesson.id));

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

  void _navigateToEditLesson(LessonModel lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CoursesBloc>(),
          child: EditLessonScreen(lesson: lesson, courseId: widget.courseId),
        ),
      ),
    ).then((updated) {
      if (updated == true)
        context.read<CoursesBloc>().add(
          FetchCourseLessons(courseId: widget.courseId),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
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
            current is LessonsLoaded ||
            (current is CoursesError && previous is! CourseDetailLoaded);
      },
      builder: (context, state) {
        // Load course and lessons
        if (_course == null && state is CourseDetailLoaded)
          _updateTabController(state.course);
        if (state is LessonsLoaded && state.courseId == widget.courseId) {
          if (state.lessons != _allLessons) {
            _allLessons = List.from(state.lessons);
            _lessonsReordered = false;
          }
        }
        final course =
            _course ?? (state is CourseDetailLoaded ? state.course : null);
        if (course == null)
          return Scaffold(appBar: AppBar(), body: const CourseDetailShimmer());

        return Scaffold(
          appBar: AppBar(
            title: Text(
              course.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: _buildAppBarActions(course),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(
                child: CourseHeader(
                  currentPlayingLesson: _currentPlayingLesson,
                  allLessons: _allLessons,
                  courseId: widget.courseId,
                  thumbnailUrl: course.thumbnailUrl,
                  onBack: () => setState(() => _currentPlayingLesson = null),
                  onNextLesson: (l) =>
                      setState(() => _currentPlayingLesson = l),
                  onPreviousLesson: (l) =>
                      setState(() => _currentPlayingLesson = l),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: _buildTabs(course),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: _buildTabViews(course),
            ),
          ),
          bottomNavigationBar: (!course.isOwner && !course.isEnrolled)
              ? _buildEnrollButton(course)
              : null,
        );
      },
    );
  }

  List<Widget> _buildTabs(CourseModel course) {
    final tabs = [
      const Tab(text: 'Lessons'),
      Tab(text: S.of(context).description),
    ];
    if (course.isOwner) {
      tabs.addAll([const Tab(text: 'Enrolled'), const Tab(text: 'Revenue')]);
    } else if (course.isEnrolled) {
      tabs.add(const Tab(text: 'Progress'));
    }
    return tabs;
  }

  List<Widget> _buildTabViews(CourseModel course) {
    final theme = Theme.of(context);
    final string = S.of(context);
    final views = <Widget>[
      CourseLessonsTab(
        course: course,
        lessons: _allLessons,
        currentPlayingLesson: _currentPlayingLesson,
        isEditMode: _isEditMode,
        lessonsReordered: _lessonsReordered,
        onRefresh: () => context.read<CoursesBloc>().add(
          FetchCourseLessons(courseId: widget.courseId),
        ),
        onReorder: (oldI, newI) {
          setState(() {
            if (oldI < newI) newI--;
            final l = _allLessons.removeAt(oldI);
            _allLessons.insert(newI, l);
            _lessonsReordered = true;
          });
        },
        onSaveReorder: _saveReorderedLessons,
        onLessonTap: (l) => setState(() => _currentPlayingLesson = l),
        onUpdateLesson: _navigateToEditLesson,
        onDeleteLesson: _deleteLesson,
      ),
      CourseDescriptionTab(
        course: course,
        isEditMode: _isEditMode,
        hasUnsavedChanges: _hasUnsavedChanges,
        newThumbnail: _newThumbnail,
        titleController: _titleController,
        descriptionController: _descriptionController,
        priceController: _priceController,
        isFree: _isFreeEdit,
        onPickThumbnail: _pickThumbnail,
        onCancelEdit: _cancelEditMode,
        onSaveChanges: () => _saveAllChanges(course),
        onFreeChanged: (v) => _isFreeEdit = v,
        onFieldChanged: _onFieldChanged,
      ),
    ];
    if (course.isOwner) {
      views.add(EnrolleesTab(courseId: course.id));
      views.add(RevenueTab(courseId: course.id));
    } else if (course.isEnrolled) {
      views.add(CourseProgressTab(course: course));
    }
    return views;
  }

  List<Widget> _buildAppBarActions(CourseModel course) {
    if (!course.isOwner) return [];
    return [
      PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            if (_isEditMode)
              _cancelEditMode();
            else
              _enterEditMode(course);
          } else if (value == 'delete') {
            _showDeleteConfirmation(course.id);
          } else if (value == 'add_lesson') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<CoursesBloc>(),
                  child: UploadLessonScreen(
                    courseId: course.id,
                    existingLessonsCount: course.lessonsCount,
                  ),
                ),
              ),
            );
          }
        },
        itemBuilder: (_) => [
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
                SizedBox(width: 8),
                Text(_isEditMode ? 'Cancel Edit' : 'Edit Course'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildEnrollButton(CourseModel course) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
                  ? () {}
                  : () => context.read<CoursesBloc>().add(
                      EnrollInCourse(courseId: course.id),
                    ),
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
      message: 'Are you sure you want to delete this course?',
      onConfirm: () =>
          context.read<CoursesBloc>().add(DeleteCourse(courseId: courseId)),
      confirmText: S.of(context).delete,
      cancelText: S.of(context).cancel,
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: _tabBar,
  );
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
