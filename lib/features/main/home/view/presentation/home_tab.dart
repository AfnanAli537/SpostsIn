import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_detail_screen.dart';
import 'package:sports_in/features/main/courses/view/widgets/course_card.dart';
import 'package:sports_in/features/main/courses/view/widgets/shimmer_widget.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/main/opportunity/view/widgets/opp_card.dart';
import 'package:sports_in/generated/l10n.dart';

class ForYouTab extends StatefulWidget {
  final void Function(HomeTab) onTabChange;

  const ForYouTab({
    super.key,
    required this.onTabChange,
  });

  @override
  State<ForYouTab> createState() => _ForYouTabState();
}

class _ForYouTabState extends State<ForYouTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<CourseModel> _latestCourses = [];
  bool _isLoadingCourses = true;

  @override
  void initState() {
    super.initState();
    _loadLatestCourses();
  }

  void _loadLatestCourses() {
    setState(() => _isLoadingCourses = true);

    context.read<CoursesBloc>().add(
          const FetchAvailableCourses(
            page: 1,
            size: 5, // Get 5 latest courses
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return BlocListener<CoursesBloc, CoursesState>(
      listener: (context, state) {
        if (state is CoursesLoaded) {
          setState(() {
            _latestCourses = state.courses;
            _isLoadingCourses = false;
          });
        }
      },
      child: SliverList(
        delegate: SliverChildListDelegate([
          // ✅ Latest Posts Section
          _buildLatestPostsSection(context, strings, theme),

          SizedBox(height: 24.h),

          // ✅ Opportunities Section
          _buildOpportunitiesSection(context, strings, theme),

          SizedBox(height: 24.h),

          // ✅ Latest Courses Section
          _buildLatestCoursesSection(context, strings, theme),

          SizedBox(height: 100.h),
        ]),
      ),
    );
  }

  // ==================== LATEST POSTS SECTION ====================
  Widget _buildLatestPostsSection(
    BuildContext context,
    S strings,
    ColorScheme theme,
  ) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 20.w,
              ),
              child: Row(
                children: [
                  Text(
                    strings.latestPosts,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // ✅ Switch to Posts tab
                      widget.onTabChange(HomeTab.posts);
                    },
                    child: Text(
                      strings.showAll,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (state is PostsLoading) ...[
              const PostShimmer(),
            ] else if (state is PostsError) ...[
              _buildErrorState(
                context,
                strings,
                theme,
                state.message,
                () => context.read<PostsBloc>().add(const FetchPosts()),
              ),
            ] else if (state is PostsLoaded) ...[
              if (state.posts.isEmpty)
                _buildEmptyState(
                  strings.noPostsYet,
                  Icons.post_add,
                )
              else
                ...state.posts.take(1).map(
                      (post) => PostWidget(
                        key: ValueKey(post.id),
                        post: post,
                      ),
                    ),
            ],
          ],
        );
      },
    );
  }

  // ==================== OPPORTUNITIES SECTION ====================
  Widget _buildOpportunitiesSection(
    BuildContext context,
    S strings,
    ColorScheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 20.w,
          ),
          child: Row(
            children: [
              Text(
                strings.opportunities,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // ✅ Switch to Opportunities tab
                  widget.onTabChange(HomeTab.opportunities);
                },
                child: Text(
                  strings.showAll,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        const LatestOpportunityCard(),
      ],
    );
  }

  // ==================== LATEST COURSES SECTION ====================
  Widget _buildLatestCoursesSection(
    BuildContext context,
    S strings,
    ColorScheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 20.w,
          ),
          child: Row(
            children: [
              Text(
                'Latest Courses',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (!_isLoadingCourses && _latestCourses.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    // ✅ Switch to Courses tab
                    widget.onTabChange(HomeTab.courses);
                  },
                  child: Text(
                    strings.showAll,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
            ],
          ),
        ),

        if (_isLoadingCourses)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const CoursesListShimmer(),
          )
        else if (_latestCourses.isEmpty)
          _buildEmptyState(
            'No courses available yet',
            Icons.school_outlined,
          )
        else
          SizedBox(
            height: 330.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _latestCourses.length,
              itemBuilder: (context, index) {
                final course = _latestCourses[index];
                return Container(
                  width: 300.w,
                  margin: EdgeInsets.only(right: 16.w),
                  child: CourseCard(
                    course: course,
                    onTap: () => _navigateToCourseDetail(context, course.id),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  // ==================== HELPER WIDGETS ====================

  Widget _buildErrorState(
    BuildContext context,
    S strings,
    ColorScheme theme,
    String message,
    VoidCallback onRetry,
  ) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Colors.red[300],
            ),
            SizedBox(height: 16.h),
            Text(
              strings.oopsSomethingWentWrong,
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
              label: Text(
                strings.retry,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: theme.surface,
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCourseDetail(BuildContext context, String courseId) async {
    final coursesBloc = context.read<CoursesBloc>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: coursesBloc,
          child: CourseDetailScreen(courseId: courseId),
        ),
      ),
    );

    // Reload on return
    _loadLatestCourses();
  }
}