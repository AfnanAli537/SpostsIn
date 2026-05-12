import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/video_analysis/data/enums/analysis_type.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/view/presentation/analysis_payment_screen.dart';
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
      cacheConfiguration:
          const BetterPlayerCacheConfiguration(useCache: true),
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

  AnalysisType _typeFromString(String type) {
    switch (type) {
      case 'Goalkeeper':
        return AnalysisType.goalkeeper;
      case 'Passing':
        return AnalysisType.passing;
      case 'Dribbling':
        return AnalysisType.dribbling;
      default:
        return AnalysisType.match;
    }
  }

  void _navigateToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnalysisPaymentScreen(
          analysisId: widget.item.id,
          price: 100.0,
          analysisType: _typeFromString(widget.item.type),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);
    final isPaid = widget.item.isPaid;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
        children: [
          _buildVideoArea(theme, isPaid, strings),
          _buildInfoAndAction(theme, strings, isPaid),
        ],
      ),
    );
  }

 Widget _buildVideoArea(ThemeData theme, bool isPaid, S strings) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      child: Stack(
        children: [
          // 1. The Video Player
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _betterPlayerController != null
                ? BetterPlayer(controller: _betterPlayerController!)
                : Container(color: theme.colorScheme.surfaceVariant),
          ),

          // 2. The Pop-up Menu (Added for Delete functionality)
          if(widget.item.analyst.userId == getIt<SharedPref>().getUserId())
          Positioned(
            top: 8.h,
            right: 8.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2), // Subtle background for visibility
                shape: BoxShape.circle,
              ),
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white, size: 20.sp),
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 'delete') {
                    widget.onDelete?.call(); // Calls the delete callback passed to the widget
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: theme.colorScheme.error, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          strings.deleteAnalysis, 
                          style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. The Lock Overlay (if unpaid)
          if (!isPaid)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.lock_outline, color: Colors.white, size: 30.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      strings.analysisPendingPayment,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildInfoAndAction(ThemeData theme, S strings, bool isPaid) {
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

          // Player info
          GestureDetector(
            onTap: () =>
                _navigateToUserProfile(context, widget.item.player.userId),
            child: Row(children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage:
                    (widget.item.player.profilePicture != null)
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
                    Text(strings.player,
                        style: TextStyle(
                            fontSize: 10.sp, color: Colors.grey)),
                    Text(
                      widget.item.player.fullName,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          SizedBox(height: 16.h),

          // Action buttons
          if (isPaid)
            // Paid → View Report
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onSecondaryFixed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  strings.viewReport,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
              ),
            )
          else
            // Unpaid → Pay Now
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onTap,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.4)),
                    foregroundColor:
                        theme.colorScheme.onSurface.withOpacity(0.6),
                    padding: EdgeInsets.symmetric(vertical: 11.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(strings.viewReport,
                      style:
                          TextStyle(fontSize: 13.sp)),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _navigateToPayment,
                  icon: Icon(Icons.payment_rounded,
                      size: 16.sp, color: Colors.white),
                  label: Text(
                    strings.payNow,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                ),
              ),
            ]),
        ],
      ),
    );
  }
}