// import 'package:flutter/material.dart';

// class LikesBottomSheet extends StatefulWidget {
//   const LikesBottomSheet({super.key});

//   @override
//   State<LikesBottomSheet> createState() => _LikesBottomSheetState();
// }

// class _LikesBottomSheetState extends State<LikesBottomSheet> {
//   final TextEditingController _searchController = TextEditingController();

//   List<UserModel> users = [
//     UserModel(username: 'alex_j', fullName: 'Alex Johnson', isFollowing: false),
//     UserModel(username: 'sam_design', fullName: 'Sam Designer', isFollowing: true),
//     UserModel(username: 'photography_pro', fullName: 'Chris Evans', isFollowing: false),
//     UserModel(username: 'daily_vlog', fullName: 'Sarah Jenkins', isFollowing: true),
//     UserModel(username: 'tech_guru_99', fullName: 'Marcus Wright', isFollowing: false),
//     UserModel(username: 'foodie_adventures', fullName: 'Elena Gomez', isFollowing: true),
//     UserModel(username: 'creative_mind', fullName: 'James Taylor', isFollowing: false),
//   ];

//   List<UserModel> filteredUsers = [];

//   @override
//   void initState() {
//     super.initState();
//     filteredUsers = users;
//     _searchController.addListener(_filterUsers);
//   }

//   void _filterUsers() {
//     setState(() {
//       if (_searchController.text.isEmpty) {
//         filteredUsers = users;
//       } else {
//         filteredUsers = users.where((user) {
//           return user.username.toLowerCase().contains(_searchController.text.toLowerCase()) ||
//               user.fullName.toLowerCase().contains(_searchController.text.toLowerCase());
//         }).toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.7,
//       minChildSize: 0.4,
//       maxChildSize: 0.95,
//       expand: false,
//       builder: (context, scrollController) {
//         return Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             children: [
//               // 🔘 Handle bar
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 child: Container(
//                   width: 40,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),

//               // 📝 Title
//               const Text(
//                 'Likes',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 12),

//               // 🔍 Search
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search',
//                       prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // 👥 Users list
//               Expanded(
//                 child: filteredUsers.isEmpty
//                     ? const Center(
//                         child: Text('No users found', style: TextStyle(color: Colors.grey)),
//                       )
//                     : ListView.builder(
//                         controller: scrollController,
//                         itemCount: filteredUsers.length,
//                         itemBuilder: (context, index) {
//                           return _buildUserItem(filteredUsers[index]);
//                         },
//                       ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildUserItem(UserModel user) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 22,
//             backgroundColor: Colors.grey[300],
//             child: Text(
//               user.username[0].toUpperCase(),
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(user.username,
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 2),
//                 Text(user.fullName, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//               ],
//             ),
//           ),
//           SizedBox(
//             width: 100,
//             height: 36,
//             child: ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   user.isFollowing = !user.isFollowing;
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: user.isFollowing ? Colors.grey[200] : const Color(0xFF0095F6),
//                 foregroundColor: user.isFollowing ? Colors.black : Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               child: Text(
//                 user.isFollowing ? 'Following' : 'Follow',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: user.isFollowing ? Colors.black : Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }

// // 📦 Model
// class UserModel {
//   final String username;
//   final String fullName;
//   bool isFollowing;

//   UserModel({required this.username, required this.fullName, required this.isFollowing});
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:sports_in/core/utils/helper/time_formate.dart';
// import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';

// class LikesSheet extends StatefulWidget {
//   final String postId;
//   const LikesSheet({super.key, required this.postId});

//   @override
//   State<LikesSheet> createState() => _LikesSheetState();
// }

// class _LikesSheetState extends State<LikesSheet> {
//   final ScrollController _scrollController = ScrollController();
//   int _currentPage = 1;

//   @override
//   void initState() {
//     super.initState();
//     context.read<PostsBloc>().add(ListLikes(
//           postId: widget.postId,
//           page: 1,
//           isRefresh: true,
//         ));

//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent * 0.9) {
//       final state = context.read<PostsBloc>().state;
//       if (state is PostsLikesLoaded && state.hasMore) {
//         if (state is! PostsLikesLoadingMore) {
//           _currentPage++;
//           context.read<PostsBloc>().add(ListLikes(
//                 postId: widget.postId,
//                 page: _currentPage,
//               ));
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.7,
//       minChildSize: 0.4,
//       maxChildSize: 0.95,
//       expand: false,
//       builder: (context, scrollController) {
//         return Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             children: [
//               // Handle bar
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 child: Container(
//                   width: 40,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               const Text(
//                 'Likes',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 12),

//               // Users list
//               Expanded(
//                 child: BlocBuilder<PostsBloc, PostsState>(
//                   builder: (context, state) {
//                     if (state is PostsLikesLoading) {
//                       return _buildShimmerLoading();
//                     } else if (state is PostsLikesLoaded ||
//                         state is PostsLikesLoadingMore) {
//                       final likes = state is PostsLikesLoaded
//                           ? state.likes
//                           : (state as PostsLikesLoadingMore).currentLikes;

//                       if (likes.isEmpty) {
//                         return const Center(
//                           child: Text('No likes yet'),
//                         );
//                       }

//                       return ListView.builder(
//                         controller: _scrollController,
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: likes.length +
//                             (state is PostsLikesLoaded && state.hasMore ? 1 : 0),
//                         itemBuilder: (context, index) {
//                           if (index == likes.length) {
//                             return const Padding(
//                               padding: EdgeInsets.all(16.0),
//                               child: Center(
//                                 child: CircularProgressIndicator(),
//                               ),
//                             );
//                           }

//                           final user = likes[index];
//                           return Container(
//                             margin: const EdgeInsets.only(bottom: 12),
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: Colors.grey[300]!,
//                                 width: 1,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.1),
//                                   spreadRadius: 1,
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 24,
//                                   backgroundImage: user.profilePhoto != null
//                                       ? NetworkImage(user.profilePhoto!)
//                                       : null,
//                                   backgroundColor: Colors.grey[300],
//                                   child: user.profilePhoto == null
//                                       ? Text(
//                                           user.fullName.isNotEmpty
//                                               ? user.fullName[0].toUpperCase()
//                                               : 'U',
//                                           style: const TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         )
//                                       : null,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         user.fullName,
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         formatTimeAgo(DateTime.parse(user.createdAt)),
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     } else if (state is PostsLikesError) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Error: ${state.message}',
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(color: Colors.red),
//                             ),
//                             const SizedBox(height: 16),
//                             ElevatedButton(
//                               onPressed: () {
//                                 context.read<PostsBloc>().add(ListLikes(
//                                       postId: widget.postId,
//                                       page: 1,
//                                       isRefresh: true,
//                                     ));
//                               },
//                               child: const Text('Retry'),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     return const SizedBox.shrink();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildShimmerLoading() {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: 10,
//       itemBuilder: (context, index) {
//         return Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: Colors.grey[300]!,
//               width: 1,
//             ),
//           ),
//           child: Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundColor: Colors.grey[300],
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: 16,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         width: 100,
//                         height: 12,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/time_formate.dart';
import 'package:sports_in/features/main/home/view_model/likes_bloc/likes_bloc.dart';

class LikesSheet extends StatefulWidget {
  final String postId;
  const LikesSheet({super.key, required this.postId});

  @override
  State<LikesSheet> createState() => _LikesSheetState();
}

class _LikesSheetState extends State<LikesSheet> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  late LikesBloc _bloc;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _bloc = context.read<LikesBloc>();
      _bloc.add(FetchLikes(postId: widget.postId, page: 1, isRefresh: true));
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = _bloc.state;
      if (state is LikesLoaded && state.hasMore) {
        if (state is! LikesLoadingMore) {
          _currentPage++;
          _bloc.add(FetchLikes(postId: widget.postId, page: _currentPage));
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                'Likes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: BlocBuilder<LikesBloc, LikesState>(
                  builder: (context, state) {
                    if (state is LikesLoading) {
                      return _buildShimmerLoading();
                    } else if (state is LikesLoaded ||
                        state is LikesLoadingMore) {
                      final likes = state is LikesLoaded
                          ? state.likes
                          : (state as LikesLoadingMore).currentLikes;

                      if (likes.isEmpty) {
                        return const Center(
                          child: Text(
                            'No likes yet',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount:
                            likes.length +
                            (state is LikesLoaded && state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == likes.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final user = likes[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.userProfile,
                                  arguments: user.userId,
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: user.profilePhoto != null
                                        ? NetworkImage(user.profilePhoto!)
                                        : null,
                                    backgroundColor: Colors.grey[300],
                                    child: user.profilePhoto == null
                                        ? Text(
                                            user.fullName.isNotEmpty
                                                ? user.fullName[0].toUpperCase()
                                                : 'U',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.fullName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formatTimeAgo(
                                            DateTime.parse(
                                              user.createdAt,
                                            ).toUtc(),
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is LikesError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${state.message}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (mounted) {
                                  _bloc.add(
                                    FetchLikes(
                                      postId: widget.postId,
                                      page: 1,
                                      isRefresh: true,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              children: [
                CircleAvatar(radius: 24, backgroundColor: Colors.grey[300]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
