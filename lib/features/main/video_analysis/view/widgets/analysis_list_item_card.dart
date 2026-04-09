import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_type_badge.dart';
import 'package:sports_in/generated/l10n.dart';

class AnalysisListItemCard extends StatefulWidget {
  final AnalysisListItemModel item;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const AnalysisListItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onDelete,
  });

  @override
  State<AnalysisListItemCard> createState() => _AnalysisListItemCardState();
}

class _AnalysisListItemCardState extends State<AnalysisListItemCard> {
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _navigateToUserProfile(BuildContext context, String userId) {
    if (userId.isEmpty) return;
    Navigator.pushNamed(context, AppRoutes.userProfile, arguments: userId);
  }

  Future<void> _initializePlayer() async {
    final videoUrl =
        widget.item.analyzedVideoUrl ?? widget.item.originalVideoUrl;
    if (videoUrl.isEmpty) return;

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
      cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: false,
        aspectRatio: 16 / 9,
        fit: BoxFit.cover,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enablePlayPause: true,
          enableProgressBar: true,
          showControlsOnInitialize: false,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings=S.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildVideoArea(theme), _buildInfoAndAction(theme,strings)],
      ),
    );
  }

  Widget _buildVideoArea(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _betterPlayerController != null
            ? BetterPlayer(controller: _betterPlayerController!)
            : Container(color: theme.colorScheme.surfaceVariant),
      ),
    );
  }

  Widget _buildInfoAndAction(ThemeData theme,S strings) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Type Badge & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnalysisTypeBadge(type: widget.item.type),
              Text(
                _formatDate(widget.item.createdAt),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Inside _buildInfoAndAction in AnalysisListItemCard
GestureDetector(
  onTap: () => _navigateToUserProfile(context, widget.item.player.userId),
  child: Row(
    children: [
      CircleAvatar(
        radius: 18.r,
        backgroundImage: (widget.item.player.profilePicture != null)
            ? NetworkImage(widget.item.player.profilePicture!)
            : null,
        child: (widget.item.player.profilePicture == null)
            ? Icon(Icons.person, size: 20.sp)
            : null,
      ),
      SizedBox(width: 10.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Player", style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
            Text(
              widget.item.player.fullName,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ],
  ),
),          SizedBox(height: 16.h),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onSecondaryFixed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                strings.viewReport,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
