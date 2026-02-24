import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/inline_lesson_video_player.dart';
import 'package:sports_in/features/main/courses/view/presentation/provider/enrollees_screen.dart';
import 'package:sports_in/features/main/courses/view/presentation/provider/revenue_screen.dart';
import 'package:sports_in/features/main/courses/view/presentation/provider/upload_video_screen.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  CourseModel? _course;
  LessonModel? _currentPlayingLesson;
  List<LessonModel> _allLessons = [];

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(FetchCourseDetail(courseId: widget.courseId));
    _tabController = TabController(length: 2, vsync: this);
    
    // ✅ Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          // Clear playing lesson when switching tabs
          _currentPlayingLesson = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateTabController(CourseModel course) {
    if (_course == null || 
        _course!.isOwner != course.isOwner || 
        _course!.isEnrolled != course.isEnrolled) {
      _tabController.dispose();
      
      int tabLength = 2;
      if (course.isOwner) {
        tabLength = 4;
      } else if (course.isEnrolled) {
        tabLength = 3;
      }
      
      _tabController = TabController(length: tabLength, vsync: this);
      _course = course;
      
      // Listen to new controller
      _tabController.addListener(() {
        if (_tabController.indexIsChanging) {
          setState(() {
            _currentPlayingLesson = null;
          });
        }
      });
      
      context.read<CoursesBloc>().add(FetchCourseLessons(courseId: widget.courseId));
    }
  }

  // ✅ Helper to check if we're on lessons tab
  bool get _isLessonsTab {
    return _tabController.index == 1;
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
          context.read<CoursesBloc>().add(FetchCourseDetail(courseId: widget.courseId));
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
        if (_course != null && (state is CoursesLoading || state is LessonsLoaded)) {
          return _buildDetailScreen(_course!, theme, string);
        }

        if (state is CourseDetailLoading) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
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
                  Icon(Icons.error_outline, size: 64.sp, color: theme.colorScheme.error),
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

        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildDetailScreen(CourseModel course, ThemeData theme, S string) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          course.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (course.isOwner)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  // Navigate to edit screen
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
                      const Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text(string.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red[700]),
                      SizedBox(width: 8),
                      Text(string.delete, style: TextStyle(color: Colors.red[700])),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Thumbnail - hide smoothly when on lessons tab OR when video is playing
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: (_isLessonsTab || _currentPlayingLesson != null) ? 0 : 200.h,
            child: (_isLessonsTab || _currentPlayingLesson != null)
                ? const SizedBox.shrink()
                : course.thumbnailUrl != null
                    ? Image.network(
                        course.thumbnailUrl!,
                        width: double.infinity,
                        height: 200.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200.h,
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported, size: 48.sp),
                        ),
                      )
                    : const SizedBox.shrink(),
          ),
        
          // Tabs
          TabBar(
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onError,
            controller: _tabController,
            isScrollable: true,
            tabs: _buildTabs(course, string),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews(course, theme, string),
            ),
          ),
        ],
      ),
      bottomNavigationBar: !course.isOwner && !course.isEnrolled
          ? _buildEnrollButton(course, theme, string)
          : null,
    );
  }

  List<Widget> _buildTabs(CourseModel course, S string) {
    final tabs = <Widget>[
      Tab(text: string.description),
      const Tab(text: 'Lessons'),
    ];

    if (course.isOwner) {
      tabs.addAll([
        const Tab(text: 'Enrolled'),
        const Tab(text: 'Revenue'),
      ]);
    } else if (course.isEnrolled) {
      tabs.add(const Tab(text: 'Progress'));
    }

    return tabs;
  }

  List<Widget> _buildTabViews(CourseModel course, ThemeData theme, S string) {
    final views = <Widget>[
      _buildDescriptionTab(course, theme, string),
      _buildLessonsTab(course, theme, string),
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

  Widget _buildDescriptionTab(CourseModel course, ThemeData theme, S string) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

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

          Row(
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_outline, size: 16.sp, color: theme.colorScheme.primary),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        '${course.lessonsCount} lessons',
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 16.sp, color: theme.colorScheme.primary),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        course.formattedDuration,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: course.isFree ? Colors.green.withOpacity(0.1) : theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              course.isFree ? 'FREE' : '${course.price} EGP',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: course.isFree ? Colors.green : theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // ✅ Description - single line with ellipsis
          if (course.description != null && course.description!.isNotEmpty) ...[
            Text(
              string.description,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              course.description!,
              style: theme.textTheme.bodyMedium,
              maxLines: 1, // ✅ Single line
              overflow: TextOverflow.ellipsis, // ✅ Ellipsis
            ),
          ],
        ],
      ),
    );
  }

  // ✅ Lessons Tab
  Widget _buildLessonsTab(CourseModel course, ThemeData theme, S string) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state is LessonsLoaded) {
          _allLessons = state.lessons;
          
          if (state.lessons.isEmpty) {
            return _buildEmptyLessonsState(theme, string);
          }

          return Column(
            children: [
              // ✅ Video Player (if lesson selected)
              if (_currentPlayingLesson != null)
                InlineLessonVideoPlayer(
                  lesson: _currentPlayingLesson!,
                  courseId: widget.courseId,
                  allLessons: _allLessons,
                  onBack: () {
                    setState(() => _currentPlayingLesson = null);
                    context.read<CoursesBloc>().add(
                          FetchCourseLessons(courseId: widget.courseId),
                        );
                  },
                  onNextLesson: (nextLesson) {
                    setState(() => _currentPlayingLesson = nextLesson);
                  },
                  onPreviousLesson: (prevLesson) {
                    setState(() => _currentPlayingLesson = prevLesson);
                  },
                ),
              
              // ✅ Lessons List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<CoursesBloc>().add(
                          FetchCourseLessons(courseId: widget.courseId),
                        );
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.r),
                    itemCount: state.lessons.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final lesson = state.lessons[index];
                      final isCurrentlyPlaying = _currentPlayingLesson?.id == lesson.id;
                      
                      return _buildLessonCard(
                        lesson,
                        state.isEnrolled,
                        isCurrentlyPlaying,
                        theme,
                        string,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }

        if (state is CoursesError) {
          return _buildLessonsErrorState(state.message, theme, string);
        }

        return const Center(child: CircularProgressIndicator());
      },
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
                      if (lesson.progressPercentage > 0 && !lesson.isWatched) ...[
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

  Widget _buildEmptyLessonsState(ThemeData theme, S string) {
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
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
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
                  '${course.progress}%',
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
                    // theme.colorScheme.onTertiaryContainer,
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
                  ? ()=>{}
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
      message: 'Are you sure you want to delete this course? This action cannot be undone.',
      onConfirm: () {
        context.read<CoursesBloc>().add(DeleteCourse(courseId: courseId));
      },
      confirmText: S.of(context).delete,
      cancelText: S.of(context).cancel,
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }
}