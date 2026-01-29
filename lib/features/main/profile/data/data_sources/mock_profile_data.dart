import 'package:sports_in/features/main/profile/data/interface/i_profile_data_source.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';

class MockProfileData implements IProfileDataSource {
  static Map<String, dynamic> getMyProfileResponse() {
    return {
      "success": true,
      "data": {
        "id": "player_001",
        "name": "Abhishek Patel",
        "profileImage": "https://i.pravatar.cc/300?img=12",
        "role": "Athlete - Football",
        "description":
            "Passionate about sports and continuous improvement. Focused on performance.",
        "userType": "player",
        "stats": {
          "followers": "115500",
          "following": "150",
          "connections": "2600000",
          "analyzedPeople": "2600000",
        },
        "posts": [
          {
            "id": "post_1",
            "imageUrl": "https://picsum.photos/200/200?random=1",
            "title": "Training Day",
          },
          {
            "id": "post_2",
            "imageUrl": "https://picsum.photos/200/200?random=2",
            "title": "Game Day",
          },
          {
            "id": "post_3",
            "imageUrl": "https://picsum.photos/200/200?random=3",
            "title": "Stadium",
          },
          {
            "id": "post_1",
            "imageUrl": "https://picsum.photos/200/200?random=1",
            "title": "Training Day",
          },
          {
            "id": "post_2",
            "imageUrl": "https://picsum.photos/200/200?random=2",
            "title": "Game Day",
          },
          {
            "id": "post_3",
            "imageUrl": "https://picsum.photos/200/200?random=3",
            "title": "Stadium",
          },

        ],
        "opportunities": [
          {
            "id": "opp_1",
            "imageUrl": "https://picsum.photos/200/200?random=4",
            "title": "Team Tryout",
          },
          {
            "id": "opp_2",
            "imageUrl": "https://picsum.photos/200/200?random=5",
            "title": "Academy Position",
          },
        ],
        "achievements": [
          {
            "id": "ach_1",
            "title": "National League 2023",
            "subtitle": "2023 Season",
            "imageUrl": "https://i.pravatar.cc/100?img=1",
          },
          {
            "id": "ach_2",
            "title": "Player of the Month",
            "subtitle": "January 2024",
            "imageUrl": "https://i.pravatar.cc/100?img=2",
          },
        ],
        "analyzedVideos": [
          {
            "id": "vid_1",
            "thumbnailUrl": "https://picsum.photos/400/200?random=6",
            "duration": "17:45",
            "speed": "3990/6000",
            "distance": "6h/8h",
            "calories": "156/900kcal",
          },
        ],
        "interests": [
          {
            "id": "user_456",
            "name": "Celeb Reed",
            "role": "Athlete",
            "profileImage": "https://i.pravatar.cc/100?img=5",
            "isConnected": true,
            "isFollowing": false,
          },
          {
            "id": "user_789",
            "name": "Owen Turner",
            "role": "Agent",
            "profileImage": "https://i.pravatar.cc/100?img=6",
            "isConnected": false,
            "isFollowing": true,
          },
        ],
        "playerData": {
          "position": "Forward",
          "height": "180",
          "weight": "75",
          "preferredFoot": "Right",
          "age": "27",
          "specializedSport": "Football",
          "yearsOfExperience": 5,
        },
      },
    };
  }

  @override
  Future<ProfileModel> getMyProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final response = MockProfileData.getMyProfileResponse();
    return ProfileModel.fromJson(response['data']);
  }

  @override
  Future<ProfileModel> getUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final response = MockProfileData.getMyProfileResponse();
    return ProfileModel.fromJson(response['data']);
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final current = Map<String, dynamic>.from(
      MockProfileData.getMyProfileResponse()['data'],
    );

    final updated = <String, dynamic>{...current, ...updateData};

    return ProfileModel.fromJson(updated);
  }

  @override
  Future<void> followUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> unfollowUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> connectWithUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> disconnectFromUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
