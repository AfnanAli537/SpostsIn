// import 'package:flutter/material.dart';

// class CommentsBottomSheet extends StatefulWidget {
//   const CommentsBottomSheet({super.key});

//   @override
//   State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
// }

// class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
//   final TextEditingController _commentController = TextEditingController();

//   List<CommentModel> comments = [
//     CommentModel(
//       username: 'alex_design',
//       timeAgo: '2h',
//       text: 'Exploring the mountains today! #nature #hiking',
//       likes: 0,
//       isLiked: false,
//     ),
//     CommentModel(
//       username: 'traveler_99',
//       timeAgo: '1h',
//       text: 'This view is incredible!',
//       likes: 12,
//       isLiked: false,
//     ),
//     CommentModel(
//       username: 'photo_enthusiast',
//       timeAgo: '45m',
//       text: 'What camera did you use?',
//       likes: 2,
//       isLiked: true,
//     ),
//   ];

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
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(20),
//             ),
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
//                 'Comments',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // 💬 Comments list
//               Expanded(
//                 child: comments.isEmpty
//                     ? const Center(
//                         child: Text(
//                           'No comments yet',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       )
//                     : ListView.builder(
//                         controller: scrollController,
//                         itemCount: comments.length,
//                         itemBuilder: (context, index) {
//                           return _buildCommentItem(comments[index], index);
//                         },
//                       ),
//               ),

//               // ✍️ Input
//               _buildCommentInput(),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // 💬 Comment Item
//   Widget _buildCommentItem(CommentModel comment, int index) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Colors.grey.withOpacity(0.2),
//             width: 0.5,
//           ),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             radius: 18,
//             backgroundColor: Colors.grey[300],
//             child: Text(
//               comment.username[0].toUpperCase(),
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       comment.username,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       comment.timeAgo,
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 _buildCommentText(comment.text),
//                 const SizedBox(height: 6),
//                 InkWell(
//                   onTap: () {
//                     _commentController.text = '@${comment.username} ';
//                   },
//                   child: const Text(
//                     'Reply',
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//       Column(
//   children: [
//     IconButton(
//       icon: Icon(
//         comment.isLiked
//             ? Icons.favorite
//             : Icons.favorite_border,
//         color: comment.isLiked ? Colors.red : Colors.grey,
//         size: 20,
//       ),
//       onPressed: () {
//         setState(() {
//           comment.isLiked = !comment.isLiked;
//           comment.likes += comment.isLiked ? 1 : -1;
//         });
//       },
//     ),

//     if (comment.likes > 0)
//       Text(
//         comment.likes.toString(),
//         style: const TextStyle(fontSize: 12),
//       ),

//     // 🗑 Delete (ONLY current user)
//     if (comment.username == 'current_user')
//       IconButton(
//         icon: const Icon(
//           Icons.delete_outline,
//           size: 18,
//           color: Colors.grey,
//         ),
//         onPressed: () {
//           setState(() {
//             comments.removeAt(index);
//           });

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Comment deleted'),
//               duration: Duration(seconds: 1),
//             ),
//           );
//         },
//       ),
//   ],
// ),
//       ],
//       ),
//     );
//   }

//   // 📝 Comment Text (hashtags & mentions)
//   Widget _buildCommentText(String text) {
//     final words = text.split(' ');
//     return RichText(
//       text: TextSpan(
//         children: words.map((word) {
//           final isTag = word.startsWith('#') || word.startsWith('@');
//           return TextSpan(
//             text: '$word ',
//             style: TextStyle(
//               color: isTag ? Colors.blue : Colors.black87,
//               fontSize: 14,
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   // ✍️ Input
//  Widget _buildCommentInput() {
//   return AnimatedPadding(
//     duration: const Duration(milliseconds: 250),
//     curve: Curves.easeOut,
//     padding: EdgeInsets.only(
//       bottom: MediaQuery.of(context).viewInsets.bottom,
//     ),
//     child: SafeArea(
//       top: false,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border(
//             top: BorderSide(
//               color: Colors.grey.withOpacity(0.3),
//             ),
//           ),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.grey[300],
//               child: const Icon(Icons.person),
//             ),
//             const SizedBox(width: 12),

//             Expanded(
//               child: TextField(
//               onTapOutside: (_) => FocusScope.of(context).unfocus(),
//                 controller: _commentController,
//                 decoration: const InputDecoration(
//                   hintText: 'Add a comment...',
//                   border: InputBorder.none,
//                 ),
//                 maxLines: null,
//               ),
//             ),

//             TextButton(
//               onPressed: () {
//                 if (_commentController.text.trim().isEmpty) return;

//                 setState(() {
//                   comments.insert(
//                     0,
//                     CommentModel(
//                       username: 'current_user',
//                       timeAgo: 'Now',
//                       text: _commentController.text,
//                       likes: 0,
//                       isLiked: false,
//                     ),
//                   );
//                 });

//                 _commentController.clear();
//               },
//               child: const Text(
//                 'Post',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }
// }

// // 📦 Model
// class CommentModel {
//   final String username;
//   final String timeAgo;
//   final String text;
//   int likes;
//   bool isLiked;

//   CommentModel({
//     required this.username,
//     required this.timeAgo,
//     required this.text,
//     required this.likes,
//     required this.isLiked,
//   });
// }



// // comments_bottom_sheet.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sports_in/app/di/injection.dart';
// import 'package:sports_in/core/utils/helper/time_formate.dart';
// import 'package:sports_in/features/main/home/data/model/comment_model.dart';
// import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
// import 'package:sports_in/features/main/home/view_model/comment_bloc/comment_bloc.dart';


// class CommentsBottomSheet extends StatelessWidget {
//   final String postId;

//   const CommentsBottomSheet({
//     super.key,
//     required this.postId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => CommentsBloc(
//         commentsRepo: getIt<PostsRepositoryImpl>(),
//         prefs: getIt<SharedPreferences>(),
//       )..add(FetchComments(postId: postId)),
//       child: _CommentsBottomSheetContent(postId: postId),
//     );
//   }
// }

// class _CommentsBottomSheetContent extends StatefulWidget {
//   final String postId;

//   const _CommentsBottomSheetContent({required this.postId});

//   @override
//   State<_CommentsBottomSheetContent> createState() =>
//       _CommentsBottomSheetContentState();
// }

// class _CommentsBottomSheetContentState
//     extends State<_CommentsBottomSheetContent> {
//   final TextEditingController _commentController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   String? _editingCommentId;
//   int _currentPage = 1;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (!mounted) return;

//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent * 0.9) {
//       final state = context.read<CommentsBloc>().state;
//       if (state is CommentsLoaded && state.hasNextPage) {
//         if (state is! CommentsLoadingMore) {
//           _currentPage++;
//           context.read<CommentsBloc>().add(
//                 FetchComments(
//                   postId: widget.postId,
//                   pageNumber: _currentPage,
//                 ),
//               );
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _commentController.dispose();
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<CommentsBloc, CommentsState>(
//       listener: (context, state) {
//         if (state is CommentAdded) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Comment added'),
//               duration: Duration(seconds: 1),
//               backgroundColor: Colors.green,
//             ),
//           );
//         } else if (state is CommentDeleted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Comment deleted'),
//               duration: Duration(seconds: 1),
//               backgroundColor: Colors.orange,
//             ),
//           );
//         } else if (state is CommentEdited) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Comment updated'),
//               duration: Duration(seconds: 1),
//               backgroundColor: Colors.blue,
//             ),
//           );
//           _cancelEdit();
//         } else if (state is CommentsError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       child: DraggableScrollableSheet(
//         initialChildSize: 0.7,
//         minChildSize: 0.4,
//         maxChildSize: 0.95,
//         expand: false,
//         builder: (context, scrollController) {
//           return Container(
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Column(
//               children: [
//                 // Handle bar
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: Container(
//                     width: 40,
//                     height: 5,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),

//                 // Title with count
//                 BlocBuilder<CommentsBloc, CommentsState>(
//                   builder: (context, state) {
//                     final count = state is CommentsLoaded ? state.totalCount : 0;
//                     return Text(
//                       'Comments${count > 0 ? ' ($count)' : ''}',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     );
//                   },
//                 ),

//                 const SizedBox(height: 12),

//                 // Comments List
//                 Expanded(
//                   child: BlocBuilder<CommentsBloc, CommentsState>(
//                     builder: (context, state) {
//                       if (state is CommentsLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (state is CommentsLoaded ||
//                           state is CommentsLoadingMore) {
//                         final comments = state is CommentsLoaded
//                             ? state.comments
//                             : (state as CommentsLoadingMore).currentComments;

//                         if (comments.isEmpty) {
//                           return const Center(
//                             child: Text(
//                               'No comments yet',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           );
//                         }

//                         return ListView.builder(
//                           controller: _scrollController,
//                           itemCount: comments.length +
//                               (state is CommentsLoaded && state.hasNextPage
//                                   ? 1
//                                   : 0),
//                           itemBuilder: (context, index) {
//                             if (index == comments.length) {
//                               return const Padding(
//                                 padding: EdgeInsets.all(16.0),
//                                 child: Center(
//                                     child: CircularProgressIndicator()),
//                               );
//                             }

//                             return _buildCommentItem(
//                               context,
//                               comments[index],
//                             );
//                           },
//                         );
//                       } else if (state is CommentsError) {
//                         return Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 state.message,
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(color: Colors.red),
//                               ),
//                               const SizedBox(height: 16),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   context.read<CommentsBloc>().add(
//                                         FetchComments(
//                                           postId: widget.postId,
//                                           isRefresh: true,
//                                         ),
//                                       );
//                                 },
//                                 child: const Text('Retry',style:TextStyle(color: Colors.black)),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                       return const SizedBox.shrink();
//                     },
//                   ),
//                 ),

//                 // Input
//                 _buildCommentInput(context),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCommentItem(BuildContext context, CommentModel comment) {
//     final bloc = context.read<CommentsBloc>();
//     final isCurrentUser = comment.userId == bloc.currentUserId;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: _editingCommentId == comment.commentId
//             ? Colors.blue.withOpacity(0.05)
//             : Colors.transparent,
//         border: Border(
//           bottom: BorderSide(
//             color: Colors.grey.withOpacity(0.2),
//             width: 0.5,
//           ),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Avatar
//           CircleAvatar(
//             radius: 18,
//             backgroundImage: comment.profilePictureUrl != null
//                 ? NetworkImage(comment.profilePictureUrl!)
//                 : null,
//             backgroundColor: Colors.grey[300],
//             child: comment.profilePictureUrl == null
//                 ? Text(
//                     comment.fullName[0].toUpperCase(),
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   )
//                 : null,
//           ),
//           const SizedBox(width: 12),

//           // Content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       comment.fullName,
//                       style: const TextStyle(fontWeight: FontWeight.w600,color:Colors.black),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       formatTimeAgo(comment.createdAt),
//                       style: const TextStyle(color: Colors.black, fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   comment.text!,
                  
//                   style: const TextStyle(fontSize: 14,color: Colors.black),
//                 ),
//               ],
//             ),
//           ),

//           // Actions (Edit & Delete) - Only for current user
//           if (isCurrentUser)
//             PopupMenuButton<String>(
//               icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
//               onSelected: (value) {
//                 if (value == 'edit') {
//                   _startEdit(comment);
//                 } else if (value == 'delete') {
//                   _showDeleteDialog(context, comment);
//                 }
//               },
//               itemBuilder: (context) => [
//                 const PopupMenuItem(
//                   value: 'edit',
//                   child: Row(
//                     children: [
//                       Icon(Icons.edit, size: 18),
//                       SizedBox(width: 8),
//                       Text('Edit'),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'delete',
//                   child: Row(
//                     children: [
//                       Icon(Icons.delete, size: 18, color: Colors.red),
//                       SizedBox(width: 8),
//                       Text('Delete', style: TextStyle(color: Colors.red)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }

//   void _startEdit(CommentModel comment) {
//     setState(() {
//       _editingCommentId = comment.commentId;
//       _commentController.text = comment.text!;
//     });
//     FocusScope.of(context).requestFocus(FocusNode());
//   }

//   void _cancelEdit() {
//     setState(() {
//       _editingCommentId = null;
//       _commentController.clear();
//     });
//   }

//   void _showDeleteDialog(BuildContext context, CommentModel comment) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: const Text('Delete Comment'),
//         content: const Text('Are you sure you want to delete this comment?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<CommentsBloc>().add(
//                     DeleteComment(
//                       postId: widget.postId,
//                       commentId: comment.commentId,
//                     ),
//                   );
//               Navigator.pop(dialogContext);
//             },
//             child: const Text(
//               'Delete',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCommentInput(BuildContext context) {
//     return AnimatedPadding(
//       duration: const Duration(milliseconds: 250),
//       curve: Curves.easeOut,
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: SafeArea(
//         top: false,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           decoration: BoxDecoration(
//             color: _editingCommentId != null
//                 ? Colors.blue.withOpacity(0.05)
//                 : Colors.white,
//             border: Border(
//               top: BorderSide(color: Colors.grey.withOpacity(0.3)),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Edit mode indicator
//               if (_editingCommentId != null)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.edit, size: 16, color: Colors.blue),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Editing comment',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const Spacer(),
//                       InkWell(
//                         onTap: _cancelEdit,
//                         child: const Icon(
//                           Icons.close,
//                           size: 18,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               // Input row
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 18,
//                     backgroundColor: Colors.grey[300],
//                     child: const Icon(Icons.person, color: Colors.white),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: TextField(
//                       onTapOutside: (_) => FocusScope.of(context).unfocus(),
//                       controller: _commentController,
//                       decoration: InputDecoration(
//                         hintText: _editingCommentId != null
//                             ? 'Edit your comment...'
//                             : 'Add a comment...',
//                         border: InputBorder.none,
//                       ),
//                       maxLines: null,
//                     ),
//                   ),
//                   BlocBuilder<CommentsBloc, CommentsState>(
//                     builder: (context, state) {
//                       final isAdding = state is CommentAdding;

//                       return TextButton(
//                         onPressed: isAdding
//                             ? null
//                             : () {
//                                 if (_commentController.text.trim().isEmpty) {
//                                   return;
//                                 }

//                                 if (_editingCommentId != null) {
//                                   // Edit
//                                   context.read<CommentsBloc>().add(
//                                         EditComment(
//                                           commentId: _editingCommentId!,
//                                           text: _commentController.text.trim(),
//                                         ),
//                                       );
//                                 } else {
//                                   // Add
//                                   context.read<CommentsBloc>().add(
//                                         AddComment(
//                                           postId: widget.postId,
//                                           text: _commentController.text.trim(),
//                                         ),
//                                       );
//                                   _commentController.clear();
//                                 }
//                               },
//                         child: Text(
//                           _editingCommentId != null ? 'Update' : 'Post',
//                           style: const TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






// comments_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/utils/helper/time_formate.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
import 'package:sports_in/features/main/home/view_model/comment_bloc/comment_bloc.dart';
import 'package:shimmer/shimmer.dart';


class CommentsBottomSheet extends StatelessWidget {
  final String postId;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommentsBloc(
        commentsRepo: getIt<PostsRepositoryImpl>(),
        prefs: getIt<SharedPreferences>(),
      )..add(FetchComments(postId: postId)),
      child: _CommentsBottomSheetContent(postId: postId),
    );
  }
}

class _CommentsBottomSheetContent extends StatefulWidget {
  final String postId;

  const _CommentsBottomSheetContent({required this.postId});

  @override
  State<_CommentsBottomSheetContent> createState() =>
      _CommentsBottomSheetContentState();
}

class _CommentsBottomSheetContentState
    extends State<_CommentsBottomSheetContent> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _editingCommentId;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<CommentsBloc>().state;
      if (state is CommentsLoaded && state.hasNextPage) {
        if (state is! CommentsLoadingMore) {
          _currentPage++;
          context.read<CommentsBloc>().add(
                FetchComments(
                  postId: widget.postId,
                  pageNumber: _currentPage,
                ),
              );
        }
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state is CommentAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment added'),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is CommentDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment deleted'),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (state is CommentEdited) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment updated'),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.blue,
            ),
          );
          _cancelEdit();
        } else if (state is CommentsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
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

                // Title with count
                BlocBuilder<CommentsBloc, CommentsState>(
                  builder: (context, state) {
                    final count = state is CommentsLoaded ? state.totalCount : 0;
                    return Text(
                      'Comments${count > 0 ? ' ($count)' : ''}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Comments List
                Expanded(
                  child: BlocBuilder<CommentsBloc, CommentsState>(
                    builder: (context, state) {
                      if (state is CommentsLoading) {
                        return _buildShimmerLoading();
                      } else if (state is CommentsLoaded ||
                          state is CommentsLoadingMore) {
                        final comments = state is CommentsLoaded
                            ? state.comments
                            : (state as CommentsLoadingMore).currentComments;

                        if (comments.isEmpty) {
                          return const Center(
                            child: Text(
                              'No comments yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: comments.length +
                              (state is CommentsLoaded && state.hasNextPage
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index == comments.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                    child: CircularProgressIndicator()),
                              );
                            }

                            return _buildCommentItem(
                              context,
                              comments[index],
                            );
                          },
                        );
                      } else if (state is CommentsError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<CommentsBloc>().add(
                                        FetchComments(
                                          postId: widget.postId,
                                          isRefresh: true,
                                        ),
                                      );
                                },
                                child: const Text('Retry',style:TextStyle(color: Colors.black)),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                // Input
                _buildCommentInput(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildCommentShimmer();
      },
    );
  }

  Widget _buildCommentShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar shimmer
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 12),

            // Content shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
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
  }

  Widget _buildCommentItem(BuildContext context, CommentModel comment) {
    final bloc = context.read<CommentsBloc>();
    final isCurrentUser = comment.userId == bloc.currentUserId;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _editingCommentId == comment.commentId
            ? Colors.blue.withOpacity(0.05)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: comment.profilePictureUrl != null
                ? NetworkImage(comment.profilePictureUrl!)
                : null,
            backgroundColor: Colors.grey[300],
            child: comment.profilePictureUrl == null
                ? Text(
                    comment.fullName[0].toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w600,color:Colors.black),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatTimeAgo(comment.createdAt),
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.text!,
                  
                  style: const TextStyle(fontSize: 14,color: Colors.black),
                ),
              ],
            ),
          ),

          // Actions (Edit & Delete) - Only for current user
          if (isCurrentUser)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
              onSelected: (value) {
                if (value == 'edit') {
                  _startEdit(comment);
                } else if (value == 'delete') {
                  _showDeleteDialog(context, comment);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _startEdit(CommentModel comment) {
    setState(() {
      _editingCommentId = comment.commentId;
      _commentController.text = comment.text!;
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _cancelEdit() {
    setState(() {
      _editingCommentId = null;
      _commentController.clear();
    });
  }

  void _showDeleteDialog(BuildContext context, CommentModel comment) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CommentsBloc>().add(
                    DeleteComment(
                      postId: widget.postId,
                      commentId: comment.commentId,
                    ),
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _editingCommentId != null
                ? Colors.blue.withOpacity(0.05)
                : Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit mode indicator
              if (_editingCommentId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Editing comment',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: _cancelEdit,
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

              // Input row
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: _editingCommentId != null
                            ? 'Edit your comment...'
                            : 'Add a comment...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                  BlocBuilder<CommentsBloc, CommentsState>(
                    builder: (context, state) {
                      final isAdding = state is CommentAdding;

                      return TextButton(
                        onPressed: isAdding
                            ? null
                            : () {
                                if (_commentController.text.trim().isEmpty) {
                                  return;
                                }

                                if (_editingCommentId != null) {
                                  // Edit
                                  context.read<CommentsBloc>().add(
                                        EditComment(
                                          commentId: _editingCommentId!,
                                          text: _commentController.text.trim(),
                                        ),
                                      );
                                } else {
                                  // Add
                                  context.read<CommentsBloc>().add(
                                        AddComment(
                                          postId: widget.postId,
                                          text: _commentController.text.trim(),
                                        ),
                                      );
                                  _commentController.clear();
                                }
                              },
                        child: Text(
                          _editingCommentId != null ? 'Update' : 'Post',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}