import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_detail_screen.dart';
import 'package:sports_in/features/main/courses/view/widgets/course_card.dart';
import 'package:sports_in/features/main/courses/view/widgets/courses_search_bar.dart';
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

  // ✅ Handle search with debounce (500ms delay)
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
        _fetchCoursesWithSearch(_currentSearchTerm);
      }
    });
  }

  void _fetchInitialCourses() {
    _fetchCoursesWithSearch('');
  }

  // ✅ Unified fetch method with server-side search
  void _fetchCoursesWithSearch(String searchTerm) {
    switch (widget.listType) {
      case CourseListType.available:
        context.read<CoursesBloc>().add(
              FetchAvailableCourses(
                page: 1,
                size: 10,
                isRefresh: true,
                searchTerm: searchTerm.isEmpty ? null : searchTerm,
              ),
            );
        break;
      case CourseListType.enrolled:
        context.read<CoursesBloc>().add(
              FetchEnrolledCourses(
                page: 1,
                size: 10,
                isRefresh: true,
                searchTerm: searchTerm.isEmpty ? null : searchTerm,
              ),
            );
        break;
      case CourseListType.created:
        context.read<CoursesBloc>().add(
              FetchCreatedCourses(
                page: 1,
                size: 10,
                isRefresh: true,
                searchTerm: searchTerm.isEmpty ? null : searchTerm,
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

    switch (widget.listType) {
      case CourseListType.available:
        context.read<CoursesBloc>().add(
              FetchAvailableCourses(
                page: _currentPage + 1,
                size: 10,
                searchTerm: _currentSearchTerm.isEmpty ? null : _currentSearchTerm,
              ),
            );
        break;
      case CourseListType.enrolled:
        context.read<CoursesBloc>().add(
              FetchEnrolledCourses(
                page: _currentPage + 1,
                size: 10,
                searchTerm: _currentSearchTerm.isEmpty ? null : _currentSearchTerm,
              ),
            );
        break;
      case CourseListType.created:
        context.read<CoursesBloc>().add(
              FetchCreatedCourses(
                page: _currentPage + 1,
                size: 10,
                searchTerm: _currentSearchTerm.isEmpty ? null : _currentSearchTerm,
              ),
            );
        break;
    }
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
    final string = S.of(context);

    return GestureDetector(
      // ✅ Unfocus keyboard when tapping outside
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle(string)),
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
                      child: Text(string.retry),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // ✅ Search bar at top
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: CoursesSearchBar(
                    controller: _searchController,
                    hintText: 'Search courses...',
                    onChanged: (value) {
                      // Handled by listener
                    },
                    onClear: () {
                      _searchController.clear();
                      // This will trigger the listener
                    },
                  ),
                ),

                // ✅ Courses list or empty state
                Expanded(
                  child: _courses.isEmpty
                      ? _buildEmptyState(theme)
                      : RefreshIndicator(
                          onRefresh: () async {
                            _fetchCoursesWithSearch(_currentSearchTerm);
                            await Future.delayed(const Duration(milliseconds: 500));
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(bottom: 16.h),
                            itemCount: _courses.length + (_isLoadingMore ? 1 : 0),
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

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _currentSearchTerm.isEmpty ? Icons.school_outlined : Icons.search_off,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            _currentSearchTerm.isEmpty
                ? 'No courses found'
                : 'No results for "${_currentSearchTerm}"',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (_currentSearchTerm.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              'Try adjusting your search',
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