import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/features/main/home/data/interface/home_tap_enums.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';

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
//     switch (currentTab) {
//       case HomeTab.forYou:
//         return SliverList(
//           delegate: SliverChildListDelegate([
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Row(
//                 children: [
//                   Text(
//                     "Latest posts",
//                     style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () {
//                       onTabChange(HomeTab.posts); // هنا نغير التاب في الـ Parent
//                     },
//                     child:  Text(
//                       "Show all",
//                       style: GoogleFonts.poppins(
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
   
//             const PostWidget(
//               userName: 'User Dronkins',
//               timeAgo: '2 months ago',
//               desc: 'Volunteering with the sports team...',
//               mediaUrl: null,
//               title: "any",
//               likes: 143,
//               comments: 34,
//             ),
//           ]),
//         );

//       case HomeTab.posts:
//         return SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) => const PostWidget(
//               userName: 'User Dronkins',
//               timeAgo: '2 months ago',
//               desc: 'Volunteering with the sports team...',
//               mediaUrl:null ,
//               title: "any",
//               likes: 143,
//               comments: 34, 
//             ),
//             childCount: 5,
//           ),
//         );

//       case HomeTab.courses:
//         return const SliverToBoxAdapter(
//           child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Center(child: Text("Courses tab content")),
//           ),
//         );

//       case HomeTab.opportunities:
//         return const SliverToBoxAdapter(
//           child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Center(child: Text("Opportunities tab content")),
//           ),
//         );
//     }
//   }
// }



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
  return BlocBuilder<PostsBloc, PostsState>(
    builder: (context, state) {
      if (state is PostsLoading) {
        return SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Latest posts",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Show all",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            // Show 3 shimmer placeholders while loading
            const PostShimmer(),
            const PostShimmer(),
            const PostShimmer(),
          ]),
        );
      }

    
      if (state is PostsError) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Retry loading posts
                      context.read<PostsBloc>().add(FetchPosts());
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      'Retry',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (state is PostsLoaded) {
        final posts = state.posts.take(3).toList();
        // If no posts available
        if (posts.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.post_add,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No posts yet',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Latest posts",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
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
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...posts.map(
              (post) => PostWidget(
                userName: post.author.fullName,
                timeAgo: _formatTimeAgo(post.createdAt),
                desc: post.description,
                mediaUrl: post.mediaUrl,
                title: post.title,
                likes: post.likesCount,
                comments: post.commentsCount,
              ),
            ),
          ]),
        );
      }

      return const SliverToBoxAdapter(child: SizedBox.shrink());
    },
  );

     // case HomeTab.forYou:
      //   return BlocBuilder<PostsBloc, PostsState>(
      //     builder: (context, state) {
      //       if (state is PostsLoading) {
      //         return const SliverToBoxAdapter(
      //           child: Center(child: CircularProgressIndicator()),
      //         );
      //       }

      //       if (state is PostsError) {
      //         return SliverToBoxAdapter(
      //           child: Center(child: Text(state.message)),
      //         );
      //       }

      //       if (state is PostsLoaded) {
      //         final posts = state.posts.take(3).toList();
      //         print(posts);
      //         return SliverList(
      //           delegate: SliverChildListDelegate([
      //             Padding(
      //               padding: const EdgeInsets.symmetric(
      //                   vertical: 10, horizontal: 20),
      //               child: Row(
      //                 children: [
      //                   Text(
      //                     "Latest posts",
      //                     style: GoogleFonts.poppins(
      //                       fontSize: 18,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                   const Spacer(),
      //                   GestureDetector(
      //                     onTap: () {
      //                       onTabChange(HomeTab.posts);
      //                     },
      //                     child: Text(
      //                       "Show all",
      //                       style: GoogleFonts.poppins(
      //                         fontSize: 13,
      //                         fontWeight: FontWeight.bold,
      //                         color: Colors.blue,
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             ...posts.map(
      //               (post) => PostWidget(
      //                 userName: post.author.fullName,
      //                 timeAgo: post.createdAt.toIso8601String(),
      //                 desc: post.description,
      //                 mediaUrl: post.mediaUrl,
      //                 title: post.title,
      //                 likes: post.likesCount,
      //                 comments: post.commentsCount,
      //               ),
      //             ),
      //           ]),
      //         );
      //       }

      //       return const SliverToBoxAdapter(child: SizedBox.shrink());
      //     },
      //   );
case HomeTab.posts:
  return BlocBuilder<PostsBloc, PostsState>(
    builder: (context, state) {
      if (state is PostsLoading) {
        return SliverList(
          delegate: SliverChildListDelegate([
            // Show shimmer placeholders while loading
            const PostShimmer(),
            const PostShimmer(),
            const PostShimmer(),
            const PostShimmer(),
            const PostShimmer(),
          ]),
        );
      }

      if (state is PostsError) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Retry loading posts
                      context.read<PostsBloc>().add(FetchPosts());
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      'Retry',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (state is PostsLoaded) {
        final posts = state.posts;
        print(posts);
        
        // If no posts available
        if (posts.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.post_add,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No posts yet',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to create a post!',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final post = posts[index];
              return PostWidget(
                userName: post.author.fullName,
                timeAgo: _formatTimeAgo(post.createdAt),
                desc: post.description,
                mediaUrl: post.mediaUrl,
                title: post.title,
                likes: post.likesCount,
                comments: post.commentsCount,
              );
            },
            childCount: posts.length,
          ),
        );
      }

      return const SliverToBoxAdapter(child: SizedBox.shrink());
    },
  );
     // case HomeTab.posts:
      //   return BlocBuilder<PostsBloc, PostsState>(
      //     builder: (context, state) {
      //       if (state is PostsLoaded) {
      //         return SliverList(
      //           delegate: SliverChildBuilderDelegate(
      //             (context, index) {
      //               final post = state.posts[index];
      //               return PostWidget(
      //                 userName: post.author.fullName,
      //                 timeAgo: post.createdAt.toIso8601String(),
      //                 desc: post.description,
      //                 mediaUrl: post.mediaUrl,
      //                 title: post.title,
      //                 likes: post.likesCount,
      //                 comments: post.commentsCount,
      //               );
      //             },
      //             childCount: state.posts.length,
      //           ),
      //         );
      //       }

      //       return const SliverToBoxAdapter(
      //         child: Center(child: CircularProgressIndicator()),
      //       );
      //     },
      //   );

      case HomeTab.courses:
        return const SliverToBoxAdapter(
          child: Center(child: Text("Courses tab content")),
        );

      case HomeTab.opportunities:
        return const SliverToBoxAdapter(
          child: Center(child: Text("Opportunities tab content")),
        );
    }
  }
}


// Helper function to format time ago (add this as a method in your class)
String _formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  } else if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  } else {
    return 'Just now';
  }
}
 