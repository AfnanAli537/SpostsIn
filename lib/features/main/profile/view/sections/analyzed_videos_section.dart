import 'package:flutter/material.dart';
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
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: InkWell(
                onTap: () => onVideoTap?.call(video),
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        height: 180.h,
                        width: double.infinity,
                        color: theme.colorScheme.surfaceVariant,
                        child: Image.network(
                          video.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 50.sp,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12.h,
                      left: 12.w,
                      right: 12.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatChip(
                            icon: Icons.access_time,
                            label: video.duration,
                          ),
                          _buildStatChip(
                            icon: Icons.speed,
                            label: video.speed,
                            color: theme.colorScheme.primary,
                          ),
                          _buildStatChip(
                            icon: Icons.directions_run,
                            label: video.distance,
                            color: theme.colorScheme.secondary,
                          ),
                          _buildStatChip(
                            icon: Icons.local_fire_department,
                            label: video.calories,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          onPressed: () {},
                          constraints: BoxConstraints(
                            minWidth: 32.w,
                            minHeight: 32.h,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: TextButton(
              onPressed: onShowAll,
              style: TextButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(string.moreDetails),
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color ?? Colors.black),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}