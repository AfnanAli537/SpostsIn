import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/features/main/home/data/interface/home_tap_enums.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/opportunity_list.dart';
import 'package:sports_in/features/main/opportunity/view/widgets/opp_card.dart';

class BuildContent extends StatelessWidget {
  final HomeTab currentTab;
  final void Function(HomeTab) onTabChange;

  const BuildContent({
    super.key,
    required this.currentTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
   final theme=Theme.of(context).colorScheme;
    switch (currentTab) {
     case HomeTab.forYou:
        return BlocBuilder<PostsBloc, PostsState>(
          builder: (context, state) {
            return SliverList(
              delegate: SliverChildListDelegate([
                // Latest Posts Header - Always visible
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 20.w,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Latest posts",
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          onTabChange(HomeTab.posts);
                        },
                        child: Text(
                          "Show all",
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
                
                // Content based on state
                if (state is PostsLoading) ...[
                  const PostShimmer(),
                  const PostShimmer(),
                ] else if (state is PostsError) ...[
                  Padding(
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
                            state.message,
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
                              foregroundColor:theme.surface,
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
                  ),
                ] else if (state is PostsLoaded) ...[
                  if (state.posts.isEmpty)
                    Padding(
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
                          ],
                        ),
                      ),
                    )
                  else
                    ...state.posts.take(1).map(
                      (post) => PostWidget(
                        key: ValueKey(post.id),
                         post: post,
                      ),
                    ),
                ],
                
                // Add more sections here in the future
                // Example:
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 20.w,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Opportunities",
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          onTabChange(HomeTab.opportunities);
                        },
                        child: Text(
                          "Show all",
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
                buildOpportunityPreviewCard(),
                SizedBox(height: 100.h),
                // SizedBox(
                //   height: 400.h, 
                //   child: const OpportunitiesScreen(),
                // ),
                // ... achievement widgets ...
                // const OpportunitiesSection(),
              ]),
            );
          },
        );
   case HomeTab.posts:
        return BlocBuilder<PostsBloc, PostsState>(
          builder: (context, state) {
            if (state is PostsLoading) {
              return SliverList(
                delegate: SliverChildListDelegate([
                  // Posts Header
                  Padding(
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
                  ),
                  const PostShimmer(),
                  const PostShimmer(),
                  const PostShimmer(),
                  const PostShimmer(),
                  const PostShimmer(),
                ]),
              );
            }

            if (state is PostsError) {
              return SliverList(
                delegate: SliverChildListDelegate([
                  // Posts Header
                  Padding(
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
                  ),
                  Padding(
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
                            state.message,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Retry loading posts
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
                              foregroundColor:theme.surface,
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
                  ),
                ]),
              );
            }

            if (state is PostsLoaded) {
              final posts = state.posts;
              if (posts.isEmpty) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    // Posts Header
                    Padding(
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
                    ),
                    Padding(
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
                    ),
                  ]),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  // First item is the header
                  if (index == 0) {
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
                  
                  // Adjust index for posts array
                  final postIndex = index - 1;
                  final postId = posts[postIndex].id;
                  
                  return BlocBuilder<PostsBloc, PostsState>(
                    buildWhen: (previous, current) {
                      if (previous is PostsLoaded && current is PostsLoaded) {
                        final prevPost = previous.posts.firstWhere(
                          (p) => p.id == postId,
                        );
                        final currPost = current.posts.firstWhere(
                          (p) => p.id == postId,
                        );
                        return prevPost.isLikedByCurrentUser !=
                                currPost.isLikedByCurrentUser ||
                            prevPost.likesCount != currPost.likesCount;
                      }
                      return true;
                    },
                    builder: (context, state) {
                      if (state is! PostsLoaded) return const SizedBox();
                      final post = state.posts.firstWhere(
                        (p) => p.id == postId,
                      );

                      return PostWidget(
                         key: ValueKey(post.id),
                        post: post,
                      );
                    },
                  );
                }, childCount: posts.length + 1), 
              );
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          },
        );
    
      case HomeTab.courses:
        return const SliverToBoxAdapter(
          child: Center(child: Text("Courses tab content")),
        );

      case HomeTab.opportunities:
      return const OpportunitiesContent();
     
    }
  }
}