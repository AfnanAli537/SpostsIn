import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/features/main/advertisement/view/widgets/ad_widget.dart';
import 'package:sports_in/features/main/advertisement/view/widgets/ad_shimmer.dart';
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

/// One ad is injected after every 5 posts.
const int _adInterval = 5;

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
    context.read<AdsBloc>().add(const FetchAdsFeed());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, postsState) {
        // ── Loading ─────────────────────────────────────────────────────────
        if (postsState is PostsLoading || postsState is PostsInitial) {
          return Column(
            children: List.generate(5, (_) => const PostShimmer()),
          );
        }

        // ── Error ───────────────────────────────────────────────────────────
        if (postsState is PostsError) {
          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64.sp, color: Colors.red[300]),
                  SizedBox(height: 16.h),
                  Text(strings.oopsSomethingWentWrong,
                      style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800])),
                  SizedBox(height: 8.h),
                  Text(postsState.message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp, color: Colors.grey[600])),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<PostsBloc>()
                          .add(const FetchPosts());
                      context
                          .read<AdsBloc>()
                          .add(const FetchAdsFeed());
                    },
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

        // ── Loaded ──────────────────────────────────────────────────────────
        if (postsState is PostsLoaded || postsState is PostsLoadingMore) {
          final posts = postsState is PostsLoaded
              ? postsState.posts
              : (postsState as PostsLoadingMore).currentPosts;
          final hasNextPage =
              postsState is PostsLoaded ? postsState.hasNextPage : true;
          final isLoadingMore = postsState is PostsLoadingMore;

          if (posts.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(40.w),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.post_add,
                        size: 64.sp, color: Colors.grey[400]),
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

          // ── Merge posts + ads ──────────────────────────────────────────────
          return BlocBuilder<AdsBloc, AdsState>(
            builder: (context, adsState) {
              final ads = adsState is AdsLoaded
                  ? adsState.ads
                  : adsState is AdsLoadingMore
                      ? adsState.currentAds
                      : <dynamic>[];

              // Build the interleaved list
              final List<Widget> items = [];
              int adIndex = 0;

              for (int i = 0; i < posts.length; i++) {
                // Load-more trigger
                if (i == posts.length - 1 &&
                    hasNextPage &&
                    !isLoadingMore) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context
                        .read<PostsBloc>()
                        .add(LoadMorePosts());
                  });
                }

                items.add(PostWidget(
                    key: ValueKey('post_${posts[i].id}'), post: posts[i]));

                // Inject an ad after every _adInterval posts
                if ((i + 1) % _adInterval == 0 &&
                    ads.isNotEmpty) {
                  final ad = ads[adIndex % ads.length];
                  adIndex++;
                  items.add(
                    BlocProvider.value(
                      value: context.read<AdsBloc>(),
                      child: AdWidget(
                        key: ValueKey('ad_${ad.id}_$i'),
                        ad: ad,
                      ),
                    ),
                  );
                }
              }

              if (isLoadingMore) {
                items.add(const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ));
              }

              // Show shimmer ad placeholder while ads are loading
              if (adsState is AdsLoading &&
                  posts.length >= _adInterval) {
                items.insert(_adInterval, const AdShimmer());
              }

              items.add(SizedBox(height: 120.h));

              return Column(children: items);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}