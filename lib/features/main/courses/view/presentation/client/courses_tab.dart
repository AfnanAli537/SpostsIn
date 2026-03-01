import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_detail_screen.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_list_screen.dart';
import 'package:sports_in/features/main/courses/view/widgets/course_card.dart';
import 'package:sports_in/features/main/courses/view/widgets/courses_search_bar.dart';
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
  final TextEditingController _searchController = TextEditingController();

  List<CourseModel> _enrolledCourses = [];
  List<CourseModel> _availableCourses = [];
  bool _isLoadingEnrolled = true;
  bool _isLoadingAvailable = true;
  String _currentSearchTerm = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _coursesBloc = getIt<CoursesBloc>();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadData() {
    _coursesBloc
      ..add(FetchEnrolledCourses(
        page: 1,
        size: 10,
        searchTerm: _currentSearchTerm.isEmpty ? null : _currentSearchTerm,
      ))
      ..add(FetchAvailableCourses(
        page: 1,
        size: 10,
        searchTerm: _currentSearchTerm.isEmpty ? null : _currentSearchTerm,
      ));
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_currentSearchTerm != _searchController.text) {
        setState(() {
          _currentSearchTerm = _searchController.text;
        });
        _loadData();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return BlocProvider.value(
      value: _coursesBloc,
      child: BlocListener<CoursesBloc, CoursesState>(
        listener: (context, state) {
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
        child: SliverList(
          delegate: SliverChildListDelegate([
            // Search Bar
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: _buildSearchBar(theme, string),
            ),

            // Content
            if (_currentSearchTerm.isNotEmpty)
              _buildSearchResults(context, theme, string)
            else ...[
              _buildContinueWatchingSection(context, theme, string),
              _buildNewCoursesSection(context, theme, string),
              _buildEnrolledCoursesSection(context, theme, string),
            ],

            SizedBox(height: 100.h),
          ]),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, S string) {
    return GestureDetector(
      onTap: () {}, // Empty tap to allow text field to work
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _currentSearchTerm.isNotEmpty
                ? theme.colorScheme.primary
                : Colors.grey[300]!,
            width: _currentSearchTerm.isNotEmpty ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CoursesSearchBar(
          controller: _searchController,
          hintText: 'Search courses...',
          onChanged: (value) {
            // Handled by listener
          },
          onClear: () {
            _searchController.clear();
          },
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, ThemeData theme, S string) {
    final totalResults = _enrolledCourses.length + _availableCourses.length;

    if (_isLoadingEnrolled || _isLoadingAvailable) {
      return const CoursesListShimmer();
    }

    if (totalResults == 0) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No courses found for "${_currentSearchTerm}"',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try different keywords',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            '$totalResults ${totalResults == 1 ? 'course' : 'courses'} found',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),

        if (_availableCourses.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              'Available (${_availableCourses.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ..._availableCourses.map((course) => CourseCard(
                course: course,
                onTap: () => _navigateToCourseDetail(context, course.id),
              )),
        ],

        if (_enrolledCourses.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              'Enrolled (${_enrolledCourses.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ..._enrolledCourses.map((course) => CourseCard(
                course: course,
                onTap: () => _navigateToCourseDetail(context, course.id),
              )),
        ],
      ],
    );
  }

  Widget _buildContinueWatchingSection(
    BuildContext context,
    ThemeData theme,
    S string,
  ) {
    if (_enrolledCourses.isNotEmpty) {
      final inProgressCourses = _enrolledCourses
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
    if (_isLoadingEnrolled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Enrolled Courses',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
        SizedBox(
          height: 250.h,
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
        SizedBox(height: 36.h),
      ],
    );
  }

  Widget _buildNewCoursesSection(
    BuildContext context,
    ThemeData theme,
    S string,
  ) {
    if (_isLoadingAvailable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'New Courses',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          const CoursesListShimmer(),
          SizedBox(height: 24.h),
        ],
      );
    }

    if (_availableCourses.isEmpty) {
      return const SizedBox.shrink();
    }

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
        SizedBox(
          height: 310.h,
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
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${formatProgress(course.progress)}% Complete',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        '${course.lessonsCount-((100 - course.progress) / 100 * course.lessonsCount).ceil()} lessons left',
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

  String formatProgress(num value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }
  void _navigateToCourseDetail(BuildContext context, String courseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _coursesBloc,
          child: CourseDetailScreen(courseId: courseId),
        ),
      ),
    );
  }
}