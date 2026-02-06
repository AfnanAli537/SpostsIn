import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalyzedVideosSection extends StatelessWidget {
  final List<AnalyzedVideoReport> videos;
  final VoidCallback? onShowAll;
  final Function(AnalyzedVideoReport)? onVideoTap;
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
            final video = videos[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(28.r),
              ),
              child: Column(
                children: [
                  _buildVideoThumbnail(video),
                  _buildStatsRow(video),
                  _buildActionRow(),
                  SizedBox(height: 16.h),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildVideoThumbnail(AnalyzedVideoReport video) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Thumbnail Image
          ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                video.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
          // Play Button Overlay
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 45.sp),
          ),
          // More Vert with background for visibility
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.all(6.w),
                icon: Icon(Icons.more_horiz, color: Colors.white, size: 20.sp),
                onPressed: () {},
              ),
            ),
          ),
          // Volume Icon
          Positioned(
            bottom: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.volume_up, color: Colors.white, size: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AnalyzedVideoReport video) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "1h ago",
            style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
          ),
          SizedBox(height: 12.h),
          // The Row that was overflowing - now using Expanded and Flexible
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildStatItem(
                  Icons.directions_walk, 
                  "Steps", 
                  "2890/8k", 
                  const Color(0xFF546E7A)
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  Icons.nightlight_round, 
                  "Sleep", 
                  "0h/8h", 
                  const Color(0xFF3949AB)
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  Icons.local_fire_department, 
                  "Calories", 
                  "169/800", 
                  const Color(0xFF66BB6A)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22.sp),
        SizedBox(width: 6.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: ColorManager.grey, fontSize: 10.sp),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: EdgeInsets.only(right: 20.w, top: 12.h),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: onShowAll,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary, 
            foregroundColor: theme.colorScheme.onSecondaryFixed, 
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            string.moreDetails,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}