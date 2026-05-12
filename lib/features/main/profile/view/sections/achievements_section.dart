import 'package:flutter/material.dart';
import 'package:sports_in/features/main/profile/view/presentation/achievement/achievement_detail_screen.dart';
import 'package:sports_in/features/main/profile/view/presentation/achievement/achievements_list_screen.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;
  final String userId;
  final bool isCurrentUser;
  final ThemeData theme;
  final S string;

  const AchievementsSection({
    super.key,
    required this.achievements,
    required this.userId,
    required this.isCurrentUser,
    required this.theme,
    required this.string,
  });

  void _navigateToAchievementsList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AchievementsListScreen(
          userId: userId,
          isCurrentUser: isCurrentUser,
        ),
      ),
    );
  }

  void _navigateToAchievementDetail(
    BuildContext context,
    Achievement achievement,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AchievementDetailScreen(
          achievement: achievement,
          isCurrentUser: isCurrentUser,
          userId: userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Use SectionHeader with Show All button
        SectionHeader(
          title: string.achievements,
          onShowAllPressed:
              // achievements.length > 3?
              () => _navigateToAchievementsList(context),
          // : null,
        ),

        // Achievement Cards
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: achievements.length > 3 ? 3 : achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _AchievementCard(
                achievement: achievement,
                theme: theme,
                onTap: () => _navigateToAchievementDetail(context, achievement),
              ),
            );
          },
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final ThemeData theme;
  final VoidCallback onTap;

  const _AchievementCard({
    required this.achievement,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Row(
        children: [
          // Achievement Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: 60.w,
              height: 60.h,
              color: theme.colorScheme.surfaceVariant,
              child: Image.network(
                achievement.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.emoji_events,
                    color: theme.colorScheme.primary,
                    size: 30.sp,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Achievement Details (Title and Date only)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  achievement.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                // Date/Year Badge
                if (achievement.date != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    child: Text(
                      achievement.date!.year.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
