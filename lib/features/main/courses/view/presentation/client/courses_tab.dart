import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
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

class _CoursesTabState extends State<CoursesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _refreshData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Data helpers ──────────────────────────────────────────────────────────

  void _refreshData() {
    final searchTerm = _searchController.text.trim().isEmpty
        ? null
        : _searchController.text.trim();
    context.read<CoursesBloc>()
      ..add(FetchEnrolledCourses(
        page: 1,
        size: 10,
        searchTerm: searchTerm,
        isRefresh: true,
      ))
      ..add(FetchAvailableCourses(
        page: 1,
        size: 10,
        searchTerm: searchTerm,
        isRefresh: true,
      ));
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) _refreshData();
    });
  }

  Future<void> _onRefresh() async {
    _refreshData();
    await Future.delayed(const Duration(milliseconds: 600));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: CoursesSearchBar(
                  controller: _searchController,
                  hintText: 'Search courses...',
                  onChanged: (_) {},
                  onClear: () => _searchController.clear(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _searchController.text.trim().isNotEmpty
                  ? _buildSearchResults()
                  : Column(
                      children: [
                        _buildContinueWatchingSection(),
                        _buildNewCoursesSection(),
                        _buildEnrolledCoursesSection(),
                        SizedBox(height: 270.h),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search results ────────────────────────────────────────────────────────

  Widget _buildSearchResults() {
    return BlocBuilder<CoursesBloc, CoursesState>(
      buildWhen: (_, current) =>
          current is CoursesLoaded ||
          current is EnrolledCoursesLoaded ||
          current is CoursesLoading,
      builder: (context, state) {
        final availableCourses =
            state is CoursesLoaded ? state.courses : <CourseModel>[];
        final enrolledCourses =
            state is EnrolledCoursesLoaded ? state.courses : <CourseModel>[];
        final total = availableCourses.length + enrolledCourses.length;

        if (state is CoursesLoading && total == 0) {
          return const CoursesListShimmer();
        }

        if (total == 0) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 48.h),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 64.sp, color: Colors.grey[400]),
                SizedBox(height: 16.h),
                Text(
                  'No courses found for "${_searchController.text}"',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (availableCourses.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  'Available (${availableCourses.length})',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ...availableCourses.map((c) => CourseCard(
                    course: c,
                    onTap: () => _navigateToCourseDetail(c.id),
                  )),
            ],
            if (enrolledCourses.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  'Enrolled (${enrolledCourses.length})',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ...enrolledCourses.map((c) => CourseCard(
                    course: c,
                    onTap: () => _navigateToCourseDetail(c.id),
                  )),
            ],
          ],
        );
      },
    );
  }

  // ── Continue watching ─────────────────────────────────────────────────────

  Widget _buildContinueWatchingSection() {
    return BlocBuilder<CoursesBloc, CoursesState>(
      buildWhen: (_, current) => current is EnrolledCoursesLoaded,
      builder: (context, state) {
        if (state is! EnrolledCoursesLoaded) return const SizedBox.shrink();

        final inProgress = state.courses
            .where((c) => c.progress > 0 && c.progress < 100)
            .toList()
          ..sort((a, b) => b.progress.compareTo(a.progress));

        if (inProgress.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
              child: Text(
                'Continue Watching',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildLastViewedCard(context, inProgress.first),
            ),
            SizedBox(height: 24.h),
          ],
        );
      },
    );
  }

  // ── New courses ───────────────────────────────────────────────────────────

  Widget _buildNewCoursesSection() {
    return BlocBuilder<CoursesBloc, CoursesState>(
      buildWhen: (_, current) =>
          current is CoursesLoaded || current is CoursesLoading,
      builder: (context, state) {
        if (state is CoursesLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'New Courses',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 8.h),
              const CoursesListShimmer(),
              SizedBox(height: 24.h),
            ],
          );
        }

        if (state is! CoursesLoaded || state.courses.isEmpty) {
          return const SizedBox.shrink();
        }

        final displayCourses = state.courses.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Courses',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (state.courses.length > 3)
                    TextButton(
                      onPressed: () =>
                          _navigateToCourseList(CourseListType.available),
                      child: const Text('Show More'),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 330.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: displayCourses.length,
                itemBuilder: (context, index) {
                  final course = displayCourses[index];
                  return Container(
                    width: 300.w,
                    margin: EdgeInsets.only(right: 16.w),
                    child: CourseCard(
                      course: course,
                      onTap: () => _navigateToCourseDetail(course.id),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 36.h),
          ],
        );
      },
    );
  }

  // ── Enrolled courses ──────────────────────────────────────────────────────

  Widget _buildEnrolledCoursesSection() {
    return BlocBuilder<CoursesBloc, CoursesState>(
      buildWhen: (_, current) =>
          current is EnrolledCoursesLoaded || current is CoursesLoading,
      builder: (context, state) {
        if (state is CoursesLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Enrolled Courses',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 8.h),
              const CoursesListShimmer(),
              SizedBox(height: 24.h),
            ],
          );
        }

        if (state is! EnrolledCoursesLoaded || state.courses.isEmpty) {
          return const SizedBox.shrink();
        }

        final displayCourses = state.courses.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enrolled Courses',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (state.courses.length > 3)
                    TextButton(
                      onPressed: () =>
                          _navigateToCourseList(CourseListType.enrolled),
                      child: const Text('Show More'),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 290.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: displayCourses.length,
                itemBuilder: (context, index) {
                  final course = displayCourses[index];
                  return Container(
                    width: 300.w,
                    margin: EdgeInsets.only(right: 16.w),
                    child: CourseCard(
                      course: course,
                      onTap: () => _navigateToCourseDetail(course.id),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
          ],
        );
      },
    );
  }

  // ── Continue-watching card ────────────────────────────────────────────────

  Widget _buildLastViewedCard(BuildContext context, CourseModel course) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _navigateToCourseDetail(course.id),
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
                    errorBuilder: (_, __, ___) => Container(
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
                        '${course.progress.toStringAsFixed(0)}% Complete',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        '${((course.progress) / 100 * course.lessonsCount).ceil()} / ${course.lessonsCount} Lessons',
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorManager.warning),
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

  // ── Navigation ────────────────────────────────────────────────────────────

  /// Navigates to course detail and refreshes only if the user enrolled.
  void _navigateToCourseDetail(String courseId) async {
    final enrolled = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CoursesBloc>(),
          child: CourseDetailScreen(courseId: courseId),
        ),
      ),
    );

    if (enrolled == true) {
      _refreshData();
    }
  }

  void _navigateToCourseList(CourseListType type) {
    Navigator.pushNamed(
      context,
      AppRoutes.courseList,
      arguments: {
        'listType': type,
        'coursesBloc': context.read<CoursesBloc>(),
      },
    );
  }
}