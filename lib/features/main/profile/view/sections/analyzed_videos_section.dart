import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_type_badge.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';

class AnalyzedVideosSection extends StatelessWidget {
  final List<AnalyzedVideoReport> videos;
  final VoidCallback? onShowAll;
  final Function(AnalyzedVideoReport)? onVideoTap; // only for info area
  final ThemeData theme;
  final S string;

  const AnalyzedVideosSection({
    super.key,
    required this.videos,
    this.onShowAll,
    this.onVideoTap,
    required this.theme,
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: string.analyzedVideosReports,
          onShowAllPressed: onShowAll,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: videos.length > 2 ? 2 : videos.length,
          itemBuilder: (context, index) {
            return _AnalyzedVideoCard(
              video: videos[index],
              theme: theme,
              onVideoTap: () => onVideoTap?.call(videos[index]),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stateful Card with embedded video player
// ─────────────────────────────────────────────────────────────────────────────

class _AnalyzedVideoCard extends StatefulWidget {
  final AnalyzedVideoReport video;
  final ThemeData theme;
  final VoidCallback onVideoTap;

  const _AnalyzedVideoCard({
    required this.video,
    required this.theme,
    required this.onVideoTap,
  });

  @override
  State<_AnalyzedVideoCard> createState() => _AnalyzedVideoCardState();
}

class _AnalyzedVideoCardState extends State<_AnalyzedVideoCard> {
  BetterPlayerController? _betterPlayerController;
  bool _isInitializing = false;
  String? _videoError;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant _AnalyzedVideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.video.analyzedVideoUrl != oldWidget.video.analyzedVideoUrl) {
      _betterPlayerController?.dispose();
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    final videoUrl = widget.video.analyzedVideoUrl;
    if (videoUrl == null || videoUrl.isEmpty) return;

    setState(() {
      _isInitializing = true;
      _videoError = null;
    });

    try {
      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoUrl,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
        ),
      );

      final controller = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: false,
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enablePlayPause: true,
            enableProgressBar: true,
            enableFullscreen: true,
          ),
        ),
        betterPlayerDataSource: dataSource,
      );

      if (mounted) {
        setState(() {
          _betterPlayerController = controller;
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _videoError = 'Failed to load video';
        });
      }
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: widget.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: widget.theme.shadowColor.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video / thumbnail area (no tap callback to parent)
          _buildMediaArea(),
          // Info area triggers the original onVideoTap
          GestureDetector(
            onTap: widget.onVideoTap,
            child: _VideoInfo(video: widget.video, theme: widget.theme),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaArea() {
    final hasAnalyzedVideo = widget.video.analyzedVideoUrl != null &&
        widget.video.analyzedVideoUrl!.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: Stack(
        children: [
          // Background / media player or placeholder
          if (hasAnalyzedVideo)
            _buildVideoPlayer()
          else
            Container(
              height: 170.h,
              width: double.infinity,
              color: widget.theme.colorScheme.surfaceVariant,
              child: Center(
                child: Icon(
                  Icons.videocam_off_outlined,
                  size: 40.sp,
                  color: widget.theme.colorScheme.onSurfaceVariant
                      .withOpacity(0.35),
                ),
              ),
            ),

          // Badges overlay (always shown)
          Positioned(
            top: 10.h,
            left: 10.w,
            child: AnalysisTypeBadge(type: widget.video.type),
          ),
          Positioned(
            top: 10.h,
            right: 10.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: widget.video.isPaid
                    ? Colors.green.withOpacity(0.85)
                    : Colors.orange.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                widget.video.isPaid ? 'Analyzed' : 'Pending',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoError != null) {
      return Container(
        height: 170.h,
        width: double.infinity,
        color: Colors.black12,
        child: Center(
          child: Text(
            _videoError!,
            style: TextStyle(color: Colors.red, fontSize: 12.sp),
          ),
        ),
      );
    }

    if (_isInitializing || _betterPlayerController == null) {
      return Container(
        height: 170.h,
        width: double.infinity,
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 170.h,
      width: double.infinity,
      child: BetterPlayer(controller: _betterPlayerController!),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info row (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class _VideoInfo extends StatelessWidget {
  final AnalyzedVideoReport video;
  final ThemeData theme;

  const _VideoInfo({required this.video, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isSelf = video.playerName == video.analystName;

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${video.type} Analysis',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            _formatDate(video.createdAt),
            style: TextStyle(
              fontSize: 11.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _PersonChip(
                label: 'Player',
                name: video.playerName,
                avatar: video.playerAvatar,
                color: const Color(0xFF1565C0),
                theme: theme,
              ),
              if (!isSelf) ...[
                SizedBox(width: 6.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 13.sp,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
                SizedBox(width: 6.w),
                _PersonChip(
                  label: 'By',
                  name: video.analystName,
                  color: const Color(0xFF6C63FF),
                  theme: theme,
                ),
              ] else ...[
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.teal.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Self-analysis',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _PersonChip extends StatelessWidget {
  final String label;
  final String name;
  final String? avatar;
  final Color color;
  final ThemeData theme;

  const _PersonChip({
    required this.label,
    required this.name,
    this.avatar,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10.r,
            backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
            backgroundColor: color.withOpacity(0.2),
            child: avatar == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(fontSize: 8.sp, color: color),
                  )
                : null,
          ),
          SizedBox(width: 5.w),
          Text(
            '$label: $name',
            style: TextStyle(
              fontSize: 10.sp,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}