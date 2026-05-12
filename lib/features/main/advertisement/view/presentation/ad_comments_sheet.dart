import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';
import 'package:sports_in/core/utils/helper/time_formate.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/advertisement/view_model/comment_bloc/comment_bloc.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';
import 'package:sports_in/features/main/home/view/widgets/comment_shimmer.dart';
import 'package:sports_in/generated/l10n.dart';

class AdCommentsSheet extends StatelessWidget {
  final String adId;
  final Function(int)? onCommentCountChanged;

  const AdCommentsSheet({
    super.key,
    required this.adId,
    this.onCommentCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdCommentsBloc(
        adsRepo: getIt<AdsRepositoryImpl>(),
        sharedPreferences: getIt<SharedPreferences>(),
      )..add(FetchAdComments(adId: adId)),
      child: _AdCommentsSheetContent(
        adId: adId,
        onCommentCountChanged: onCommentCountChanged,
      ),
    );
  }
}

class _AdCommentsSheetContent extends StatefulWidget {
  final String adId;
  final Function(int)? onCommentCountChanged;

  const _AdCommentsSheetContent({
    required this.adId,
    this.onCommentCountChanged,
  });

  @override
  State<_AdCommentsSheetContent> createState() =>
      _AdCommentsSheetContentState();
}

class _AdCommentsSheetContentState extends State<_AdCommentsSheetContent> {
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
      final state = context.read<AdCommentsBloc>().state;
      if (state is AdCommentsLoaded && state.hasNextPage) {
        context
            .read<AdCommentsBloc>()
            .add(FetchAdComments(adId: widget.adId));
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

  Future<void> _showError(BuildContext context, String message) async {
    final msg = await TranslateErrorHelper.translateErrorKeyAsync(
        context, message);
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
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
              context.read<AdCommentsBloc>().add(
                    DeleteAdComment(
                      adId: widget.adId,
                      commentId: comment.commentId,
                    ),
                  );
              Navigator.pop(dialogContext);
            },
            child: Text(strings.delete,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return BlocListener<AdCommentsBloc, AdCommentsState>(
      listenWhen: (_, current) {
        if (current is AdCommentsLoaded &&
            current.action != CommentAction.none) {return true;}
        return current is AdCommentsError;
      },
      listener: (context, state) {
        if (state is AdCommentsLoaded) {
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
        } else if (state is AdCommentsError) {
          _showError(context, state.message);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
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
                BlocBuilder<AdCommentsBloc, AdCommentsState>(
                  builder: (_, state) {
                    final count =
                        state is AdCommentsLoaded ? state.totalCount : 0;
                    return Text(
                      count > 0
                          ? '${strings.comments} ($count)'
                          : strings.comments,
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
                  child: BlocBuilder<AdCommentsBloc, AdCommentsState>(
                    builder: (_, state) {
                      if (state is AdCommentsLoading) {
                        return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (_, __) => buildCommentShimmer(context),
                        );
                      }

                      if (state is AdCommentsLoaded ||
                          state is AdCommentsLoadingMore) {
                        final comments = state is AdCommentsLoaded
                            ? state.comments
                            : (state as AdCommentsLoadingMore).currentComments;

                        if (comments.isEmpty) {
                          return Center(
                            child: Text(strings.noCommentsYet,
                                style: const TextStyle(color: Colors.grey)),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: comments.length +
                              (state is AdCommentsLoaded && state.hasNextPage
                                  ? 1
                                  : 0),
                          itemBuilder: (_, index) {
                            if (index == comments.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                    child: CircularProgressIndicator()),
                              );
                            }
                            return _buildCommentItem(context, comments[index]);
                          },
                        );
                      }

                      if (state is AdCommentsError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.message,
                                  style: const TextStyle(color: Colors.red)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    context.read<AdCommentsBloc>().add(
                                          FetchAdComments(
                                              adId: widget.adId,
                                              isRefresh: true),
                                        ),
                                child: Text(strings.retry,
                                    style:
                                        TextStyle(color: theme.surface)),
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

  Widget _buildCommentItem(BuildContext context, CommentModel comment) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;
    final bloc = context.read<AdCommentsBloc>();
    final isCurrentUser = comment.userId == bloc.currentUserId;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _editingCommentId == comment.commentId
            ? Colors.blue.withOpacity(0.05)
            : Colors.transparent,
        border: Border(
          bottom:
              BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(
                context, AppRoutes.userProfile,
                arguments: comment.userId),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: comment.profilePictureUrl != null
                  ? NetworkImage(comment.profilePictureUrl!)
                  : null,
              backgroundColor: Colors.grey[300],
              child: comment.profilePictureUrl == null
                  ? Text(
                      (comment.fullName.isNotEmpty
                              ? comment.fullName[0]
                              : 'U')
                          .toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.onSurface),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                  context, AppRoutes.userProfile,
                  arguments: comment.userId),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(comment.fullName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: theme.onSurface)),
                      const SizedBox(width: 8),
                      Text(
                        formatTimeAgo(context, comment.createdAt.toUtc()),
                        style:
                            TextStyle(color: theme.onSurface, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(comment.text,
                      style:
                          TextStyle(fontSize: 14, color: theme.onSurface)),
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
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    const Icon(Icons.edit, size: 18),
                    const SizedBox(width: 8),
                    Text(strings.edit),
                  ]),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    const Icon(Icons.delete, size: 18, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(strings.delete,
                        style: const TextStyle(color: Colors.red)),
                  ]),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _editingCommentId != null
                ? Colors.blue.withOpacity(0.05)
                : theme.surface,
            border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.3))),
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
                      Text(strings.editingComment,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                      InkWell(
                        onTap: _cancelEdit,
                        child: const Icon(Icons.close,
                            size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[300],
                    child:
                        const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      onTapOutside: (_) =>
                          FocusScope.of(context).unfocus(),
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
                  BlocBuilder<AdCommentsBloc, AdCommentsState>(
                    builder: (_, state) {
                      final isAdding = state is AdCommentAdding;
                      return TextButton(
                        onPressed: isAdding
                            ? null
                            : () {
                                if (_commentController.text.trim().isEmpty)
                                  return;
                                if (_editingCommentId != null) {
                                  context.read<AdCommentsBloc>().add(
                                        EditAdComment(
                                          commentId: _editingCommentId!,
                                          text: _commentController.text
                                              .trim(),
                                        ),
                                      );
                                } else {
                                  context.read<AdCommentsBloc>().add(
                                        AddAdComment(
                                          adId: widget.adId,
                                          text: _commentController.text
                                              .trim(),
                                        ),
                                      );
                                  _commentController.clear();
                                }
                              },
                        child: Text(
                          _editingCommentId != null
                              ? strings.update
                              : strings.post,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: theme.onSurface),
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