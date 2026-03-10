import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class PostsTab extends StatefulWidget {
  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _onRefresh() async {
    context.read<PostsBloc>().add(const FetchPosts(page: 1));
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<PostsBloc, PostsState>(
          builder: (context, state) {
            // ── Loading / Initial ──────────────────────────────────────────
            if (state is PostsLoading || state is PostsInitial) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(strings),
                      const PostShimmer(),
                      const PostShimmer(),
                      const PostShimmer(),
                      const PostShimmer(),
                      const PostShimmer(),
                    ]),
                  ),
                ],
              );
            }

            // ── Error ──────────────────────────────────────────────────────
            if (state is PostsError) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(strings),
                      _buildErrorState(context, state.message, theme, strings),
                    ]),
                  ),
                ],
              );
            }

            // ── Loaded / LoadingMore ───────────────────────────────────────
            if (state is PostsLoaded || state is PostsLoadingMore) {
              final posts = state is PostsLoaded
                  ? state.posts
                  : (state as PostsLoadingMore).currentPosts;
              final hasNextPage =
                  state is PostsLoaded ? state.hasNextPage : true;
              final isLoadingMore = state is PostsLoadingMore;

              if (posts.isEmpty) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeader(strings),
                        _buildEmptyState(strings),
                      ]),
                    ),
                  ],
                );
              }

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == 0) return _buildHeader(strings);

                        final postIndex = index - 1;

                        // Trigger pagination near the end
                        if (postIndex == posts.length - 1 &&
                            hasNextPage &&
                            !isLoadingMore) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.read<PostsBloc>().add(LoadMorePosts());
                          });
                        }

                        return Column(
                          children: [
                            PostWidget(
                              key: ValueKey(posts[postIndex].id),
                              post: posts[postIndex],
                            ),
                            if (postIndex == posts.length - 1 && isLoadingMore)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            if (postIndex == posts.length - 1)
                              const SizedBox(height: 100),
                          ],
                        );
                      },
                      childCount: posts.length + 1,
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _buildHeader(S strings) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Text(
        strings.posts,
        style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    ColorScheme theme,
    S strings,
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
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<PostsBloc>().add(const FetchPosts()),
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
                padding:
                    EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
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

  Widget _buildEmptyState(S strings) {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              strings.noPostsYet,
              style: GoogleFonts.poppins(fontSize: 18.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              strings.beTheFirstToCreatePost,
              style:
                  GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}