import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class ForYouTab extends StatefulWidget {
  final void Function(HomeTab) onTabChange;
  const ForYouTab({super.key, required this.onTabChange});

  @override
  ForYouTabState createState() => ForYouTabState();
}

class ForYouTabState extends State<ForYouTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void reload() {
    context.read<PostsBloc>().add(const FetchPosts(page: 1));
    context.read<OpportunityBloc>().add(
          const FetchOpportunities(isRefresh: true),
        );
    context.read<CoursesBloc>().add(
          const FetchAvailableCourses(page: 1, size: 1, source: 'forYouTab'),
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(child: _buildLatestPostsSection(context, strings, theme)),
        SizedBox(height: 24.h),
        RepaintBoundary(child: _buildLatestCoursesSection(context, strings, theme)),
        SizedBox(height: 24.h),
        RepaintBoundary(child: _buildOpportunitiesSection(context, strings, theme)),
        SizedBox(height: 120.h),
      ],
    );
  }

  // ── Shared error widget ───────────────────────────────────────────────────

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
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red[300]),
            SizedBox(height: 16.h),
            Text(
              strings.oopsSomethingWentWrong,
              style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800]),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(strings.retry,
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp, fontWeight: FontWeight.w600)),
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

  // ── Latest Posts ──────────────────────────────────────────────────────────

  Widget _buildLatestPostsSection(
      BuildContext context, S strings, ColorScheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: strings.latestPosts,
          onShowAll: () => widget.onTabChange(HomeTab.posts),
        ),
        BlocBuilder<PostsBloc, PostsState>(
          buildWhen: (previous, current) {
            if (current is PostsLoading || current is PostsError) return true;
            if (current is PostsLoaded) {
              if (previous is PostsLoaded) {
                if (previous.posts.isEmpty && current.posts.isEmpty) return false;
                if (previous.posts.isEmpty || current.posts.isEmpty) return true;
                return previous.posts.first.id != current.posts.first.id;
              }
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is PostsLoading) return const PostShimmer();

            if (state is PostsError) {
              return _buildErrorState(
                context, strings, theme, state.message,
                () => context.read<PostsBloc>().add(const FetchPosts()),
              );
            }

            if (state is PostsLoaded) {
              if (state.posts.isEmpty) {
                return _buildEmptyState(strings.noPostsYet, Icons.post_add);
              }
              return PostWidget(
                key: ValueKey(state.posts.first.id),
                post: state.posts.first,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // ── Latest Courses ────────────────────────────────────────────────────────

  Widget _buildLatestCoursesSection(
      BuildContext context, S string, ColorScheme theme) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      buildWhen: (_, current) =>
          current is CoursesLoading ||
          current is CoursesLoaded ||
          current is CoursesError,
      builder: (context, state) {
        final isLoading = state is CoursesLoading;
        final courses =
            state is CoursesLoaded ? state.courses : <CourseModel>[];
        final hasCourses = courses.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              title: string.availableCourses,
              onShowAll: () => widget.onTabChange(HomeTab.courses),
              showAllEnabled: !isLoading && hasCourses,
            ),

            // Error
            if (state is CoursesError)
              _buildErrorState(
                context, string, theme, state.message,
                () => context.read<CoursesBloc>().add(
                      const FetchAvailableCourses(
                        page: 1,
                        size: 1,
                        source: 'forYouTab',
                      ),
                    ),
              )

            // Loading
            else if (isLoading)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const CoursesListShimmer(),
              )

            // Empty
            else if (!hasCourses)
              _buildEmptyState(
                  string.noAvailableCourses, Icons.school_outlined)

            // Content
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CourseCard(
                  course: courses.first,
                  onTap: () =>
                      _navigateToCourseDetail(context, courses.first.id),
                  string: string,
                ),
              ),
          ],
        );
      },
    );
  }

  // ── Opportunities ─────────────────────────────────────────────────────────

  Widget _buildOpportunitiesSection(
      BuildContext context, S strings, ColorScheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: strings.opportunities,
          onShowAll: () => widget.onTabChange(HomeTab.opportunities),
        ),
        BlocBuilder<OpportunityBloc, OpportunityState>(
          builder: (context, state) {
            if (state is OpportunityError) {
              return _buildErrorState(
                context, strings, theme, state.message,
                () => context.read<OpportunityBloc>().add(
                      const FetchOpportunities(isRefresh: true),
                    ),
              );
            }
            return const LatestOpportunityCard();
          },
        ),
      ],
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────

  Widget _sectionHeader({
    required String title,
    required VoidCallback onShowAll,
    bool showAllEnabled = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Row(
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 18.sp, fontWeight: FontWeight.bold)),
          const Spacer(),
          if (showAllEnabled)
            GestureDetector(
              onTap: onShowAll,
              child: Text(S.of(context).showAll,
                  style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(message,
                style: GoogleFonts.poppins(
                    fontSize: 16.sp, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  void _navigateToCourseDetail(BuildContext context, String courseId) async {
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
      context.read<CoursesBloc>().add(
            const FetchAvailableCourses(
              page: 1,
              size: 1,
              source: 'forYouTab',
            ),
          );
    }
  }
}