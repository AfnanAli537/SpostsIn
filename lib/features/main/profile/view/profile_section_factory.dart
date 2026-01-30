import 'package:flutter/material.dart';
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

class ProfileSectionFactory {
  // Build user-specific data section (called separately in profile screen)
  static Widget buildUserSpecificDataSection(ProfileModel profile) {
    switch (profile.userType) {
      case UserType.player:
        if (profile.playerData != null) {
          return PlayerDataSection(data: profile.playerData!);
        }
        break;
      case UserType.coach:
        if (profile.coachData != null) {
          return CoachDataSection(data: profile.coachData!);
        }
        break;
      case UserType.scout:
        if (profile.scoutData != null) {
          return ScoutDataSection(data: profile.scoutData!);
        }
        break;
      case UserType.club:
        if (profile.clubData != null) {
          return ClubDataSection(data: profile.clubData!);
        }
        break;
      case UserType.institute:
        if (profile.instituteData != null) {
          return InstituteDataSection(data: profile.instituteData!);
        }
        break;
      case UserType.other:
        // Others don't have specific data section
        return const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }

  // Build other sections (Posts, Opportunities, etc.)
  static List<Widget> buildOtherSections({
    required ProfileModel profile,
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
  }) {
    List<Widget> sections = [];

    // Posts section - All users
    if (profile.posts.isNotEmpty) {
      sections.add(PostsSection(
        posts: profile.posts,
        onShowAll: onPostsShowAll,
        onPostTap: onPostTap,
      ));
    }

    // Opportunities section - Coach, Scout, Club only (NOT Player or Others)
    if (profile.opportunities != null && 
        profile.opportunities!.isNotEmpty &&
        (profile.userType == UserType.coach ||
        profile.userType == UserType.scout ||
        profile.userType == UserType.club)) {
      sections.add(OpportunitiesSection(
        opportunities: profile.opportunities!,
        onShowAll: onOpportunitiesShowAll,
        onOpportunityTap: onOpportunityTap,
      ));
    }

    // Courses section - All EXCEPT Scout
    if (profile.courses != null && 
        profile.courses!.isNotEmpty &&
        profile.userType != UserType.scout) {
      sections.add(CoursesSection(
        courses: profile.courses!,
        onShowAll: onCoursesShowAll,
        onCourseTap: onCourseTap,
      ));
    }

    // Achievements section - All users
    if (profile.achievements.isNotEmpty) {
      sections.add(AchievementsSection(
        achievements: profile.achievements,
        onShowAll: onAchievementsShowAll,
        onAchievementTap: onAchievementTap,
      ));
    }

    // Analyzed videos section - All users
    if (profile.analyzedVideos.isNotEmpty) {
      sections.add(AnalyzedVideosSection(
        videos: profile.analyzedVideos,
        onShowAll: onVideosShowAll,
        onVideoTap: onVideoTap,
      ));
    }

    // Interests section - All users
    if (profile.interests.isNotEmpty) {
      sections.add(InterestsSection(
        interests: profile.interests,
        onShowAll: onInterestsShowAll,
        onConnectToggle: onConnectToggle,
        onFollowToggle: onFollowToggle,
      ));
    }

    return sections;
  }

  // Legacy method for backward compatibility (deprecated)
  @Deprecated('Use buildUserSpecificDataSection and buildOtherSections separately')
  static List<Widget> buildSections({
    required ProfileModel profile,
    required bool isOwnProfile,
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
  }) {
    List<Widget> sections = [];
    
    sections.add(buildUserSpecificDataSection(profile));
    sections.add(ProfileStatsWidget(
              stats: profile.stats,
              onFollowersPressed: () {},
              onFollowingPressed: () {},
              onConnectionsPressed: () {},
              onAnalyzedPeoplePressed: () {},
            ),
            
            );
    sections.add(const Divider(height: 1,color: Colors.grey,));
    if (!isOwnProfile) 
      {sections.add(              
        Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle connect
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1E3A5F)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Connect',
                          style: TextStyle(
                            color: Color(0xFF1E3A5F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle follow
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A5F),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Follow',
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
);}
    sections.addAll(buildOtherSections(
      profile: profile,
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
    ));
    
    return sections;
  }
}