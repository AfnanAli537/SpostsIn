import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/helper/time_formate.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
import 'package:sports_in/features/main/home/view/presentation/comments.dart';
import 'package:sports_in/features/main/home/view/presentation/likes.dart';
import 'package:sports_in/features/main/home/view/widgets/full_screen_image.dart';
import 'package:sports_in/features/main/home/view_model/likes_bloc/likes_bloc.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/main/video_analysis/data/enums/analysis_type.dart';
import 'package:sports_in/features/main/video_analysis/view/presentation/create_analysis_form_screen.dart';
import 'package:translator/translator.dart';
import 'package:sports_in/generated/l10n.dart';

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
  String? _detectedLanguage;
  String? _targetLanguage;
  late bool _isLiked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _commentsCount = widget.post.commentsCount;
    _isLiked = widget.post.isLikedByCurrentUser;
    _likesCount = widget.post.likesCount;
    _initializeMedia();
    _detectLanguage();
  }

  @override
  void didUpdateWidget(covariant PostWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post.isLikedByCurrentUser !=
        oldWidget.post.isLikedByCurrentUser) {
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

  Future<void> _detectLanguage() async {
    try {
      final detection = await _translator.translate(
        widget.post.description,
        from: 'auto',
        to: 'en',
      );
      if (mounted) {
        setState(() {
          _detectedLanguage = detection.sourceLanguage.code;
          _targetLanguage = _detectedLanguage == 'ar' ? 'en' : 'ar';
        });
      }
    } catch (e) {
      log('Language detection error: $e');
      if (mounted) {
        setState(() {
          _detectedLanguage =
              _isArabic(widget.post.description) ? 'ar' : 'en';
          _targetLanguage = _detectedLanguage == 'ar' ? 'en' : 'ar';
        });
      }
    }
  }

  bool _isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
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
        from: _detectedLanguage ?? 'auto',
        to: _targetLanguage!,
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
        Fluttertoast.showToast(msg: S.of(context).failedToTranslate);
      }
    }
  }

  void _toggleTranslation() {
    if (_showTranslation) {
      setState(() => _showTranslation = false);
    } else {
      _translateDescription();
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
          final betterPlayerDataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            widget.post.mediaUrl!,
            cacheConfiguration:
                const BetterPlayerCacheConfiguration(useCache: true),
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
              _videoError = S.of(context).failedToLoadVideo;
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
      '.m3u8'
    ];
    return videoExtensions
            .any((ext) => url.toLowerCase().contains(ext)) ||
        url.toLowerCase().contains('cloudinary.com/video');
  }

  bool get _hasVideo =>
      widget.post.mediaUrl != null &&
      widget.post.mediaUrl!.isNotEmpty &&
      _checkIfVideo(widget.post.mediaUrl!);

  void _showDeleteConfirmation() {
    final strings = S.of(context);
    ConfirmationDialog.show(
      context: context,
      title: strings.deletePost,
      message: strings.deletePostConfirmation,
      onConfirm: () {
        context.read<PostsBloc>().add(DeletePost(postId: widget.post.id));
        widget.onDeleted?.call();
      },
      confirmText: strings.delete,
      isDestructive: true,
    );
  }

  void _showToggleConfirmation({required bool isArchiving}) {
    final strings = S.of(context);
    ConfirmationDialog.show(
      context: context,
      title: isArchiving ? strings.archivePost : strings.restorePost,
      message: isArchiving
          ? strings.archivePostConfirmation
          : strings.restorePostConfirmation,
      onConfirm: () {
        context
            .read<PostsBloc>()
            .add(TogglePostVisibility(postId: widget.post.id));
        widget.onDeleted?.call();
      },
      confirmText: isArchiving ? strings.archive : strings.restore,
    );
  }

  void _navigateToAuthorProfile() {
    Navigator.pushNamed(
      context,
      AppRoutes.userProfile,
      arguments: widget.post.author.userId,
    );
  }

  void _handleLike() {
    setState(() {
      _isLiked ? _likesCount-- : _likesCount++;
      _isLiked = !_isLiked;
    });
    context.read<PostsBloc>().add(LikePost(widget.post.id));
  }

  void _openFullScreenMedia() {
    if (widget.post.mediaUrl == null || widget.post.mediaUrl!.isEmpty) return;
    if (!_isVideo) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FullScreenImageViewer(imageUrl: widget.post.mediaUrl!),
        ),
      );
    }
  }

  // ─── Analyze video from post ─────────────────────────────────────────────

  Future<void> _analyzePostVideo() async {
    final videoUrl = widget.post.mediaUrl;
    if (videoUrl == null || videoUrl.isEmpty) return;

    // final sharedPref = getIt<SharedPref>();
    // final userId = sharedPref.getUserId();
    // if (userId == null) return;
    final userId = widget.post.author.userId;

    // Show type selection bottom sheet — user picks Goalkeeper/Passing/Dribbling/Match.
    // Then navigate straight to the form with the video URL pre-filled.
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AnalysisTypePickerSheet(
        videoUrl: videoUrl,
        targetUserId: userId,
      ),
    );
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _navigateToAuthorProfile,
                  child: Row(children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage:
                          widget.post.author.profilePictureUrl != null
                              ? NetworkImage(
                                  widget.post.author.profilePictureUrl!)
                              : null,
                      child:
                          widget.post.author.profilePictureUrl == null
                              ? Icon(Icons.person, size: 24.sp)
                              : null,
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.author.fullName,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatTimeAgo(
                              context, widget.post.createdAt.toUtc()),
                          style: TextStyle(
                              fontSize: 12.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ]),
                ),

                // ── Popup menu ─────────────────────────────────────────────
                Visibility(
                  visible: widget.isCurrentUser || _hasVideo,
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: theme.onSurface),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                    onSelected: (value) async {
                      switch (value) {
                        case 'analyze':
                          await _analyzePostVideo();
                          break;
                        case 'edit':
                          Navigator.pushNamed(
                            context,
                            AppRoutes.profilePostsEditScreen,
                            arguments: widget.post,
                          );
                          break;
                        case 'delete':
                          _showDeleteConfirmation();
                          break;
                        case 'archive':
                          _showToggleConfirmation(isArchiving: true);
                          break;
                        case 'restore':
                          _showToggleConfirmation(isArchiving: false);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (_hasVideo)
                        PopupMenuItem(
                          value: 'analyze',
                          child: Row(children: [
                            Icon(Icons.analytics_outlined, size: 20.sp),
                            SizedBox(width: 8.w),
                            Text(strings.analyzeVideo),
                          ]),
                        ),
                      if (widget.isCurrentUser) ...[
                        if (widget.post.isActive)
                          PopupMenuItem(
                            value: 'archive',
                            child: Row(children: [
                              Icon(Icons.archive_outlined, size: 20.sp),
                              SizedBox(width: 8.w),
                              Text(strings.archive),
                            ]),
                          )
                        else
                          PopupMenuItem(
                            value: 'restore',
                            child: Row(children: [
                              Icon(Icons.restore_outlined, size: 20.sp),
                              SizedBox(width: 8.w),
                              Text(strings.restore),
                            ]),
                          ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(children: [
                            Icon(Icons.edit_outlined, size: 20.sp),
                            SizedBox(width: 8.w),
                            Text(strings.edit),
                          ]),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            Icon(Icons.delete_outline,
                                size: 20.sp, color: Colors.red[700]),
                            SizedBox(width: 8.w),
                            Text(strings.delete,
                                style: TextStyle(color: Colors.red[700])),
                          ]),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // ── Body ─────────────────────────────────────────────────────────
            SizedBox(height: 16.h),
            Text(
              _showTranslation && _translatedDesc != null
                  ? _translatedDesc!
                  : widget.post.description,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.4,
                fontStyle:
                    _showTranslation && _translatedDesc != null
                        ? FontStyle.italic
                        : FontStyle.normal,
                color: theme.onSurface,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            TextButton(
              onPressed: _isTranslating ? null : _toggleTranslation,
              child: _isTranslating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child:
                          CircularProgressIndicator(strokeWidth: 2))
                  : Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                        _showTranslation
                            ? Icons.translate_outlined
                            : Icons.translate,
                        size: 14.sp,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _showTranslation
                            ? strings.seeOriginal
                            : strings.translate,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ]),
            ),

            // ── Media ─────────────────────────────────────────────────────────
            if (widget.post.mediaUrl != null &&
                widget.post.mediaUrl!.isNotEmpty)
              GestureDetector(
                onTap: _openFullScreenMedia,
                child: Stack(alignment: Alignment.center, children: [
                  _isVideo ? _buildVideoPlayer() : _buildImageWidget(),
                  Visibility(
                    visible: !_isVideo,
                    child: Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: Icon(Icons.fullscreen,
                          color: ColorManager.borderColor, size: 35.sp),
                    ),
                  ),
                ]),
              ),

            // ── Actions ───────────────────────────────────────────────────────
            SizedBox(height: 16.h),
            Row(children: [
              _buildActionButton(
                icon: _isLiked
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: _likesCount.toString(),
                color: _isLiked ? Colors.red : Colors.grey[600],
                onTap: _handleLike,
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => BlocProvider(
                      create: (_) => LikesBloc(
                          postRepo: getIt<PostsRepositoryImpl>()),
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
                      onCommentCountChanged: (newCount) =>
                          setState(() => _commentsCount = newCount),
                    ),
                  );
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Row(children: [
          Icon(icon, size: 28.sp, color: color ?? Colors.grey[600]),
          SizedBox(width: 6.w),
          Text(label,
              style:
                  TextStyle(fontSize: 20.sp, color: Colors.grey[600])),
        ]),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoError != null) return Center(child: Text(_videoError!));
    if (_isInitializing || _betterPlayerController == null) {
      return const Center(child: CircularProgressIndicator());
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
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            height: 200.h,
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
      ),
    );
  }
}

// ─── Analysis type picker bottom sheet (from post) ────────────────────────────

class _AnalysisTypePickerSheet extends StatelessWidget {
  final String videoUrl;
  final String targetUserId;

  const _AnalysisTypePickerSheet({
    required this.videoUrl,
    required this.targetUserId,
  });

  static const _types = [
    (type: AnalysisType.goalkeeper, icon: Icons.sports_handball_outlined,
     color: Color(0xFF4FC3F7)),
    (type: AnalysisType.passing, icon: Icons.compare_arrows_rounded,
     color: Color(0xFF81C784)),
    (type: AnalysisType.dribbling, icon: Icons.sports_soccer,
     color: Color(0xFFFFB74D)),
    (type: AnalysisType.match, icon: Icons.stadium_outlined,
     color: Color(0xFFBA68C8)),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: theme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          Row(children: [
            Icon(Icons.analytics_outlined, color: theme.primary, size: 22.sp),
            SizedBox(width: 10.w),
            Text(
              'Select Analysis Type',
              style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.onSurface),
            ),
          ]),
          SizedBox(height: 6.h),
          Text(
            'The post video will be used as the source.',
            style: TextStyle(
                fontSize: 12.sp,
                color: theme.onSurface.withOpacity(0.5)),
          ),
          SizedBox(height: 20.h),
          ..._types.map((d) => _TypeTile(
                type: d.type,
                icon: d.icon,
                color: d.color,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateAnalysisFormScreen(
                        targetUserId: targetUserId,
                        analysisType: d.type,
                        prefilledVideoUrl: videoUrl,
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}

class _TypeTile extends StatelessWidget {
  final AnalysisType type;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TypeTile({
    required this.type,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 20.sp, color: color),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type.label,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.onSurface)),
                SizedBox(height: 2.h),
                Text(type.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: theme.onSurface.withOpacity(0.5))),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 14.sp, color: theme.onSurface.withOpacity(0.35)),
        ]),
      ),
    );
  }
}