import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_type_badge.dart';

class AnalysisListItemCard extends StatelessWidget {
  final AnalysisListItemModel item;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const AnalysisListItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onDelete,
  });

  // Converts a Cloudinary video URL to a thumbnail image URL
  // e.g. .../upload/v.../video.mp4  →  .../upload/so_0/v.../video.jpg
  String? _toThumbnail(String? videoUrl) {
    if (videoUrl == null) return null;
    try {
      return videoUrl
          .replaceFirst('/upload/', '/upload/so_0,w_600,c_fill/')
          .replaceAll(RegExp(r'\.mp4$'), '.jpg');
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Prefer analyzed video; fall back to original
    final displayVideoUrl = item.analyzedVideoUrl ?? item.originalVideoUrl;
    final isAnalyzed = item.analyzedVideoUrl != null;
    final thumbnailUrl = _toThumbnail(displayVideoUrl);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ────────────────────────────────────────────────
            ClipRRect(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Stack(
                children: [
                  // Thumbnail image (Cloudinary poster frame)
                  SizedBox(
                    height: 160.h,
                    width: double.infinity,
                    child: thumbnailUrl != null
                        ? Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _placeholderBg(theme),
                          )
                        : _placeholderBg(theme),
                  ),

                  // Dark gradient overlay so badges are readable
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.black.withOpacity(0.45),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Play button
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.88),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 32.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  // Type badge — top-left
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: AnalysisTypeBadge(type: item.type),
                  ),

                  // Analyzed / Pending chip — top-right
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: _StatusChip(isPaid: item.isPaid),
                  ),

                  // "Analyzed video" / "Original video" label — bottom-left
                  Positioned(
                    bottom: 8.h,
                    left: 10.w,
                    child: Row(
                      children: [
                        Icon(
                          isAnalyzed
                              ? Icons.auto_fix_high_rounded
                              : Icons.videocam_outlined,
                          size: 12.sp,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          isAnalyzed ? 'Analyzed video' : 'Original video',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Info row ─────────────────────────────────────────────────
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.type} Analysis',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          _formatDate(item.createdAt),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 20.sp,
                        color: theme.colorScheme.error.withOpacity(0.7),
                      ),
                    ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22.sp,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderBg(ThemeData theme) => Container(
        color: theme.colorScheme.surfaceVariant,
        child: Center(
          child: Icon(
            Icons.videocam_outlined,
            size: 40.sp,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.35),
          ),
        ),
      );

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final bool isPaid;

  const _StatusChip({required this.isPaid});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isPaid
              ? Colors.green.withOpacity(0.85)
              : Colors.orange.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          isPaid ? 'Analyzed' : 'Pending',
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}