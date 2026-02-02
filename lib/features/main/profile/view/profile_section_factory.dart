import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/features/main/profile/view/widgets/profile_stats_widget.dart';
import '../model/profile_model.dart';
import 'sections/posts_section.dart';
import 'sections/opportunities_section.dart';
import 'sections/courses_section.dart';
import 'sections/achievements_section.dart';
import 'sections/analyzed_videos_section.dart';
import 'sections/interests_section.dart';
import 'sections/player_data_section.dart';
import 'sections/coach_data_section.dart';
import 'sections/scout_data_section.dart';
import 'sections/club_data_section.dart';
import 'sections/institute_data_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSectionFactory {
  static Widget buildUserSpecificDataSection(
    ProfileModel profile,
    ThemeData theme,
    S string,
  ) {
    switch (profile.userType) {
      case UserType.player:
        if (profile.playerData != null) {
          return PlayerDataSection(
            data: profile.playerData!,
            theme: theme,
            string: string,
          );
        }
        break;
      case UserType.coach:
        if (profile.coachData != null) {
          return CoachDataSection(
            data: profile.coachData!,
            theme: theme,
            string: string,
          );
        }
        break;
      case UserType.scout:
        if (profile.scoutData != null) {
          return ScoutDataSection(
            data: profile.scoutData!,
            theme: theme,
            string: string,
          );
        }
        break;
      case UserType.club:
        if (profile.clubData != null) {
          return ClubDataSection(
            data: profile.clubData!,
            theme: theme,
            string: string,
          );
        }
        break;
      case UserType.institute:
        if (profile.instituteData != null) {
          return InstituteDataSection(
            data: profile.instituteData!,
            theme: theme,
            string: string,
          );
        }
        break;
      case UserType.other:
        return const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }

  static List<Widget> buildOtherSections({
    required ProfileModel profile,
    required ThemeData theme,
    required S string,
    VoidCallback? onPostsShowAll,
    VoidCallback? onOpportunitiesShowAll,
    VoidCallback? onCoursesShowAll,
    VoidCallback? onAchievementsShowAll,
    VoidCallback? onVideosShowAll,
    VoidCallback? onInterestsShowAll,
    Function(Post)? onPostTap,
    Function(Opportunity)? onOpportunityTap,
    Function(Course)? onCourseTap,
    Function(Achievement)? onAchievementTap,
    Function(AnalyzedVideoReport)? onVideoTap,
    Function(Interest, bool)? onConnectToggle,
    Function(Interest, bool)? onFollowToggle,
    Function(Interest)? onInterestTap,
  }) {
    List<Widget> sections = [];

    if (profile.posts.isNotEmpty) {
      sections.add(PostsSection(
        posts: profile.posts,
        onShowAll: onPostsShowAll,
        onPostTap: onPostTap,
        theme: theme,
        string: string,
      ));
    }

    if (profile.opportunities != null &&
        profile.opportunities!.isNotEmpty &&
        (profile.userType == UserType.coach ||
            profile.userType == UserType.scout ||
            profile.userType == UserType.club)) {
      sections.add(OpportunitiesSection(
        opportunities: profile.opportunities!,
        onShowAll: onOpportunitiesShowAll,
        onOpportunityTap: onOpportunityTap,
        theme: theme,
        string: string,
      ));
    }

    if (profile.courses != null &&
        profile.courses!.isNotEmpty &&
        profile.userType != UserType.scout) {
      sections.add(CoursesSection(
        courses: profile.courses!,
        onShowAll: onCoursesShowAll,
        onCourseTap: onCourseTap,
        theme: theme,
        string: string,
      ));
    }

    if (profile.achievements.isNotEmpty) {
      sections.add(AchievementsSection(
        achievements: profile.achievements,
        onShowAll: onAchievementsShowAll,
        onAchievementTap: onAchievementTap,
        theme: theme,
        string: string,
      ));
    }

    if (profile.analyzedVideos.isNotEmpty) {
      sections.add(AnalyzedVideosSection(
        videos: profile.analyzedVideos,
        onShowAll: onVideosShowAll,
        onVideoTap: onVideoTap,
        theme: theme,
        string: string,
      ));
    }

    if (profile.interests.isNotEmpty) {
      sections.add(InterestsSection(
        interests: profile.interests,
        onShowAll: onInterestsShowAll,
        onConnectToggle: onConnectToggle,
        onFollowToggle: onFollowToggle,
        onInterestTap: onInterestTap,
        theme: theme,
        string: string,
      ));
    }

    return sections;
  }

  static List<Widget> buildSections({
    required ProfileModel profile,
    required bool isOwnProfile,
    required ThemeData theme,
    required S string,
    VoidCallback? onPostsShowAll,
    VoidCallback? onOpportunitiesShowAll,
    VoidCallback? onCoursesShowAll,
    VoidCallback? onAchievementsShowAll,
    VoidCallback? onVideosShowAll,
    VoidCallback? onInterestsShowAll,
    Function(Post)? onPostTap,
    Function(Opportunity)? onOpportunityTap,
    Function(Course)? onCourseTap,
    Function(Achievement)? onAchievementTap,
    Function(AnalyzedVideoReport)? onVideoTap,
    Function(Interest, bool)? onConnectToggle,
    Function(Interest, bool)? onFollowToggle,
    Function(Interest)? onInterestTap,
    VoidCallback? onConnectPressed,
    VoidCallback? onFollowPressed,
  }) {
    List<Widget> sections = [];

    sections.add(buildUserSpecificDataSection(profile, theme, string));
    sections.add(ProfileStatsWidget(
      stats: profile.stats,
      onFollowersPressed: () {},
      onFollowingPressed: () {},
      onConnectionsPressed: () {},
      onAnalyzedPeoplePressed: () {},
      theme: theme,
      string: string,
    ));
    sections.add(Divider(height: 1.h, color: ColorManager.hintTextColor));

    if (!isOwnProfile) {
      sections.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.h),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onConnectPressed,
                  child: Text(
                    'Connect', // Will be localized
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onFollowPressed,
                  child: const Text(
                    'Follow', // Will be localized
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    sections.addAll(buildOtherSections(
      profile: profile,
      theme: theme,
      string: string,
      onPostsShowAll: onPostsShowAll,
      onOpportunitiesShowAll: onOpportunitiesShowAll,
      onCoursesShowAll: onCoursesShowAll,
      onAchievementsShowAll: onAchievementsShowAll,
      onVideosShowAll: onVideosShowAll,
      onInterestsShowAll: onInterestsShowAll,
      onPostTap: onPostTap,
      onOpportunityTap: onOpportunityTap,
      onCourseTap: onCourseTap,
      onAchievementTap: onAchievementTap,
      onVideoTap: onVideoTap,
      onConnectToggle: onConnectToggle,
      onFollowToggle: onFollowToggle,
      onInterestTap: onInterestTap,
    ));

    return sections;
  }
}