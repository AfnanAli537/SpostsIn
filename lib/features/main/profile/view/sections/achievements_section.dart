import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;
  final VoidCallback? onShowAll;
  final Function(Achievement)? onAchievementTap;
  final ThemeData theme;
  final S string;

  const AchievementsSection({
    super.key,
    required this.achievements,
    this.onShowAll,
    this.onAchievementTap,
    required this.theme,
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: string.achievements, onShowAllPressed: onShowAll),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: achievements.length > 3 ? 3 : achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: InkWell(
                onTap: () => onAchievementTap?.call(achievement),
                borderRadius: BorderRadius.circular(8.r),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        color: theme.colorScheme.surfaceVariant,
                        child: Image.network(
                          achievement.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.emoji_events,
                              color: theme.colorScheme.onSurfaceVariant,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            achievement.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onTertiaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
