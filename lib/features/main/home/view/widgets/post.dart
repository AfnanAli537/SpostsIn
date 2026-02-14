import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/time_formate.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
import 'package:sports_in/features/main/home/view/presentation/comments.dart';
import 'package:sports_in/features/main/home/view/presentation/likes.dart';
import 'package:sports_in/features/main/home/view_model/likes_bloc/likes_bloc.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:translator/translator.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  final bool isCurrentUser;
  final VoidCallback? onDeleted;

  const PostWidget({
    super.key,
    required this.post,
    this.isCurrentUser = false,
    this.onDeleted,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  BetterPlayerController? _betterPlayerController;
  bool _isVideo = false;
  bool _isInitializing = false;
  String? _videoError;
  String? _translatedDesc;
  bool _isTranslating = false;
  bool _showTranslation = false;
  final GoogleTranslator _translator = GoogleTranslator();
  late int _commentsCount;
  late String _deviceLanguage;

  late bool _isLiked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _commentsCount = widget.post.commentsCount;
    _isLiked = widget.post.isLikedByCurrentUser;
    _likesCount = widget.post.likesCount;
    _initializeMedia();
    _loadDeviceLanguage();
  }

  @override
  void didUpdateWidget(covariant PostWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post.isLikedByCurrentUser != oldWidget.post.isLikedByCurrentUser) {
      _isLiked = widget.post.isLikedByCurrentUser;
    }
    if (widget.post.likesCount != oldWidget.post.likesCount) {
      _likesCount = widget.post.likesCount;
    }
    if (widget.post.commentsCount != oldWidget.post.commentsCount ||
        widget.post.description != oldWidget.post.description) {
      setState(() {});
    }
    if (widget.post.mediaUrl != oldWidget.post.mediaUrl) {
      _betterPlayerController?.dispose();
      _initializeMedia();
    }
  }

  Future<void> _loadDeviceLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceLanguage = prefs.getString('language_code') ?? 'ar';
  }

  Future<void> _translateDescription() async {
    if (_translatedDesc != null) {
      setState(() => _showTranslation = true);
      return;
    }
    setState(() => _isTranslating = true);
    try {
      final translation = await _translator.translate(
        widget.post.description,
        to: _deviceLanguage,
      );
      if (mounted) {
        setState(() {
          _translatedDesc = translation.text;
          _isTranslating = false;
          _showTranslation = true;
        });
      }
    } catch (e) {
      log('Translation error: $e');
      if (mounted) {
        setState(() {
          _isTranslating = false;
          _showTranslation = false;
        });
      }
    }
  }

  Future<void> _initializeMedia() async {
    if (widget.post.mediaUrl != null && widget.post.mediaUrl!.isNotEmpty) {
      _isVideo = _checkIfVideo(widget.post.mediaUrl!);
      if (_isVideo) {
        setState(() {
          _isInitializing = true;
          _videoError = null;
        });
        try {
          BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            widget.post.mediaUrl!,
            cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
          );

          _betterPlayerController = BetterPlayerController(
            const BetterPlayerConfiguration(
              autoPlay: false,
              aspectRatio: 16 / 9,
              fit: BoxFit.contain,
            ),
            betterPlayerDataSource: betterPlayerDataSource,
          );

          if (mounted) setState(() => _isInitializing = false);
        } catch (e) {
          if (mounted) {
            setState(() {
              _isInitializing = false;
              _videoError = 'Failed to load video';
            });
          }
        }
      }
    }
  }

  bool _checkIfVideo(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.m3u8'];
    return videoExtensions.any((ext) => url.toLowerCase().contains(ext)) ||
        url.toLowerCase().contains('cloudinary.com/video');
  }

  bool get _hasVideo => widget.post.mediaUrl != null && 
                        widget.post.mediaUrl!.isNotEmpty && 
                        _checkIfVideo(widget.post.mediaUrl!);

  void _showDeleteConfirmation() {
    ConfirmationDialog.show(
      context: context,
      title: 'Delete Post',
      message: 'Are you sure you want to delete this post?',
      onConfirm: () {
        context.read<PostsBloc>().add(DeletePost(postId: widget.post.id));
        widget.onDeleted?.call();
      },
      confirmText: 'Delete',
      isDestructive: true,
    );
  }

  void _navigateToAuthorProfile() {
    Navigator.pushNamed(context, AppRoutes.userProfile, arguments: widget.post.author.userId);
  }

  void _handleLike() {
    setState(() {
      _isLiked ? _likesCount-- : _likesCount++;
      _isLiked = !_isLiked;
    });
    context.read<PostsBloc>().add(LikePost(widget.post.id));
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _navigateToAuthorProfile,
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundImage: widget.post.author.profilePictureUrl != null
                        ? NetworkImage(widget.post.author.profilePictureUrl!)
                        : null,
                    child: widget.post.author.profilePictureUrl == null
                        ? Icon(Icons.person, size: 24.sp)
                        : null,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.post.author.fullName,
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      Text(formatTimeAgo(widget.post.createdAt.toUtc()),
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                    ],
                  ),
                ),
                // NEW POPUP MENU BUTTON
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: theme.onSurface),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  onSelected: (value) async {
                    if (value == 'analyze') {
                      Fluttertoast.showToast(msg: 'Analyze video feature coming soon');
                    } else if (value == 'edit') {
                      Navigator.pushNamed(context, AppRoutes.profilePostsEditScreen, arguments: widget.post);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation();
                    }
                  },
                  itemBuilder: (context) => [
                    if (_hasVideo)
                      PopupMenuItem(
                        value: 'analyze',
                        child: Row(children: [
                          Icon(Icons.analytics_outlined, size: 20.sp),
                          SizedBox(width: 8.w),
                          const Text('Analyze Video')
                        ]),
                      ),
                    if (widget.isCurrentUser) ...[
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [
                          Icon(Icons.edit_outlined, size: 20.sp),
                          SizedBox(width: 8.w),
                          const Text('Edit')
                        ]),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [
                          Icon(Icons.delete_outline, size: 20.sp, color: Colors.red[700]),
                          SizedBox(width: 8.w),
                          Text('Delete', style: TextStyle(color: Colors.red[700]))
                        ]),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              _showTranslation && _translatedDesc != null ? _translatedDesc! : widget.post.description,
              style: TextStyle(fontSize: 14.sp, height: 1.4),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            TextButton(
              onPressed: _isTranslating ? null : () => _showTranslation ? setState(() => _showTranslation = false) : _translateDescription(),
              child: _isTranslating 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_showTranslation ? 'See Original' : 'Translate', style: const TextStyle(color: Colors.blue)),
            ),
            if (widget.post.mediaUrl != null && widget.post.mediaUrl!.isNotEmpty)
              _isVideo ? _buildVideoPlayer() : _buildImageWidget(),
            SizedBox(height: 16.h),
            Row(
              children: [
                _buildActionButton(
                  icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                  label: _likesCount.toString(),
                  color: _isLiked ? Colors.red : Colors.grey[600],
                  onTap: _handleLike,
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => BlocProvider(
                        create: (_) => LikesBloc(postRepo: getIt<PostsRepositoryImpl>()),
                        child: LikesSheet(postId: widget.post.id),
                      ),
                    );
                  },
                ),
                SizedBox(width: 16.w),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: _commentsCount.toString(),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CommentsBottomSheet(
                        postId: widget.post.id,
                        onCommentCountChanged: (newCount) => setState(() => _commentsCount = newCount),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, Color? color, required VoidCallback onTap, VoidCallback? onLongPress}) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Row(children: [
          Icon(icon, size: 28.sp, color: color ?? Colors.grey[600]),
          SizedBox(width: 6.w),
          Text(label, style: TextStyle(fontSize: 20.sp, color: Colors.grey[600])),
        ]),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoError != null) return Center(child: Text(_videoError!));
    if (_isInitializing || _betterPlayerController == null) return const Center(child: CircularProgressIndicator());
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: AspectRatio(aspectRatio: 16 / 9, child: BetterPlayer(controller: _betterPlayerController!)),
    );
  }

  Widget _buildImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(widget.post.mediaUrl!, width: double.infinity, height: 200.h, fit: BoxFit.cover),
    );
  }
}