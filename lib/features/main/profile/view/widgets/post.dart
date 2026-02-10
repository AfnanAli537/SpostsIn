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

  @override
  void initState() {
    super.initState();
    _commentsCount = widget.post.commentsCount;
    _initializeMedia();
    _loadDeviceLanguage();
  }

  @override
  void didUpdateWidget(covariant PostWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.post.isLikedByCurrentUser !=
            oldWidget.post.isLikedByCurrentUser ||
        widget.post.likesCount != oldWidget.post.likesCount ||
        widget.post.commentsCount != oldWidget.post.commentsCount ||
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
      setState(() {
        _showTranslation = true;
      });
      return;
    }

    setState(() {
      _isTranslating = true;
    });

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
          _translatedDesc = null;
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
          log('🎬 Loading video with better_player_plus: ${widget.post.mediaUrl}');

          BetterPlayerDataSource betterPlayerDataSource =
              BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            widget.post.mediaUrl!,
            cacheConfiguration: BetterPlayerCacheConfiguration(
              useCache: true,
              preCacheSize: 10 * 1024 * 1024,
              maxCacheSize: 50 * 1024 * 1024,
              maxCacheFileSize: 30 * 1024 * 1024,
            ),
            bufferingConfiguration: const BetterPlayerBufferingConfiguration(
              minBufferMs: 2000,
              maxBufferMs: 13000,
              bufferForPlaybackMs: 500,
              bufferForPlaybackAfterRebufferMs: 1000,
            ),
          );

          final BetterPlayerConfiguration betterPlayerConfiguration =
              BetterPlayerConfiguration(
            autoPlay: false,
            looping: false,
            aspectRatio: 16 / 9,
            fit: BoxFit.contain,
            handleLifecycle: true,
            autoDetectFullscreenDeviceOrientation: true,
            controlsConfiguration: const BetterPlayerControlsConfiguration(
              enablePlayPause: true,
              enableMute: true,
              enableFullscreen: true,
              enableProgressBar: true,
              enableSkips: false,
              showControls: true,
              showControlsOnInitialize: true,
              controlBarColor: Colors.black45,
              iconsColor: Colors.white,
              progressBarPlayedColor: Colors.blue,
              progressBarHandleColor: Colors.blueAccent,
              progressBarBackgroundColor: Colors.grey,
              progressBarBufferedColor: Color.fromRGBO(173, 216, 230, 0.5),
              loadingColor: Colors.blue,
            ),
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 50.sp,
                      color: Colors.red[300],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Error loading video',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
          );

          _betterPlayerController = BetterPlayerController(
            betterPlayerConfiguration,
            betterPlayerDataSource: betterPlayerDataSource,
          );

          _betterPlayerController!.addEventsListener((event) {
            if (event.betterPlayerEventType ==
                BetterPlayerEventType.exception) {
              log('❌ Better Player error: ${event.parameters}');
              if (mounted) {
                setState(() {
                  _videoError = 'Failed to load video';
                  _isInitializing = false;
                });
              }
            }
          });

          log('✅ Better Player initialized successfully!');

          if (mounted) {
            setState(() {
              _isInitializing = false;
            });
          }
        } catch (e) {
          log('❌ Video initialization error: $e');
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
    final videoExtensions = [
      '.mp4',
      '.mov',
      '.avi',
      '.mkv',
      '.webm',
      '.flv',
      '.m3u8',
    ];
    final lowerUrl = url.toLowerCase();
    return videoExtensions.any((ext) => lowerUrl.contains(ext)) ||
        lowerUrl.contains('cloudinary.com/video');
  }

  // ✅ Check if post has video
  bool get _hasVideo {
    return widget.post.mediaUrl != null &&
        widget.post.mediaUrl!.isNotEmpty &&
        _checkIfVideo(widget.post.mediaUrl!);
  }

  // ✅ Menu with conditional options
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),

                // ✅ Analyze Video - Only if post has video
                if (_hasVideo)
                  _buildMenuItem(
                    icon: Icons.analytics_outlined,
                    title: 'Analyze Video',
                    onTap: () {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: 'Analyze video feature coming soon',
                        backgroundColor: Colors.blue,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    },
                  ),

                // ✅ Edit - Only for owner - WORKING NOW!
                if (widget.isCurrentUser)
                  _buildMenuItem(
                    icon: Icons.edit_outlined,
                    title: 'Edit',
                    onTap: () async {
                      Navigator.pop(context); // Close bottom sheet
                      
                      // ✅ Navigate using named route with PostModel as argument
                      final result = await Navigator.pushNamed(
                        context,
                        AppRoutes.profilePostsEditScreen,
                        arguments: widget.post, // Pass PostModel directly
                      );
                      
                      // If update was successful
                      if (result == true && mounted) {
                        // The BlocListener in UpdatePostScreen already shows the toast
                        // Just refresh if needed
                      }
                    },
                  ),

                // ✅ Delete - Only for owner
                if (widget.isCurrentUser)
                  _buildMenuItem(
                    icon: Icons.delete_outline,
                    title: 'Delete',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation();
                    },
                  ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper to build menu items
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ?? Colors.black87;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: itemColor, size: 24.sp),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: itemColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Delete confirmation
  void _showDeleteConfirmation() {
    ConfirmationDialog.show(
      context: context,
      title: 'Delete Post',
      message: 'Are you sure you want to delete this post? This action cannot be undone.',
      onConfirm: () {
        // ✅ Trigger delete in BLoC
        context.read<PostsBloc>().add(DeletePost(postId: widget.post.id));
        
        // ✅ Call callback
        widget.onDeleted?.call();
        
        // ✅ Show toast
        Fluttertoast.showToast(
          msg: 'Deleting post...',
          backgroundColor: Colors.orange,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      },
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }

  // ✅ Navigate to author profile
  void _navigateToAuthorProfile() {
    Navigator.pushNamed(
      context,
      AppRoutes.userProfile,
      arguments: widget.post.author.userId,
    );
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
                    backgroundColor: Colors.grey[300],
                    child: widget.post.author.profilePictureUrl == null
                        ? Icon(Icons.person, color: Colors.white, size: 24.sp)
                        : null,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: _navigateToAuthorProfile,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.author.fullName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.onSurface,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          formatTimeAgo(
                            DateTime.parse(
                              widget.post.createdAt.toIso8601String(),
                            ).toUtc(),
                          ),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ✅ Menu always visible
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showOptionsMenu(context),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            Text(
              _showTranslation && _translatedDesc != null
                  ? _translatedDesc!
                  : widget.post.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.onTertiary,
                height: 1.4,
                fontStyle: (_showTranslation && _translatedDesc != null)
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),

            if (_translatedDesc != null || !_showTranslation)
              TextButton(
                onPressed: _isTranslating
                    ? null
                    : () async {
                        if (_showTranslation) {
                          setState(() {
                            _showTranslation = false;
                          });
                        } else {
                          if (_translatedDesc == null) {
                            await _translateDescription();
                          } else {
                            setState(() {
                              _showTranslation = true;
                            });
                          }
                        }
                      },
                child: _isTranslating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _showTranslation ? 'See Original' : 'Translate',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),

            SizedBox(height: 8.h),

            if (widget.post.mediaUrl != null &&
                widget.post.mediaUrl!.isNotEmpty)
              _isVideo ? _buildVideoPlayer() : _buildImageWidget()
            else
              const SizedBox.shrink(),

            SizedBox(height: 16.h),

            Row(
              children: [
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            context.read<PostsBloc>().add(
                                  LikePost(widget.post.id),
                                );
                          },
                          child: Icon(
                            widget.post.isLikedByCurrentUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 30.sp,
                            color: widget.post.isLikedByCurrentUser
                                ? Colors.red
                                : Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 5.w),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: theme.surface,
                              builder: (bottomSheetContext) {
                                return BlocProvider(
                                  create: (_) => LikesBloc(
                                    postRepo: getIt<PostsRepositoryImpl>(),
                                  ),
                                  child: LikesSheet(postId: widget.post.id),
                                );
                              },
                            );
                          },
                          child: Text(
                            widget.post.likesCount.toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 25.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CommentsBottomSheet(
                        postId: widget.post.id,
                        onCommentCountChanged: (newCount) {
                          setState(() {
                            _commentsCount = newCount;
                          });
                        },
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          color: Colors.grey[600],
                          size: 30.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          _commentsCount.toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 25.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoError != null) {
      return Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 50.sp,
              color: Colors.grey[500],
            ),
            SizedBox(height: 8.h),
            Text(
              _videoError!,
              style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
            ),
            SizedBox(height: 8.h),
            TextButton.icon(
              onPressed: () {
                _initializeMedia();
              },
              icon: Icon(Icons.refresh, size: 16.sp),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_isInitializing || _betterPlayerController == null) {
      return Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(controller: _betterPlayerController!),
      ),
    );
  }

  Widget _buildImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        widget.post.mediaUrl!,
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.image_not_supported,
              size: 50.sp,
              color: Colors.grey[500],
            ),
          );
        },
      ),
    );
  }
}