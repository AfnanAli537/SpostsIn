import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/app/routes/app_routes.dart';
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
  State<CoursesTab> createState() => CoursesTabState();
}

class CoursesTabState extends State<CoursesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static const _source = 'coursesTab';

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<CourseModel> _availableCourses = [];
  List<CourseModel> _enrolledCourses = [];
  bool _isLoadingAvailable = false;
  bool _isLoadingEnrolled = false;
  String? _availableError;
  String? _enrolledError;

  // ----- Filter state -----
  int? _selectedSportTypeId;
  String? _selectedSportName;

  final Map<String, int> _sportTypes = {
    'football': 1,
    'basketball': 2,
    'volleyball': 3,
    'handball': 4,
    'taekwondo': 5,
  };

  String _getLocalizedSportName(String key, S strings) {
    final Map<String, String> names = {
      'football': strings.football,
      'basketball': strings.basketball,
      'volleyball': strings.volleyball,
      'handball': strings.handball,
      'taekwondo': strings.taekwondo,
    };
    return names[key] ?? key;
  }

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

  void reload() => _refreshData();

  void _refreshData() {
    final searchTerm = _searchController.text.trim().isEmpty
        ? null
        : _searchController.text.trim();

    if (mounted) {
      setState(() {
        _isLoadingAvailable = true;
        _isLoadingEnrolled = true;
        _availableError = null;
        _enrolledError = null;
      });
    }
    context.read<CoursesBloc>()
      ..add(
        FetchEnrolledCourses(
          page: 1,
          size: 10,
          searchTerm: searchTerm,
          sportTypeId: _selectedSportTypeId,
          isRefresh: true,
        ),
      )
      ..add(
        FetchAvailableCourses(
          page: 1,
          size: 10,
          searchTerm: searchTerm,
          sportTypeId: _selectedSportTypeId,
          isRefresh: true,
          source: _source,
        ),
      );
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) _refreshData();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedSportTypeId = null;
      _selectedSportName = null;
    });
    _refreshData();
  }

  void _showFilterDialog() {
    final strings = S.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            strings.selectSport,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _sportTypes.entries.map((entry) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  title: Card(
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      child: Text(
                        _getLocalizedSportName(entry.key, strings),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedSportTypeId = entry.value;
                      _selectedSportName = entry.key;
                    });
                    Navigator.pop(dialogContext);
                    _refreshData();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(strings.cancel),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final string = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return BlocListener<CoursesBloc, CoursesState>(
      listener: (context, state) {
        if (state is CoursesLoaded && state.source == _source) {
          setState(() {
            _availableCourses = state.courses;
            _isLoadingAvailable = false;
            _availableError = null;
          });
        } else if (state is EnrolledCoursesLoaded) {
          setState(() {
            _enrolledCourses = state.courses;
            _isLoadingEnrolled = false;
            _enrolledError = null;
          });
        } else if (state is EnrollmentSuccess) {
          _refreshData();
        } else if (state is CoursesError) {
          setState(() {
            _isLoadingAvailable = false;
            _isLoadingEnrolled = false;
            _availableError = state.message;
            _enrolledError = state.message;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----- Search bar -----
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                controller: _searchController,
                onChanged: (_) {},
                decoration: InputDecoration(
                  hintText: string.search,
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.sp,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged();
                          },
                        )
                      : Icon(Icons.tune, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
          ),

          // ----- Filter chips -----
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    label: _selectedSportName != null
                        ? _getLocalizedSportName(_selectedSportName!, string)
                        : string.sport,
                    isSelected: _selectedSportTypeId != null,
                    onTap: _showFilterDialog,
                  ),
                  if (_selectedSportTypeId != null ||
                      _searchController.text.isNotEmpty)
                    SizedBox(width: 8.w),
                  if (_selectedSportTypeId != null ||
                      _searchController.text.isNotEmpty)
                    _buildFilterChip(
                      label: string.clear,
                      icon: Icons.clear_all,
                      isSelected: false,
                      onTap: _clearFilters,
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // ----- Content -----
          if (_searchController.text.trim().isNotEmpty)
            _buildSearchResults(string: string, theme: theme)
          else ...[
            _buildContinueWatchingSection(string: string, theme: theme),
            _buildNewCoursesSection(string: string, theme: theme),
            _buildEnrolledCoursesSection(string: string, theme: theme),
          ],
          SizedBox(height: 120.h),
        ],
      ),
    );
  }

  // ----- Filter chip -----
  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.tune,
              size: 18.sp,
              color: isSelected
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.onSurface,
            ),
            SizedBox(width: 6.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 120.w),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----- Error widget (shared style) -----
  Widget _buildErrorWidget({
    required String message,
    required S string,
    required ColorScheme theme,
    required VoidCallback onRetry,
  }) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red[300]),
            SizedBox(height: 16.h),
            Text(
              string.oopsSomethingWentWrong,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(string.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: theme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----- Search results -----
  Widget _buildSearchResults({required S string, required ColorScheme theme}) {
    if (_availableError != null) {
      return _buildErrorWidget(
        message: _availableError!,
        string: string,
        theme: theme,
        onRetry: _refreshData,
      );
    }
    final total = _availableCourses.length + _enrolledCourses.length;
    if (_isLoadingAvailable && total == 0) return const CoursesListShimmer();
    if (total == 0) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 64.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                string.noCoursesFoundFor(_searchController.text),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_availableCourses.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Text(
              '${string.available} (${_availableCourses.length})',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ..._availableCourses.map(
            (c) => CourseCard(
              course: c,
              onTap: () => _navigateToCourseDetail(c.id),
              string: string,
            ),
          ),
        ],
        if (_enrolledCourses.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Text(
              '${string.enrolled} (${_enrolledCourses.length})',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ..._enrolledCourses.map(
            (c) => CourseCard(
              course: c,
              onTap: () => _navigateToCourseDetail(c.id),
              string: string,
            ),
          ),
        ],
      ],
    );
  }

  // ----- Continue watching -----
  Widget _buildContinueWatchingSection({
    required S string,
    required ColorScheme theme,
  }) {
    if (_isLoadingEnrolled || _enrolledCourses.isEmpty) {
      return const SizedBox.shrink();
    }
    final inProgress =
        _enrolledCourses
            .where((c) => c.progress > 0 && c.progress < 100)
            .toList()
          ..sort((a, b) => b.progress.compareTo(a.progress));
    if (inProgress.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
          child: Text(
            string.continueWatching,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _buildLastViewedCard(context, inProgress.first, string),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  // ----- New courses -----
  Widget _buildNewCoursesSection({
    required S string,
    required ColorScheme theme,
  }) {
    // Error state
    if (_availableError != null && !_isLoadingAvailable) {
      return _buildErrorWidget(
        message: _availableError!,
        string: string,
        theme: theme,
        onRetry: _refreshData,
      );
    }
    if (_isLoadingAvailable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              string.newCourses,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 8.h),
          const CoursesListShimmer(),
          SizedBox(height: 24.h),
        ],
      );
    }
    if (_availableCourses.isEmpty) return const SizedBox.shrink();

    final display = _availableCourses.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                string.newCourses,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (_availableCourses.length > 3)
                TextButton(
                  onPressed: () =>
                      _navigateToCourseList(CourseListType.available),
                  child: Text(string.showMore),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 330.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: display.length,
            itemBuilder: (context, i) => Container(
              width: 300.w,
              margin: EdgeInsets.only(right: 16.w),
              child: CourseCard(
                course: display[i],
                onTap: () => _navigateToCourseDetail(display[i].id),
                string: string,
              ),
            ),
          ),
        ),
        SizedBox(height: 36.h),
      ],
    );
  }

  // ----- Enrolled courses -----
  Widget _buildEnrolledCoursesSection({
    required S string,
    required ColorScheme theme,
  }) {
    // Error state
    if (_enrolledError != null && !_isLoadingEnrolled) {
      return _buildErrorWidget(
        message: _enrolledError!,
        string: string,
        theme: theme,
        onRetry: _refreshData,
      );
    }
    if (_isLoadingEnrolled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              string.enrolledCourses,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 8.h),
          const CoursesListShimmer(),
          SizedBox(height: 24.h),
        ],
      );
    }
    if (_enrolledCourses.isEmpty) return const SizedBox.shrink();

    final display = _enrolledCourses.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                string.enrolledCourses,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (_enrolledCourses.length > 3)
                TextButton(
                  onPressed: () =>
                      _navigateToCourseList(CourseListType.enrolled),
                  child: Text(string.showMore),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 300.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: display.length,
            itemBuilder: (context, i) => Container(
              width: 300.w,
              margin: EdgeInsets.only(right: 16.w),
              child: CourseCard(
                course: display[i],
                onTap: () => _navigateToCourseDetail(display[i].id),
                string: string,
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  // ----- Continue watching card -----
  Widget _buildLastViewedCard(
    BuildContext context,
    CourseModel course,
    S string,
  ) {
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
                        string.percentComplete(
                          course.progress.toStringAsFixed(0),
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        string.lessonsProgress(
                          '${((course.progress) / 100 * course.lessonsCount).ceil()}',
                          '${course.lessonsCount}',
                        ),
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

  // void _navigateToCourseDetail(String courseId) async {
  //   final enrolled = await Navigator.push<bool>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => BlocProvider.value(
  //         value: context.read<CoursesBloc>(),
  //         child: CourseDetailScreen(courseId: courseId),
  //       ),
  //     ),
  //   );
  //   if (enrolled == true) _refreshData();
  // }
  /// Place this in CoursesTab to replace the existing _navigateToCourseDetail.
  /// The key fix: always call _refreshData() when we return from course detail,
  /// regardless of whether enrollment happened — this covers the case where
  /// BlocListener missed events while the detail route was on top.
  void _navigateToCourseDetail(String courseId) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CoursesBloc>(),
          child: CourseDetailScreen(courseId: courseId),
        ),
      ),
    );
    // Always refresh when returning — enrollment may have happened,
    // or the bloc state may be stale from events missed while routed away.
    if (mounted) _refreshData();
  }

  void _navigateToCourseList(CourseListType type) {
    Navigator.pushNamed(
      context,
      AppRoutes.courseList,
      arguments: {'listType': type, 'coursesBloc': context.read<CoursesBloc>()},
    );
  }
}
