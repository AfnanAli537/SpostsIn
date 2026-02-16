// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sports_in/core/enums/home_enums.dart';
// import 'package:sports_in/features/main/home/view/widgets/post.dart';
// import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
// import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
// import 'package:sports_in/features/main/opportunity/view/presentation/opportunity_list.dart';
// import 'package:sports_in/features/main/opportunity/view/widgets/opp_card.dart';

// class BuildContent extends StatelessWidget {
//   final HomeTab currentTab;
//   final void Function(HomeTab) onTabChange;

//   const BuildContent({
//     super.key,
//     required this.currentTab,
//     required this.onTabChange,
//   });

//   @override
//   Widget build(BuildContext context) {
//    final theme=Theme.of(context).colorScheme;
//     switch (currentTab) {
//      case HomeTab.forYou:
//         return BlocBuilder<PostsBloc, PostsState>(
//           builder: (context, state) {
//             return SliverList(
//               delegate: SliverChildListDelegate([
//                 // Latest Posts Header - Always visible
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     vertical: 10.h,
//                     horizontal: 20.w,
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         "Latest posts",
//                         style: GoogleFonts.poppins(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       GestureDetector(
//                         onTap: () {
//                           onTabChange(HomeTab.posts);
//                         },
//                         child: Text(
//                           "Show all",
//                           style: GoogleFonts.poppins(
//                             fontSize: 13.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 // Content based on state
//                 if (state is PostsLoading) ...[
//                   const PostShimmer(),
//                 ] else if (state is PostsError) ...[
//                   Padding(
//                     padding: EdgeInsets.all(20.w),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.error_outline,
//                             size: 64.sp,
//                             color: Colors.red[300],
//                           ),
//                           SizedBox(height: 16.h),
//                           Text(
//                             'Oops! Something went wrong',
//                             style: GoogleFonts.poppins(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                           SizedBox(height: 8.h),
//                           Text(
//                             state.message,
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.poppins(
//                               fontSize: 14.sp,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: 24.h),
//                           ElevatedButton.icon(
//                             onPressed: () {
//                               context.read<PostsBloc>().add(FetchPosts());
//                             },
//                             icon: const Icon(Icons.refresh),
//                             label: Text(
//                               'Retry',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: theme.primary,
//                               foregroundColor:theme.surface,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 32.w,
//                                 vertical: 12.h,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.r),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ] else if (state is PostsLoaded) ...[
//                   if (state.posts.isEmpty)
//                     Padding(
//                       padding: EdgeInsets.all(40.w),
//                       child: Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.post_add,
//                               size: 64.sp,
//                               color: Colors.grey[400],
//                             ),
//                             SizedBox(height: 16.h),
//                             Text(
//                               'No posts yet',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18.sp,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   else
//                     ...state.posts.take(1).map(
//                       (post) => PostWidget(
//                         key: ValueKey(post.id),
//                          post: post,
//                       ),
//                     ),
//                 ],
                
//                 // Add more sections here in the future
//                 // Example:
//                 SizedBox(height: 24.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     vertical: 10.h,
//                     horizontal: 20.w,
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         "Opportunities",
//                         style: GoogleFonts.poppins(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       GestureDetector(
//                         onTap: () {
//                           onTabChange(HomeTab.opportunities);
//                         },
//                         child: Text(
//                           "Show all",
//                           style: GoogleFonts.poppins(
//                             fontSize: 13.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 LatestOpportunityCard(),
//                 SizedBox(height: 100.h),
//                 // SizedBox(
//                 //   height: 400.h, 
//                 //   child: const OpportunitiesScreen(),
//                 // ),
//                 // ... achievement widgets ...
//                 // const OpportunitiesSection(),
//               ]),
//             );
//           },
//         );
//    case HomeTab.posts:
//         return BlocBuilder<PostsBloc, PostsState>(
//           builder: (context, state) {
//             if (state is PostsLoading) {
//               return SliverList(
//                 delegate: SliverChildListDelegate([
//                   // Posts Header
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: 10.h,
//                       horizontal: 20.w,
//                     ),
//                     child: Text(
//                       "Posts",
//                       style: GoogleFonts.poppins(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const PostShimmer(),
//                   const PostShimmer(),
//                   const PostShimmer(),
//                   const PostShimmer(),
//                   const PostShimmer(),
//                 ]),
//               );
//             }

//             if (state is PostsError) {
//               return SliverList(
//                 delegate: SliverChildListDelegate([
//                   // Posts Header
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: 10.h,
//                       horizontal: 20.w,
//                     ),
//                     child: Text(
//                       "Posts",
//                       style: GoogleFonts.poppins(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(20.w),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.error_outline,
//                             size: 64.sp,
//                             color: Colors.red[300],
//                           ),
//                           SizedBox(height: 16.h),
//                           Text(
//                             'Oops! Something went wrong',
//                             style: GoogleFonts.poppins(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                           SizedBox(height: 8.h),
//                           Text(
//                             state.message,
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.poppins(
//                               fontSize: 14.sp,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: 24.h),
//                           ElevatedButton.icon(
//                             onPressed: () {
//                               // Retry loading posts
//                               context.read<PostsBloc>().add(FetchPosts());
//                             },
//                             icon: const Icon(Icons.refresh),
//                             label: Text(
//                               'Retry',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                          backgroundColor: theme.primary,
//                               foregroundColor:theme.surface,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 32.w,
//                                 vertical: 12.h,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.r),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ]),
//               );
//             }

//             // Handle both PostsLoaded and PostsLoadingMore states
//             if (state is PostsLoaded || state is PostsLoadingMore) {
//               final posts = state is PostsLoaded 
//                   ? state.posts 
//                   : (state as PostsLoadingMore).currentPosts;
//               final hasNextPage = state is PostsLoaded ? state.hasNextPage : true;
//               final isLoadingMore = state is PostsLoadingMore;
              
//               if (posts.isEmpty) {
//                 return SliverList(
//                   delegate: SliverChildListDelegate([
//                     // Posts Header
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 10.h,
//                         horizontal: 20.w,
//                       ),
//                       child: Text(
//                         "Posts",
//                         style: GoogleFonts.poppins(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(40.w),
//                       child: Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.post_add,
//                               size: 64.sp,
//                               color: Colors.grey[400],
//                             ),
//                             SizedBox(height: 16.h),
//                             Text(
//                               'No posts yet',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18.sp,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             SizedBox(height: 8.h),
//                             Text(
//                               'Be the first to create a post!',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 14.sp,
//                                 color: Colors.grey[500],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ]),
//                 );
//               }
//               return SliverList(
//                 delegate: SliverChildBuilderDelegate((context, index) {
//                   // First item is the header
//                   if (index == 0) {
//                     return Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 10.h,
//                         horizontal: 20.w,
//                       ),
//                       child: Text(
//                         "Posts",
//                         style: GoogleFonts.poppins(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     );
//                   }
                  
//                   // Adjust index for posts array
//                   final postIndex = index - 1;
                  
//                   // Check if we're at the last item and need to load more
//                   if (postIndex == posts.length - 1 && hasNextPage && !isLoadingMore) {
//                     // Trigger pagination only once
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       context.read<PostsBloc>().add(LoadMorePosts());
//                     });
//                   }
                  
//                   final post = posts[postIndex];
                  
//                   return Column(
//                     children: [
//                       PostWidget(
//                         key: ValueKey(post.id),
//                         post: post,
//                       ),
//                       // Show loading indicator at the last item if loading more
//                       if (postIndex == posts.length - 1 && isLoadingMore)
//                         const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Center(child: CircularProgressIndicator()),
//                         ),
//                       // Add spacing at the very end
//                       if (postIndex == posts.length - 1)
//                         const SizedBox(height: 100),
//                     ],
//                   );
//                 }, childCount: posts.length + 1), 
//               );
         
//             }
                 
//             return const SliverToBoxAdapter(child: SizedBox.shrink());
//           },
//         );
    
//       case HomeTab.courses:
//         return const SliverToBoxAdapter(
//           child: Center(child: Text("Courses tab content")),
//         );

//       case HomeTab.opportunities:
//       return const OpportunitiesContent();
     
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/features/main/home/view/presentation/courses_tab.dart';
import 'package:sports_in/features/main/home/view/presentation/home_tab.dart';
import 'package:sports_in/features/main/home/view/presentation/posts_tab.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/opportunity_list.dart';

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
    switch (currentTab) {
      case HomeTab.forYou:
        return ForYouTab(onTabChange: onTabChange);
      
      case HomeTab.posts:
        return PostsTab();
      
      case HomeTab.courses:
        return const CoursesTab();
      
      case HomeTab.opportunities:
        return const OpportunitiesContent();
    }
  }
}