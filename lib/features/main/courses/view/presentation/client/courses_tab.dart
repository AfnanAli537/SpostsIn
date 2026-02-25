import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_detail_screen.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_list_screen.dart';
import 'package:sports_in/features/main/courses/view/widgets/course_card.dart';
import 'package:sports_in/features/main/courses/view/widgets/shimmer_widget.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  late final CoursesBloc _coursesBloc;

  // ✅ FIX: Store courses locally to prevent disappearing
  List<CourseModel> _enrolledCourses = [];
  List<CourseModel> _availableCourses = [];
  bool _isLoadingEnrolled = true;
  bool _isLoadingAvailable = true;

  @override
  void initState() {
    super.initState();
    _coursesBloc = getIt<CoursesBloc>();
    _loadData();
  }

  void _loadData() {
    _coursesBloc
      ..add(const FetchEnrolledCourses(page: 1, size: 10)) // ✅ Increased to 10
      ..add(
        const FetchAvailableCourses(page: 1, size: 10),
      ); // ✅ Increased to 10
  }

  @override
  void dispose() {
    // ✅ DON'T close the bloc - let it persist
    // _coursesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _coursesBloc,
      child: BlocListener<CoursesBloc, CoursesState>(
        listener: (context, state) {
          // ✅ FIX: Store courses in local state to prevent overwriting
          if (state is EnrolledCoursesLoaded) {
            setState(() {
              _enrolledCourses = state.courses;
              _isLoadingEnrolled = false;
            });
          }
          if (state is CoursesLoaded) {
            setState(() {
              _availableCourses = state.courses;
              _isLoadingAvailable = false;
            });
          }
        },
        child: _buildSliverContent(context),
      ),
    );
  }

  Widget _buildSliverContent(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: 16.h),

        // Continue Watching Section
        _buildContinueWatchingSection(context, theme, string),

        // New Courses Section (✅ Fixed with local state)
        _buildNewCoursesSection(context, theme, string),

        // Enrolled Courses Section (✅ Fixed with local state)
        _buildEnrolledCoursesSection(context, theme, string),
        SizedBox(height: 44.h),
      ]),
    );
  }

  Widget _buildContinueWatchingSection(
    BuildContext context,
    ThemeData theme,
    S string,
  ) {
    // ✅ Use local state instead of bloc state
    if (_enrolledCourses.isNotEmpty) {
      final inProgressCourses =
          _enrolledCourses
              .where((c) => c.progress > 0 && c.progress < 100)
              .toList()
            ..sort((a, b) => b.progress.compareTo(a.progress));

      if (inProgressCourses.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Continue Watching',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildLastViewedCard(
                context,
                inProgressCourses.first,
                theme,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildEnrolledCoursesSection(
    BuildContext context,
    ThemeData theme,
    S string,
  ) {
    // ✅ Use local state
    // AFTER
    if (_isLoadingEnrolled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Enrolled Courses',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8.h),
          const CoursesListShimmer(),
          SizedBox(height: 24.h),
        ],
      );
    }

    if (_enrolledCourses.isEmpty) {
      return const SizedBox.shrink();
    }

    // ✅ Show first 3 courses in horizontal scroll
    final displayCourses = _enrolledCourses.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enrolled Courses',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_enrolledCourses.length > 3)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: _coursesBloc,
                          child: const CourseListScreen(
                            listType: CourseListType.enrolled,
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Show More'),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        // ✅ Horizontal scrolling with proper sizing
        SizedBox(
          height: 320.h, // Increased height for card content
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: displayCourses.length,
            itemBuilder: (context, index) {
              final course = displayCourses[index];
              return Container(
                width: 280.w, // ✅ Fixed width for horizontal scroll
                margin: EdgeInsets.only(right: 16.w),
                child: CourseCard(
                  course: course,
                  onTap: () => _navigateToCourseDetail(context, course.id),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildNewCoursesSection(
    BuildContext context,
    ThemeData theme,
    S string,
  ) {
    // ✅ Use local state
    // AFTER
    if (_isLoadingAvailable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'New Courses',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8.h),
          const CoursesListShimmer(),
          SizedBox(height: 24.h),
        ],
      );
    }

    if (_availableCourses.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.h),
          child: Text('No courses available', style: theme.textTheme.bodyLarge),
        ),
      );
    }

    // ✅ Show first 3 courses in horizontal scroll
    final displayCourses = _availableCourses.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Courses',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_availableCourses.length > 3)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: _coursesBloc,
                          child: const CourseListScreen(
                            listType: CourseListType.available,
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Show More'),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        // ✅ Horizontal scrolling with proper sizing
        SizedBox(
          height: 320.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: displayCourses.length,
            itemBuilder: (context, index) {
              final course = displayCourses[index];
              return Container(
                width: 280.w,
                margin: EdgeInsets.only(right: 16.w),
                child: CourseCard(
                  course: course,
                  onTap: () => _navigateToCourseDetail(context, course.id),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildLastViewedCard(
    BuildContext context,
    CourseModel course,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () => _navigateToCourseDetail(context, course.id),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Stack(
                children: [
                  Image.network(
                    course.thumbnailUrl ?? '',
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180.h,
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(Icons.image_not_supported, size: 48.sp),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(205, 255, 255, 255),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            size: 32.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // SizedBox(height: 8.h),
                  // Text(course.owner.fullName, style: theme.textTheme.bodySmall),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${course.progress}% Complete',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        // course.formattedDuration,
                        '${(course.progress / 100 * course.lessonsCount).ceil()} lesson left',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  LinearProgressIndicator(
                    value: course.progress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      // theme.colorScheme.primary,
                      ColorManager.warning,
                    ),
                    minHeight: 6.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCourseDetail(BuildContext context, String courseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _coursesBloc, // ✅ Pass same bloc instance
          child: CourseDetailScreen(courseId: courseId),
        ),
      ),
    );
  }
}
