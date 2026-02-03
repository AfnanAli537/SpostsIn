import 'package:injectable/injectable.dart';
import '../interface/i_profile_data_source.dart';
import '../../model/profile_model.dart';

@LazySingleton(as: IProfileDataSource)
class MockProfileData implements IProfileDataSource {
  @override
  Future<ProfileModel> getMyProfile() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return ProfileModel.fromJson(_getPlayerProfileData()['data']);
  }

  @override
  Future<ProfileModel> getUserProfile(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    // Return different profiles based on userId for testing
    if (userId == 'coach_001') {
      return ProfileModel.fromJson(getCoachProfileData()['data']);
    }
    return ProfileModel.fromJson(_getPlayerProfileData()['data']);
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ProfileModel.fromJson(_getPlayerProfileData()['data']);
  }

  @override
  Future<void> toggleFollow(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Simulate successful toggle
    print('Mock: Toggled follow for user $userId');
  }

  @override
  Future<void> toggleConnect(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Simulate successful toggle
    print('Mock: Toggled connect for user $userId');
  }

  @override
  Future<List<Post>> getPosts({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final data = _getPlayerProfileData()['data']['posts'] as List;
    return data.map((e) => Post.fromJson(e)).toList();
  }

  @override
  Future<List<Opportunity>> getOpportunities({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final data = getCoachProfileData()['data']['opportunities'] as List?;
    if (data == null) return [];
    return data.map((e) => Opportunity.fromJson(e)).toList();
  }

  @override
  Future<List<Course>> getCourses({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final data = getCoachProfileData()['data']['courses'] as List?;
    if (data == null) return [];
    return data.map((e) => Course.fromJson(e)).toList();
  }

  @override
  Future<List<Interest>> getInterests({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final data = _getPlayerProfileData()['data']['interests'] as List;
    return data.map((e) => Interest.fromJson(e)).toList();
  }

  static Map<String, dynamic> _getPlayerProfileData() {
    return {
      "success": true,
      "data": {
        "id": "player_001",
        "name": "Abhishek Patel",
        "profileImage": "https://i.pravatar.cc/300?img=12",
        "role": "Athlete - Football",
        "description": "Passionate about sports and continuous improvement. Focused on performance.",
        "userType": "player",
        "stats": {
          "followers": "115500",
          "following": "150",
          "connections": "2600000",
          "analyzedPeople": "2600000"
        },
        "posts": [
          {"id": "post_1", "imageUrl": "https://picsum.photos/200/200?random=1"},
          {"id": "post_2", "imageUrl": "https://picsum.photos/200/200?random=2"},
          {"id": "post_3", "imageUrl": "https://picsum.photos/200/200?random=3"}
        ],
        "opportunities": null, // Player doesn't have opportunities
        "achievements": [
          {
            "id": "ach_1",
            "title": "National League 2023",
            "subtitle": "2023 Season",
            "imageUrl": "https://i.pravatar.cc/100?img=1"
          },
          {
            "id": "ach_2",
            "title": "National League 2023",
            "subtitle": "2023 Season",
            "imageUrl": "https://i.pravatar.cc/100?img=2"
          }
        ],
        "analyzedVideos": [
          {
            "id": "vid_1",
            "thumbnailUrl": "https://picsum.photos/400/200?random=6",
            "duration": "17:45",
            "speed": "3990/6000",
            "distance": "6h/8h",
            "calories": "156/900kcal"
          }
        ],
        "interests": [
          {
            "id": "user_1",
            "name": "Celeb Reed",
            "role": "Athlete",
            "profileImage": "https://i.pravatar.cc/100?img=5",
            "isConnected": true,
            "isFollowing": false
          },
          {
            "id": "user_2",
            "name": "Owen Turner",
            "role": "Agent",
            "profileImage": "https://i.pravatar.cc/100?img=6",
            "isConnected": false,
            "isFollowing": true
          },
          {
            "id": "user_3",
            "name": "Sarah Johnson",
            "role": "Coach",
            "profileImage": "https://i.pravatar.cc/100?img=7",
            "isConnected": true,
            "isFollowing": true
          },
          {
            "id": "user_4",
            "name": "Mike Smith",
            "role": "Scout",
            "profileImage": "https://i.pravatar.cc/100?img=8",
            "isConnected": false,
            "isFollowing": false
          },
          {
            "id": "user_5",
            "name": "Emma Davis",
            "role": "Athlete",
            "profileImage": "https://i.pravatar.cc/100?img=9",
            "isConnected": true,
            "isFollowing": false
          },
          {
            "id": "user_6",
            "name": "John Williams",
            "role": "Manager",
            "profileImage": "https://i.pravatar.cc/100?img=10",
            "isConnected": false,
            "isFollowing": true
          }
        ],
        "playerData": {
          "position": "Striker",
          "height": "180",
          "weight": "75",
          "preferredFoot": "Shooting, Heading, Passing",
          "age": "27",
          "specializedSport": "Football",
          "yearsOfExperience": 5
        }
      }
    };
  }

  static Map<String, dynamic> getCoachProfileData() {
    return {
      "success": true,
      "data": {
        "id": "coach_001",
        "name": "Celeb Reed",
        "profileImage": "https://i.pravatar.cc/300?img=5",
        "role": "Coach - Football",
        "description": "Passionate about sports and continuous improvement. Focused on performance.",
        "userType": "coach",
        "isConnected": false, // ADD THIS
        "isFollowing": false, // ADD THIS
        "stats": {
          "followers": "115500",
          "following": "150",
          "connections": "2600000",
          "analyzedPeople": "2600000"
        },
        "posts": [
          {"id": "post_1", "imageUrl": "https://picsum.photos/200/200?random=11"},
          {"id": "post_2", "imageUrl": "https://picsum.photos/200/200?random=12"},
          {"id": "post_3", "imageUrl": "https://picsum.photos/200/200?random=13"}
        ],
        "opportunities": [
          {"id": "opp_1", "imageUrl": "https://picsum.photos/200/200?random=14"},
          {"id": "opp_2", "imageUrl": "https://picsum.photos/200/200?random=15"}
        ],
        "courses": [
          {"id": "course_1", "imageUrl": "https://picsum.photos/200/200?random=16"},
          {"id": "course_2", "imageUrl": "https://picsum.photos/200/200?random=17"}
        ],
        "achievements": [
          {
            "id": "ach_1",
            "title": "National League 2023",
            "subtitle": "2023 Season",
            "imageUrl": "https://i.pravatar.cc/100?img=1"
          }
        ],
        "analyzedVideos": [
          {
            "id": "vid_1",
            "thumbnailUrl": "https://picsum.photos/400/200?random=18",
            "duration": "17:45",
            "speed": "3990/6000",
            "distance": "6h/8h",
            "calories": "156/900kcal"
          }
        ],
        "interests": [
          {
            "id": "player_001",
            "name": "Abhishek Patel",
            "role": "Athlete",
            "profileImage": "https://i.pravatar.cc/100?img=12",
            "isConnected": false,
            "isFollowing": false
          },
          {
            "id": "user_2",
            "name": "Owen Turner",
            "role": "Agent",
            "profileImage": "https://i.pravatar.cc/100?img=6",
            "isConnected": false,
            "isFollowing": true
          },
          {
            "id": "user_3",
            "name": "Sarah Johnson",
            "role": "Coach",
            "profileImage": "https://i.pravatar.cc/100?img=7",
            "isConnected": true,
            "isFollowing": true
          },
          {
            "id": "user_4",
            "name": "Mike Smith",
            "role": "Scout",
            "profileImage": "https://i.pravatar.cc/100?img=8",
            "isConnected": false,
            "isFollowing": false
          },
          {
            "id": "user_5",
            "name": "Emma Davis",
            "role": "Athlete",
            "profileImage": "https://i.pravatar.cc/100?img=9",
            "isConnected": true,
            "isFollowing": false
          },
          {
            "id": "user_7",
            "name": "Alex Brown",
            "role": "Manager",
            "profileImage": "https://i.pravatar.cc/100?img=11",
            "isConnected": false,
            "isFollowing": true
          }
        ],
        "coachData": {
          "specializedSport": "Football",
          "yearsOfExperience": 5
        }
      }
    };
  }
}