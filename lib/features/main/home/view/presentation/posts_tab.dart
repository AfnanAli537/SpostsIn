import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        // Loading State
        if (state is PostsLoading) {
          return SliverList(
            delegate: SliverChildListDelegate([
              _buildHeader(),
              const PostShimmer(),
              const PostShimmer(),
              const PostShimmer(),
              const PostShimmer(),
              const PostShimmer(),
            ]),
          );
        }

        // Error State
        if (state is PostsError) {
          return SliverList(
            delegate: SliverChildListDelegate([
              _buildHeader(),
              _buildErrorState(context, state.message, theme),
            ]),
          );
        }

        // Handle both PostsLoaded and PostsLoadingMore states
        if (state is PostsLoaded || state is PostsLoadingMore) {
          final posts = state is PostsLoaded 
              ? state.posts 
              : (state as PostsLoadingMore).currentPosts;
          final hasNextPage = state is PostsLoaded ? state.hasNextPage : true;
          final isLoadingMore = state is PostsLoadingMore;
          
          // Empty State
          if (posts.isEmpty) {
            return SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader(),
                _buildEmptyState(),
              ]),
            );
          }
          
          // Posts List with Pagination
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // First item is the header
                if (index == 0) {
                  return _buildHeader();
                }
                
                // Adjust index for posts array
                final postIndex = index - 1;
                
                // Trigger pagination at the last item
                if (postIndex == posts.length - 1 && hasNextPage && !isLoadingMore) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<PostsBloc>().add(LoadMorePosts());
                  });
                }
                
                final post = posts[postIndex];
                
                return Column(
                  children: [
                    PostWidget(
                      key: ValueKey(post.id),
                      post: post,
                    ),
                    // Show loading indicator at the last item if loading more
                    if (postIndex == posts.length - 1 && isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    // Add spacing at the very end
                    if (postIndex == posts.length - 1)
                      const SizedBox(height: 100),
                  ],
                );
              },
              childCount: posts.length + 1,
            ),
          );
        }
        
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 20.w,
      ),
      child: Text(
        "Posts",
        style: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, ColorScheme theme) {
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
              'Oops! Something went wrong',
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
              onPressed: () {
                context.read<PostsBloc>().add(FetchPosts());
              },
              icon: const Icon(Icons.refresh),
              label: Text(
                'Retry',
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

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.post_add,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No posts yet',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Be the first to create a post!',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}