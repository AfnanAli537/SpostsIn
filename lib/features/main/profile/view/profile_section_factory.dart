import 'package:flutter/material.dart';
import '../model/profile_model.dart';
import 'sections/posts_section.dart';
import 'sections/opportunities_section.dart';
import 'sections/courses_section.dart';
import 'sections/achievements_section.dart';
import 'sections/analyzed_videos_section.dart';
import 'sections/interests_section.dart';
import 'sections/player_data_section.dart';
import 'sections/coach_data_section.dart';

class ProfileSectionFactory {
  static List<Widget> buildSections({
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

    sections.add(_buildUserSpecificDataSection(profile));

    if (profile.posts.isNotEmpty) {
      sections.add(PostsSection(
        posts: profile.posts,
        onShowAll: onPostsShowAll,
        onPostTap: onPostTap,
      ));
    }

    if (profile.opportunities != null && profile.opportunities!.isNotEmpty) {
      sections.add(OpportunitiesSection(
        opportunities: profile.opportunities!,
        onShowAll: onOpportunitiesShowAll,
        onOpportunityTap: onOpportunityTap,
      ));
    }

    if (profile.courses != null && profile.courses!.isNotEmpty) {
      sections.add(CoursesSection(
        courses: profile.courses!,
        onShowAll: onCoursesShowAll,
        onCourseTap: onCourseTap,
      ));
    }

    if (profile.achievements.isNotEmpty) {
      sections.add(AchievementsSection(
        achievements: profile.achievements,
        onShowAll: onAchievementsShowAll,
        onAchievementTap: onAchievementTap,
      ));
    }

    if (profile.analyzedVideos.isNotEmpty) {
      sections.add(AnalyzedVideosSection(
        videos: profile.analyzedVideos,
        onShowAll: onVideosShowAll,
        onVideoTap: onVideoTap,
      ));
    }

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

  static Widget _buildUserSpecificDataSection(ProfileModel profile) {
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
          return _buildScoutDataSection(profile.scoutData!);
        }
        break;
      case UserType.club:
        if (profile.clubData != null) {
          return _buildClubDataSection(profile.clubData!);
        }
        break;
      case UserType.institute:
        if (profile.instituteData != null) {
          return _buildInstituteDataSection(profile.instituteData!);
        }
        break;
      case UserType.other:
        if (profile.otherData != null && 
            profile.otherData!.customData != null) {
          return _buildOtherDataSection(profile.otherData!);
        }
        break;
    }
    return const SizedBox.shrink();
  }

  static Widget _buildScoutDataSection(ScoutSpecificData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.specializedSport != null)
            _buildInfoRow('Specialized sport', data.specializedSport!),
          if (data.yearsOfExperience != null)
            _buildInfoRow('Years of experience', 
              data.yearsOfExperience.toString()),
          if (data.organization != null)
            _buildInfoRow('Organization', data.organization!),
        ],
      ),
    );
  }

  static Widget _buildClubDataSection(ClubSpecificData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.sport != null)
            _buildInfoRow('Sport', data.sport!),
          if (data.foundedYear != null)
            _buildInfoRow('Founded', data.foundedYear!),
          if (data.location != null)
            _buildInfoRow('Location', data.location!),
        ],
      ),
    );
  }

  static Widget _buildInstituteDataSection(InstituteSpecificData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.foundedYear != null)
            _buildInfoRow('Founded', data.foundedYear!),
          if (data.location != null)
            _buildInfoRow('Location', data.location!),
          if (data.accreditation != null)
            _buildInfoRow('Accreditation', data.accreditation!),
        ],
      ),
    );
  }

  static Widget _buildOtherDataSection(OtherSpecificData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.customData != null)
            ...data.customData!.entries.map((entry) {
              return _buildInfoRow(
                _formatKey(entry.key), 
                entry.value.toString(),
              );
            }).toList(),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatKey(String key) {
    return key.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    ).trim().split(' ').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }
}