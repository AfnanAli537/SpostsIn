import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';
import 'package:sports_in/core/utils/helper/time_formate.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
import 'package:sports_in/features/main/home/view/widgets/comment_shimmer.dart';
import 'package:sports_in/features/main/home/view_model/comment_bloc/comment_bloc.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

class CommentsBottomSheet extends StatelessWidget {
  final String postId;
  final Function(int)? onCommentCountChanged;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
    this.onCommentCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommentsBloc(
        commentsRepo: getIt<PostsRepositoryImpl>(),
        prefs: getIt<SharedPreferences>(),
      )..add(FetchComments(postId: postId)),
      child: _CommentsBottomSheetContent(
        postId: postId,
        onCommentCountChanged: onCommentCountChanged,
      ),
    );
  }
}

class _CommentsBottomSheetContent extends StatefulWidget {
  final String postId;
  final Function(int)? onCommentCountChanged;

  const _CommentsBottomSheetContent({
    required this.postId,
    this.onCommentCountChanged,
  });

  @override
  State<_CommentsBottomSheetContent> createState() =>
      _CommentsBottomSheetContentState();
}

class _CommentsBottomSheetContentState
    extends State<_CommentsBottomSheetContent> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _editingCommentId;

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
          context.read<CommentsBloc>().add(
                FetchComments(postId: widget.postId),
              );
        }
      }
    }
  }
  void _navigateToUserProfile(BuildContext context, String userId) {
    Navigator.pushNamed(context, AppRoutes.userProfile, arguments: userId);
  }
  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  Future<void> _showError(BuildContext context, String message) async {
    final msg = await TranslateErrorHelper.translateErrorKeyAsync(
      context,
      message,
    );
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }
  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme= Theme.of(context).colorScheme;

    return BlocListener<CommentsBloc, CommentsState>(
      listenWhen: (previous, current) {
        if (current is CommentsLoaded && current.action != CommentAction.none) {
          return true;
        }
        return current is CommentsError;
      },
      listener: (context, state) {
        if (state is CommentsLoaded) {
          widget.onCommentCountChanged?.call(state.totalCount);
          switch (state.action) {
            case CommentAction.added:
              Fluttertoast.showToast(
                msg: strings.commentAddedSuccessfully,
                backgroundColor: Colors.green,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
              );
              _commentController.clear();
              break;

            case CommentAction.edited:
              Fluttertoast.showToast(
                msg: strings.commentUpdatedSuccessfully,
                backgroundColor: Colors.blue,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
              );
              _cancelEdit();
              break;

            case CommentAction.deleted:
              Fluttertoast.showToast(
                msg: strings.commentDeletedSuccessfully,
                backgroundColor: Colors.orange,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
              );
              break;

            case CommentAction.none:
              break;
          }
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
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                BlocBuilder<CommentsBloc, CommentsState>(
                  builder: (context, state) {
                    final count = state is CommentsLoaded
                        ? state.totalCount
                        : 0;
                    return Text(
                      count > 0 ? '${strings.comments} ($count)' : strings.comments,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: theme.onSurface,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
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
                          return Center(
                            child: Text(
                              strings.noCommentsYet,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: comments.length +
                              (state is CommentsLoaded && state.hasNextPage ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == comments.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            return _buildCommentItem(context, comments[index]);
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
                                child: Text(
                                  strings.retry,
                                  style:  TextStyle(color: theme.surface),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
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
        return buildCommentShimmer(context);
      },
    );
  }


  Widget _buildCommentItem(BuildContext context, CommentModel comment) {
    final strings = S.of(context);
    final theme= Theme.of(context).colorScheme;
    final bloc = context.read<CommentsBloc>();
    final isCurrentUser = comment.userId == bloc.currentUserId;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _editingCommentId == comment.commentId
            ? Colors.blue.withOpacity(0.05)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          GestureDetector(
            onTap: () => _navigateToUserProfile(context, comment.userId),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: comment.profilePictureUrl != null
                  ? NetworkImage(comment.profilePictureUrl!)
                  : null,
              backgroundColor: Colors.grey[300],
              child: comment.profilePictureUrl == null
                  ? Text(
                      (comment.fullName.isNotEmpty ? comment.fullName[0] : 'U')
                          .toUpperCase(),
                      style:  TextStyle(
                        fontWeight: FontWeight.bold,
                        color:theme.onSurface,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _navigateToUserProfile(context, comment.userId),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.fullName,
                        style:  TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatTimeAgo(context,comment.createdAt.toUtc()),
                        style:  TextStyle(color: theme.onSurface, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    comment.text,
                    style:  TextStyle(fontSize: 14, color:theme.onSurface ),
                  ),
                ],
              ),
            ),
          ),
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
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 18),
                      const SizedBox(width: 8),
                      Text(strings.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, size: 18, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        strings.delete,
                        style: const TextStyle(color: Colors.red),
                      ),
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
      _commentController.text = comment.text;
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
    final strings = S.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.deleteComment),
        content: Text(strings.deleteCommentConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(strings.cancel),
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
            child: Text(
              strings.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    final strings = S.of(context);

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
                : Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_editingCommentId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        strings.editingComment,
                        style: const TextStyle(
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
                            ? strings.editYourComment
                            : strings.addAComment,
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
                                  context.read<CommentsBloc>().add(
                                    EditComment(
                                      commentId: _editingCommentId!,
                                      text: _commentController.text.trim(),
                                    ),
                                  );
                                } else {
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
                          _editingCommentId != null
                              ? strings.update
                              : strings.post,
                          style:  TextStyle(fontWeight: FontWeight.w600,color: Theme.of(context).colorScheme.onSurface),
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