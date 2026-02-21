import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/main/opportunity/view/widgets/opp_card.dart';
import 'package:sports_in/generated/l10n.dart';

class ForYouTab extends StatelessWidget {
  final void Function(HomeTab) onTabChange;

  const ForYouTab({
    super.key,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;
    
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        return SliverList(
          delegate: SliverChildListDelegate([
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
                      onTabChange(HomeTab.posts);
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
                        strings.oopsSomethingWentWrong,
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
                          context.read<PostsBloc>().add(const FetchPosts());
                        },
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
                          strings.noPostsYet,
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
            
            SizedBox(height: 24.h),
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
                      onTabChange(HomeTab.opportunities);
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
            SizedBox(height: 100.h),
          ]),
        );
      },
    );
  }
}