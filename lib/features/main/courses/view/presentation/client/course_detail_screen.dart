import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/lessons_screen.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(FetchCourseDetail(courseId: widget.courseId));
    _tabController = TabController(length: 2, vsync: this); // Will update based on isOwner/isEnrolled
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
      
      // Determine tab count
      int tabLength = 2; // Default: Description, Lessons
      if (course.isOwner) {
        tabLength = 4; // Description, Lessons, Enrolled, Revenue
      } else if (course.isEnrolled) {
        tabLength = 3; // Description, Lessons, Progress
      }
      
      _tabController = TabController(length: tabLength, vsync: this);
      _course = course;
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
            msg:
            //  string.enrolledSuccessfully ?? 
             'Enrolled successfully',
            backgroundColor: Colors.green,
          );
          // Refresh course details
          context.read<CoursesBloc>().add(FetchCourseDetail(courseId: widget.courseId));
        } else if (state is CourseDeleted) {
          Fluttertoast.showToast(
            msg:
            //  string.courseDeleted ?? 
             'Course deleted',
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
      builder: (context, state) {
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
        title: Text(course.title),
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
                PopupMenuItem(
                  value: 'add_lesson',
                  child: Row(
                    children: [
                      const Icon(Icons.video_library),
                      SizedBox(width: 8.w),
                      Text(
                        // string.addLesson ??
                         'Add Lesson'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      SizedBox(width: 8.w),
                      Text(string.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red[700]),
                      SizedBox(width: 8.w),
                      Text(string.delete, 
                           style: TextStyle(color: Colors.red[700])),
                    ],
                  ),
                ),
              ],
            ),
        ],
        // bottom: TabBar(
        //   controller: _tabController,
        //   tabs: _buildTabs(course, string),
        // ),
      ),
      body: Column(
        children: [
                 // Thumbnail image
        if (course.thumbnailUrl != null)
           ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                course.thumbnailUrl!,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported, size: 48.sp),
                ),
              ),
            ),
        
        // ✅ Tabs here (not in AppBar)
        TabBar(
          controller: _tabController,
          tabs: _buildTabs(course, string),
        ),
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
      Tab(text: 
      // string.lessons ??
       'Lessons'),
    ];

    if (course.isOwner) {
      tabs.addAll([
        Tab(text: 
        // string.enrolled ?? 
        'Enrolled'),
        Tab(text: 
        // string.revenue ??
         'Revenue'),
      ]);
    } else if (course.isEnrolled) {
      tabs.add(Tab(text:
      //  string.progress ??
        'Progress'));
    }

    return tabs;
  }

  List<Widget> _buildTabViews(CourseModel course, ThemeData theme, S string) {
    final views = <Widget>[
      _buildDescriptionTab(course, theme, string),
      LessonsScreen(courseId: course.id, isEnrolled: course.isEnrolled),
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
          // Thumbnail
          // if (course.thumbnailUrl != null)
          //   ClipRRect(
          //     borderRadius: BorderRadius.circular(12.r),
          //     child: Image.network(
          //       course.thumbnailUrl!,
          //       width: double.infinity,
          //       height: 200.h,
          //       fit: BoxFit.cover,
          //       errorBuilder: (context, error, stackTrace) => Container(
          //         height: 200.h,
          //         color: Colors.grey[300],
          //         child: Icon(Icons.image_not_supported, size: 48.sp),
          //       ),
          //     ),
          //   ),
          // SizedBox(height: 16.h),

          // Title
          Text(
            course.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          // Provider info
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.owner.fullName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${course.enrolledUsersCount} ${
                      // string.students ??
                       "students"}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Stats
          Row(
            children: [
              _buildStatItem(
                Icons.play_circle_outline,
                '${course.lessonsCount} ${
                  // string.lessons ??
                   "lessons"}',
                theme,
              ),
              SizedBox(width: 24.w),
              _buildStatItem(
                Icons.access_time,
                course.formattedDuration,
                theme,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Price
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: course.isFree ? Colors.green.withOpacity(0.1) : theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              course.isFree ? 
              // string.free ?? 
              'FREE' : '${course.price} ${
                // string.egp ??
                 "EGP"}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: course.isFree ? Colors.green : theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Description
          if (course.description != null) ...[
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
          // Overall progress
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
                  // string.courseProgress ?? 
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
                    theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Stats
          Row(
            children: [
              Expanded(
                child: _buildProgressStat(
                  // string.completed ?? 
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
                  // string.timeSpent ?? 
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

  Widget _buildStatItem(IconData icon, String text, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: theme.colorScheme.primary),
        SizedBox(width: 4.w),
        Text(text, style: theme.textTheme.bodyMedium),
      ],
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
                  ? (
                    // string.enrollNow ??
                     'Enroll Now')
                  : '${
                    // string.enrollFor ??
                     "Enroll for"} ${course.price} ${
                      // string.egp ??
                       "EGP"}',
              isLoading: isLoading,
              onPressed: isLoading
                  ? (){}
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
      title:
      //  S.of(context).deleteCourse ?? 
       'Delete Course',
      message:
      //  S.of(context).deleteCourseConfirmation ??
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
}