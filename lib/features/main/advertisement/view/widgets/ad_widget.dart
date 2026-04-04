import 'dart:async';
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
import 'package:sports_in/features/main/advertisement/view/presentation/ad_dashboard_screen.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/ad_likes_sheet.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/ad_payment_screen.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/web_view_screen.dart';
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart';
import 'package:sports_in/features/main/advertisement/view_model/likes_bloc/likes_bloc.dart';
import 'package:sports_in/features/main/home/view/widgets/full_screen_image.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Minimum visible fraction (50%) before we start counting view time.
const double _kVisibleThreshold = 0.5;

/// Seconds of view time required to count the ad as "watched".
const double _kWatchedThreshold = 3.0;

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
  // ── Media ───────────────────────────────────────────────────────────────────
  BetterPlayerController? _videoController;
  bool _isVideo = false;
  bool _isInitializing = false;
  String? _videoError;

  // ── Engagement ──────────────────────────────────────────────────────────────
  late bool _isLiked;
  late int _likesCount;
  late int _commentsCount;

  // ── Progress tracking (non-owner only) ─────────────────────────────────────
  Timer? _viewTimer;
  double _watchedSeconds = 0;
  bool _isWatched = false;
  bool _isVisible = false;

  double _zoomScale = 1.0;

  static const Duration _reportInterval = Duration(seconds: 5);
  DateTime? _lastReported;

  bool get _hasActionLink =>
      widget.ad.actionUrl != null && widget.ad.actionUrl!.isNotEmpty;

  String get _actionLabel =>
      (widget.ad.actionText != null && widget.ad.actionText!.isNotEmpty)
          ? widget.ad.actionText!
          : S.of(context).learnMore;

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

  // ─── Media init ────────────────────────────────────────────────────────────

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
            _videoError = S.of(context).failedToLoadVideo;
          });
        }
      }
    }
  }

  bool _checkIfVideo(String url) {
    const exts = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.m3u8'];
    return exts.any((e) => url.toLowerCase().contains(e)) ||
        url.toLowerCase().contains('cloudinary.com/video');
  }

  // ─── Progress tracking ─────────────────────────────────────────────────────

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.isCurrentUser) return;

    final nowVisible = info.visibleFraction >= _kVisibleThreshold;

    if (nowVisible && !_isVisible) {
      _isVisible = true;
      _viewTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _watchedSeconds += 1;
        if (!_isWatched && _watchedSeconds >= _kWatchedThreshold) {
          _isWatched = true;
        }
        _maybeReport();
      });
    } else if (!nowVisible && _isVisible) {
      _isVisible = false;
      _viewTimer?.cancel();
      _viewTimer = null;
      _sendProgress();
    }
  }

  void _maybeReport() {
    final now = DateTime.now();
    if (_lastReported == null ||
        now.difference(_lastReported!) >= _reportInterval) {
      _lastReported = now;
      _sendProgress();
    }
  }

  void _sendProgress() {
    if (!mounted) return;
    context.read<AdsBloc>().add(SendAdProgress(
          adId: widget.ad.id,
          watchedTime: _watchedSeconds,
          isWatched: _isWatched,
          zoomScale: _zoomScale,
        ));
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  void _handleLike() {
    setState(() {
      _isLiked ? _likesCount-- : _likesCount++;
      _isLiked = !_isLiked;
    });
    context.read<AdsBloc>().add(LikeAd(widget.ad.id));
  }

  void _openActionUrl() {
    if (!_hasActionLink) return;
    context.read<AdsBloc>().add(LogAdClick(widget.ad.id));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WebViewScreen(url: widget.ad.actionUrl!, title: _actionLabel),
      ),
    );
  }

  void _navigateToAuthorProfile() {
    if (widget.ad.author == null) return;
    Navigator.pushNamed(context, AppRoutes.userProfile,
        arguments: widget.ad.author!.userId);
  }

  void _openFullScreenImage() {
    final url = widget.ad.mediaUrl;
    if (url == null || url.isEmpty || _isVideo) return;

    setState(() => _zoomScale = 2.0);
    _sendProgress();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => FullScreenImageViewer(imageUrl: url)),
    ).then((_) {
      setState(() => _zoomScale = 1.0);
    });
  }

  void _openDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdDashboardScreen(
          adId: widget.ad.id,
          adTitle: widget.ad.title,
        ),
      ),
    );
  }

  // ── Navigate to AdPaymentScreen exactly as it is pushed elsewhere ──────────
  void _navigateToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdPaymentScreen(
          adId: widget.ad.id,
          price: widget.ad.price,
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    final strings = S.of(context);
    ConfirmationDialog.show(
      context: context,
      title: strings.delete,
      message: strings.deleteAdConfirmation,
      onConfirm: () {
        context.read<AdsBloc>().add(DeleteAd(adId: widget.ad.id));
        widget.onDeleted?.call();
      },
      confirmText: strings.delete,
      isDestructive: true,
    );
  }

  void _showToggleConfirmation() {
    final strings = S.of(context);
    final isActive = widget.ad.isActive;
    ConfirmationDialog.show(
      context: context,
      title: isActive ? strings.deactivateAd : strings.activateAd,
      message: isActive
          ? strings.deactivateAdMessage
          : strings.activateAdMessage,
      onConfirm: () =>
          context.read<AdsBloc>().add(ToggleAdStatus(adId: widget.ad.id)),
      confirmText: isActive ? strings.deactivate : strings.activate,
    );
  }

  @override
  void dispose() {
    _viewTimer?.cancel();
    if (!widget.isCurrentUser && _watchedSeconds > 0) {
      getIt<AdsRepositoryImpl>().sendAdProgress(
        adId: widget.ad.id,
        watchedTime: _watchedSeconds,
        isWatched: _isWatched,
        zoomScale: _zoomScale,
      );
    }
    _videoController?.dispose();
    super.dispose();
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final author = widget.ad.author;

    Widget card = Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
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
                            author?.fullName ?? strings.sponsor,
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
                                strings.advertisement,
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Three-dot menu — owner only
                if (widget.isCurrentUser)
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: theme.onSurface),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                    onSelected: (value) {
                      switch (value) {
                        case 'dashboard':
                          _openDashboard();
                          break;
                        case 'edit':
                          Navigator.pushNamed(context, AppRoutes.createAdScreen,
                              arguments: widget.ad);
                          break;
                        case 'toggle':
                          _showToggleConfirmation();
                          break;
                        case 'pay':
                          _navigateToPayment(); // ← wired up
                          break;
                        case 'delete':
                          _showDeleteConfirmation();
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'dashboard',
                        child: Row(children: [
                          Icon(Icons.analytics_outlined,
                              size: 20.sp, color: theme.primary),
                          SizedBox(width: 8.w),
                          Text(strings.dashboard,
                              style: TextStyle(color: theme.primary)),
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
                      if (widget.ad.isPaid)
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
                            Text(widget.ad.isActive
                                ? strings.deactivate
                                : strings.activate),
                          ]),
                        )
                      else
                        PopupMenuItem(
                          value: 'pay',
                          child: Row(children: [
                            Icon(Icons.payment, size: 20.sp),
                            SizedBox(width: 8.w),
                            Text(strings.pay),
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

            // ── Title ───────────────────────────────────────────────────
            Text(widget.ad.title,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.onSurface)),
            SizedBox(height: 6.h),

            // ── Description ─────────────────────────────────────────────
            Text(
              widget.ad.description,
              style: TextStyle(
                  fontSize: 14.sp, height: 1.4, color: theme.onSurface),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // ── Unpaid banner (owner only) ───────────────────────────────
            if (widget.isCurrentUser && !widget.ad.isPaid)
              _buildUnpaidBanner(theme, strings),

            // ── Media ───────────────────────────────────────────────────
            if (widget.ad.mediaUrl != null && widget.ad.mediaUrl!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    GestureDetector(
                      onTap: _openFullScreenImage,
                      child: _isVideo
                          ? _buildVideoPlayer()
                          : _buildImageWidget(),
                    ),
                    GestureDetector(
                      onTap: _hasActionLink ? _openActionUrl : null,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
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
                                    ? _actionLabel
                                    : strings.advertisement,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600),
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

            // ── Standalone CTA (no media) ────────────────────────────────
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
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                ),
              ),

            // ── Like & Comment ───────────────────────────────────────────
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
                        create: (_) => AdLikesBloc(
                            adsRepo: getIt<AdsRepositoryImpl>()),
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

    if (!widget.isCurrentUser) {
      card = VisibilityDetector(
        key: Key('ad_visibility_${widget.ad.id}'),
        onVisibilityChanged: _onVisibilityChanged,
        child: card,
      );
    }

    return card;
  }

  // ─── Unpaid banner ─────────────────────────────────────────────────────────

  Widget _buildUnpaidBanner(ColorScheme theme, S strings) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFFFB300), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: const BoxDecoration(
                  color: Color(0xFFFFB300), shape: BoxShape.circle),
              child: Icon(Icons.attach_money_rounded,
                  color: Colors.white, size: 16.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.adSavedAsDraft,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7B4F00)),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    strings.completePaymentToActivate,
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF9E6900),
                        height: 1.3),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            OutlinedButton(
              onPressed: _navigateToPayment, // ← wired up
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFFB300),
                side: const BorderSide(color: Color(0xFFFFB300)),
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text(strings.payNow,
                  style: TextStyle(
                      fontSize: 12.sp, fontWeight: FontWeight.w600)),
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
    if (_videoError != null) return Center(child: Text(_videoError!));
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