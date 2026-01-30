import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/features/main/home/data/interface/home_tap_enums.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
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
              return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is PostsError) {
              return SliverToBoxAdapter(
                child: Center(child: Text(state.message)),
              );
            }

            if (state is PostsLoaded) {
              final posts = state.posts.take(3).toList();

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
                      timeAgo: post.createdAt.toIso8601String(),
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

      case HomeTab.posts:
        return BlocBuilder<PostsBloc, PostsState>(
          builder: (context, state) {
            if (state is PostsLoaded) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = state.posts[index];
                    return PostWidget(
                      userName: post.author.fullName,
                      timeAgo: post.createdAt.toIso8601String(),
                      desc: post.description,
                      mediaUrl: post.mediaUrl,
                      title: post.title,
                      likes: post.likesCount,
                      comments: post.commentsCount,
                    );
                  },
                  childCount: state.posts.length,
                ),
              );
            }

            return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          },
        );

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
