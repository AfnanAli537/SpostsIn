import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/advertisement/model/ad_model.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/ad_comments_sheet.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/ad_likes_sheet.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/web_view_screen.dart';
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart';
import 'package:sports_in/features/main/advertisement/view_model/likes_bloc/likes_bloc.dart';
import 'package:sports_in/features/main/home/view/widgets/full_screen_image.dart';
import 'package:sports_in/generated/l10n.dart';

class AdWidget extends StatefulWidget {
  final AdModel ad;
  final bool isCurrentUser;
  final VoidCallback? onDeleted;

  const AdWidget({
    super.key,
    required this.ad,
    this.isCurrentUser = false,
    this.onDeleted,
  });

  @override
  State<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  BetterPlayerController? _videoController;
  bool _isVideo = false;
  bool _isInitializing = false;
  String? _videoError;
  late bool _isLiked;
  late int _likesCount;
  late int _commentsCount;

  // Whether this ad has a valid action link
  bool get _hasActionLink =>
      widget.ad.actionUrl != null && widget.ad.actionUrl!.isNotEmpty;

  // Label shown on the banner and CTA button
  String get _actionLabel =>
      (widget.ad.actionText != null && widget.ad.actionText!.isNotEmpty)
          ? widget.ad.actionText!
          : 'Learn More';

  @override
  void initState() {
    super.initState();
    _isLiked = widget.ad.isLikedByCurrentUser;
    _likesCount = widget.ad.likesCount;
    _commentsCount = widget.ad.commentsCount;
    _initializeMedia();
  }

  @override
  void didUpdateWidget(covariant AdWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ad.isLikedByCurrentUser != oldWidget.ad.isLikedByCurrentUser) {
      _isLiked = widget.ad.isLikedByCurrentUser;
    }
    if (widget.ad.likesCount != oldWidget.ad.likesCount) {
      _likesCount = widget.ad.likesCount;
    }
    if (widget.ad.mediaUrl != oldWidget.ad.mediaUrl) {
      _videoController?.dispose();
      _initializeMedia();
    }
  }

  // ─── Media ─────────────────────────────────────────────────────────────────

  Future<void> _initializeMedia() async {
    final url = widget.ad.mediaUrl;
    if (url == null || url.isEmpty) return;

    _isVideo = _checkIfVideo(url);
    if (_isVideo) {
      setState(() {
        _isInitializing = true;
        _videoError = null;
      });
      try {
        final source = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          url,
          cacheConfiguration:
              const BetterPlayerCacheConfiguration(useCache: true),
        );
        _videoController = BetterPlayerController(
          const BetterPlayerConfiguration(
            autoPlay: false,
            aspectRatio: 16 / 9,
            fit: BoxFit.contain,
          ),
          betterPlayerDataSource: source,
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

  bool _checkIfVideo(String url) {
    const videoExts = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.m3u8'];
    return videoExts.any((ext) => url.toLowerCase().contains(ext)) ||
        url.toLowerCase().contains('cloudinary.com/video');
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  void _handleLike() {
    setState(() {
      _isLiked ? _likesCount-- : _likesCount++;
      _isLiked = !_isLiked;
    });
    context.read<AdsBloc>().add(LikeAd(widget.ad.id));
  }

  /// Opens the action URL inside the app (WebView) and logs the click.
  void _openActionUrl() {
    if (!_hasActionLink) return;

    // Log the click
    context.read<AdsBloc>().add(LogAdClick(widget.ad.id));

    // Open inside the app — no browser picker shown to the user
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewScreen(
          url: widget.ad.actionUrl!,
          title: _actionLabel,
        ),
      ),
    );
  }

  void _navigateToAuthorProfile() {
    if (widget.ad.author == null) return;
    Navigator.pushNamed(
      context,
      AppRoutes.userProfile,
      arguments: widget.ad.author!.userId,
    );
  }

  void _openFullScreenImage() {
    final url = widget.ad.mediaUrl;
    if (url == null || url.isEmpty || _isVideo) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageViewer(imageUrl: url),
      ),
    );
  }

  void _showDeleteConfirmation() {
    final strings = S.of(context);
    ConfirmationDialog.show(
      context: context,
      title: strings.delete,
      message: 'Are you sure you want to delete this advertisement?',
      onConfirm: () {
        context.read<AdsBloc>().add(DeleteAd(adId: widget.ad.id));
        widget.onDeleted?.call();
      },
      confirmText: strings.delete,
      isDestructive: true,
    );
  }

  void _showToggleConfirmation() {
    final isActive = widget.ad.isActive;
    ConfirmationDialog.show(
      context: context,
      title: isActive ? 'Deactivate Ad' : 'Activate Ad',
      message: isActive
          ? 'This ad will no longer appear in the feed.'
          : 'This ad will appear in the feed again.',
      onConfirm: () =>
          context.read<AdsBloc>().add(ToggleAdStatus(adId: widget.ad.id)),
      confirmText: isActive ? 'Deactivate' : 'Activate',
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final author = widget.ad.author;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _navigateToAuthorProfile,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundImage: author?.profilePictureUrl != null
                            ? NetworkImage(author!.profilePictureUrl!)
                            : null,
                        child: author?.profilePictureUrl == null
                            ? Icon(Icons.person, size: 24.sp)
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            author?.fullName ?? 'Sponsor',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: theme.onSurface,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.campaign_outlined,
                                  size: 12.sp, color: Colors.grey[500]),
                              SizedBox(width: 4.w),
                              Text(
                                'Advertisement',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Three-dot menu — only for owner
                if (widget.isCurrentUser)
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: theme.onSurface),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.createAdScreen,
                          arguments: widget.ad,
                        );
                      } else if (value == 'toggle') {
                        _showToggleConfirmation();
                      } else if (value == 'delete') {
                        _showDeleteConfirmation();
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [
                          Icon(Icons.edit_outlined, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(strings.edit),
                        ]),
                      ),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Row(children: [
                          Icon(
                            widget.ad.isActive
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(widget.ad.isActive ? 'Deactivate' : 'Activate'),
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
                  ),
              ],
            ),

            SizedBox(height: 12.h),

            // ── Title ─────────────────────────────────────────────────────
            Text(
              widget.ad.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.onSurface,
              ),
            ),
            SizedBox(height: 6.h),

            // ── Description ───────────────────────────────────────────────
            Text(
              widget.ad.description,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.4,
                color: theme.onSurface,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // ── Media with action banner ───────────────────────────────────
            if (widget.ad.mediaUrl != null && widget.ad.mediaUrl!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    // Tapping the media itself → full screen image (images only)
                    GestureDetector(
                      onTap: _openFullScreenImage,
                      child: _isVideo
                          ? _buildVideoPlayer()
                          : _buildImageWidget(),
                    ),

                    // ── Bottom banner ─────────────────────────────────────
                    // If there is an action link:
                    //   • shows actionText (or "Learn More")
                    //   • tapping opens the URL inside the app (WebView)
                    // If there is no action link:
                    //   • shows plain "Advertisement" label (not tappable)
                    GestureDetector(
                      onTap: _hasActionLink ? _openActionUrl : null,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          // Slightly darker when tappable so it looks clickable
                          color: _hasActionLink
                              ? Colors.black.withOpacity(0.6)
                              : Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.r),
                            bottomRight: Radius.circular(8.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _hasActionLink
                                    ? _actionLabel   // ← actionText from the ad
                                    : 'Advertisement',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (_hasActionLink) ...[
                              SizedBox(width: 8.w),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 13.sp),
                            ] else
                              Icon(Icons.chevron_right,
                                  color: Colors.white, size: 18.sp),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 12.h),

            // ── CTA button (shown when no media OR as a standalone button) ─
            // Only show the standalone CTA button when there is no media,
            // because when there IS media the banner already acts as the CTA.
            if (_hasActionLink &&
                (widget.ad.mediaUrl == null || widget.ad.mediaUrl!.isEmpty))
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openActionUrl,
                    icon: Icon(Icons.open_in_new, size: 16.sp),
                    label: Text(_actionLabel),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.primary),
                      foregroundColor: theme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ),

            // ── Like & Comment row ─────────────────────────────────────────
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
                        create: (_) =>
                            AdLikesBloc(adsRepo: getIt<AdsRepositoryImpl>()),
                        child: AdLikesSheet(adId: widget.ad.id),
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
                      builder: (_) => AdCommentsSheet(
                        adId: widget.ad.id,
                        onCommentCountChanged: (count) =>
                            setState(() => _commentsCount = count),
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

  // ─── Helpers ───────────────────────────────────────────────────────────────

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
        child: Row(
          children: [
            Icon(icon, size: 28.sp, color: color ?? Colors.grey[600]),
            SizedBox(width: 6.w),
            Text(label,
                style: TextStyle(fontSize: 20.sp, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoError != null) {
      return Center(child: Text(_videoError!));
    }
    if (_isInitializing || _videoController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(controller: _videoController!),
      ),
    );
  }

  Widget _buildImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        widget.ad.mediaUrl!,
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
        frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.grey[300],
            height: 200.h,
            child: Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}