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
  State<PostsTab> createState() => PostsTabState();
}

class PostsTabState extends State<PostsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void reload() {
    context.read<PostsBloc>().add(const FetchPosts(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is PostsLoading || state is PostsInitial) {
          return Column(
            children: List.generate(5, (_) => const PostShimmer()),
          );
        }

        if (state is PostsError) {
          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red[300]),
                  SizedBox(height: 16.h),
                  Text(strings.oopsSomethingWentWrong,
                      style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800])),
                  SizedBox(height: 8.h),
                  Text(state.message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp, color: Colors.grey[600])),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<PostsBloc>().add(const FetchPosts()),
                    icon: const Icon(Icons.refresh),
                    label: Text(strings.retry),
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

        if (state is PostsLoaded || state is PostsLoadingMore) {
          final posts = state is PostsLoaded
              ? state.posts
              : (state as PostsLoadingMore).currentPosts;
          final hasNextPage =
              state is PostsLoaded ? state.hasNextPage : true;
          final isLoadingMore = state is PostsLoadingMore;

          if (posts.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(40.w),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.post_add, size: 64.sp, color: Colors.grey[400]),
                    SizedBox(height: 16.h),
                    Text(strings.noPostsYet,
                        style: GoogleFonts.poppins(
                            fontSize: 18.sp, color: Colors.grey[600])),
                    SizedBox(height: 8.h),
                    Text(strings.beTheFirstToCreatePost,
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp, color: Colors.grey[500])),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              ...posts.asMap().entries.map((entry) {
                final index = entry.key;
                final post = entry.value;

                // Trigger load-more when last post becomes visible
                if (index == posts.length - 1 && hasNextPage && !isLoadingMore) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<PostsBloc>().add(LoadMorePosts());
                  });
                }

                return PostWidget(key: ValueKey(post.id), post: post);
              }),
              if (isLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              SizedBox(height: 120.h),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}