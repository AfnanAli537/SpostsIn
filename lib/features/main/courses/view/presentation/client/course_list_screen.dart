import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_detail_screen.dart';
import 'package:sports_in/features/main/courses/view/widgets/course_card.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

enum CourseListType { available, enrolled, created }

class CourseListScreen extends StatefulWidget {
  final CourseListType listType;

  const CourseListScreen({
    super.key,
    required this.listType,
  });

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<CourseModel> _courses = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String _currentSearchTerm = '';
  Timer? _debounce;

  // ----- Filter state (same as opportunities) -----
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
  // ------------------------------------------------

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    _fetchInitialCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_currentSearchTerm != _searchController.text) {
        setState(() {
          _currentSearchTerm = _searchController.text;
          _courses.clear();
          _currentPage = 1;
          _hasMore = true;
        });
        _fetchCoursesWithFilter();
      }
    });
  }

  void _fetchInitialCourses() {
    _fetchCoursesWithFilter();
  }

  void _fetchCoursesWithFilter() {
    final searchTerm = _currentSearchTerm.isEmpty ? null : _currentSearchTerm;

    switch (widget.listType) {
      case CourseListType.available:
        context.read<CoursesBloc>().add(
              FetchAvailableCourses(
                page: 1,
                size: 10,
                isRefresh: true,
                searchTerm: searchTerm,
                sportTypeId: _selectedSportTypeId, // TODO: add to event
              ),
            );
        break;
      case CourseListType.enrolled:
        context.read<CoursesBloc>().add(
              FetchEnrolledCourses(
                page: 1,
                size: 10,
                isRefresh: true,
                searchTerm: searchTerm,
                sportTypeId: _selectedSportTypeId, // TODO: add to event
              ),
            );
        break;
      case CourseListType.created:
        context.read<CoursesBloc>().add(
              FetchCreatedCourses(
                page: 1,
                size: 10,
                isRefresh: true,
                searchTerm: searchTerm,
                sportTypeId: _selectedSportTypeId, // TODO: add to event
              ),
            );
        break;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  void _loadMore() {
    setState(() {
      _isLoadingMore = true;
    });

    final searchTerm = _currentSearchTerm.isEmpty ? null : _currentSearchTerm;

    switch (widget.listType) {
      case CourseListType.available:
        context.read<CoursesBloc>().add(
              FetchAvailableCourses(
                page: _currentPage + 1,
                size: 10,
                searchTerm: searchTerm,
                sportTypeId: _selectedSportTypeId, // TODO: add to event
              ),
            );
        break;
      case CourseListType.enrolled:
        context.read<CoursesBloc>().add(
              FetchEnrolledCourses(
                page: _currentPage + 1,
                size: 10,
                searchTerm: searchTerm,
                sportTypeId: _selectedSportTypeId, // TODO: add to event
              ),
            );
        break;
      case CourseListType.created:
        context.read<CoursesBloc>().add(
              FetchCreatedCourses(
                page: _currentPage + 1,
                size: 10,
                searchTerm: searchTerm,
                sportTypeId: _selectedSportTypeId, // TODO: add to event
              ),
            );
        break;
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedSportTypeId = null;
      _selectedSportName = null;
      _currentSearchTerm = '';
      _searchController.clear();
      _courses.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    _fetchCoursesWithFilter();
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  title: Card(
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 10.h),
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
                      _courses.clear();
                      _currentPage = 1;
                      _hasMore = true;
                    });
                    Navigator.pop(dialogContext);
                    _fetchCoursesWithFilter();
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

  String _getTitle(S string) {
    switch (widget.listType) {
      case CourseListType.available:
        return 'Available Courses';
      case CourseListType.enrolled:
        return 'Enrolled Courses';
      case CourseListType.created:
        return 'My Courses';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle(strings)),
        ),
        body: BlocConsumer<CoursesBloc, CoursesState>(
          listener: (context, state) {
            if (state is CoursesLoaded ||
                state is EnrolledCoursesLoaded ||
                state is MyCoursesLoaded) {
              List<CourseModel> newCourses = [];
              bool hasMore = false;
              int page = 1;

              if (state is CoursesLoaded) {
                newCourses = state.courses;
                hasMore = state.hasMore;
                page = state.currentPage;
              } else if (state is EnrolledCoursesLoaded) {
                newCourses = state.courses;
                hasMore = state.hasMore;
                page = state.currentPage;
              } else if (state is MyCoursesLoaded) {
                newCourses = state.courses;
                hasMore = state.hasMore;
                page = state.currentPage;
              }

              setState(() {
                if (page == 1) {
                  _courses.clear();
                }
                _courses.addAll(newCourses.where(
                  (course) => !_courses.any((c) => c.id == course.id),
                ));
                _hasMore = hasMore;
                _currentPage = page;
                _isLoadingMore = false;
              });
            } else if (state is CoursesError) {
              setState(() {
                _isLoadingMore = false;
              });
            }
          },
          builder: (context, state) {
            if (state is CoursesLoading && _courses.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CoursesError && _courses.isEmpty) {
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
                      state.message,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: _fetchInitialCourses,
                      child: Text(strings.retry),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----- Search bar (same as opportunities) -----
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
                      onChanged: (_) {}, // handled by listener
                      decoration: InputDecoration(
                        hintText: strings.search,
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontSize: 16.sp),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey[600]),
                                onPressed: () {
                                  _searchController.clear();
                                  // Listener will trigger refresh
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

                // ----- Filter chips (same as opportunities) -----
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: _selectedSportName != null
                              ? _getLocalizedSportName(
                                  _selectedSportName!, strings)
                              : strings.sport,
                          isSelected: _selectedSportTypeId != null,
                          onTap: _showFilterDialog,
                        ),
                        if (_selectedSportTypeId != null ||
                            _searchController.text.isNotEmpty)
                          SizedBox(width: 8.w),
                        if (_selectedSportTypeId != null ||
                            _searchController.text.isNotEmpty)
                          _buildFilterChip(
                            label: strings.clear,
                            icon: Icons.clear_all,
                            isSelected: false,
                            onTap: _clearFilters,
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // ----- Course list -----
                Expanded(
                  child: _courses.isEmpty
                      ? _buildEmptyState(theme)
                      : RefreshIndicator(
                          onRefresh: () async {
                            _fetchCoursesWithFilter();
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(bottom: 16.h),
                            itemCount:
                                _courses.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= _courses.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final course = _courses[index];
                              return CourseCard(
                                course: course,
                                onTap: () => _navigateToCourseDetail(course.id),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ----- Filter chip widget (same as opportunities) -----
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

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _currentSearchTerm.isEmpty && _selectedSportTypeId == null
                ? Icons.school_outlined
                : Icons.search_off,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            _currentSearchTerm.isEmpty && _selectedSportTypeId == null
                ? 'No courses found'
                : 'No results for your criteria',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (_currentSearchTerm.isNotEmpty || _selectedSportTypeId != null) ...[
            SizedBox(height: 8.h),
            Text(
              'Try adjusting your search or filter',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _navigateToCourseDetail(String courseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CoursesBloc>(),
          child: CourseDetailScreen(courseId: courseId),
        ),
      ),
    );
  }
}