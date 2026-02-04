import 'package:injectable/injectable.dart';
import '../interface/i_profile_data_source.dart';
import '../../model/profile_model.dart';

@LazySingleton(as: IProfileDataSource)
class MockProfileData implements IProfileDataSource {
  
  // Simulated storage for current user ID (normally from SharedPreferences)
  final String _currentUserId = 'player_001';

  @override
  Future<ProfileModel> getMyProfile() async {
    // Simulate getting userId from shared preferences
    final userId = _currentUserId;
    
    // Get base profile info (includes stats)
    final baseInfo = await _getBaseProfileInfo(userId);
    
    // Fetch all sections in parallel to simulate real API behavior
    final results = await Future.wait([
      getPosts(targetUserId: userId, page: 1, size: 3),
      getAchievements(userId: userId, page: 1, size: 2),
      _getAnalyzedVideos(userId),
      getInterests(userId: userId, page: 1, pageSize: 6),
      _getUserSpecificData(userId),
    ]);

    final posts = results[0] as List<Post>;
    final achievements = results[1] as List<Achievement>;
    final analyzedVideos = results[2] as List<AnalyzedVideoReport>;
    final interests = results[3] as List<Interest>;
    final specificData = results[4] as Map<String, dynamic>;

    return ProfileModel(
      id: baseInfo['id'],
      name: baseInfo['name'],
      profileImage: baseInfo['profileImage'],
      role: baseInfo['role'],
      description: baseInfo['description'],
      userType: baseInfo['userType'],
      stats: baseInfo['stats'],
      posts: posts,
      achievements: achievements,
      analyzedVideos: analyzedVideos,
      interests: interests,
      opportunities: specificData['opportunities'],
      courses: specificData['courses'],
      playerData: specificData['playerData'],
      coachData: specificData['coachData'],
      scoutData: specificData['scoutData'],
      clubData: specificData['clubData'],
      instituteData: specificData['instituteData'],
      otherData: specificData['otherData'],
      isConnected: false,
      isFollowing: false,
    );
  }

  @override
  Future<ProfileModel> getUserProfile(String userId) async {
    // Get base profile info (includes stats)
    final baseInfo = await _getBaseProfileInfo(userId);
    
    // Fetch all sections in parallel
    final results = await Future.wait([
      getPosts(targetUserId: userId, page: 1, size: 3),
      getAchievements(userId: userId, page: 1, size: 2),
      _getAnalyzedVideos(userId),
      getInterests(userId: userId, page: 1, pageSize: 6),
      _getUserSpecificData(userId),
    ]);

    final posts = results[0] as List<Post>;
    final achievements = results[1] as List<Achievement>;
    final analyzedVideos = results[2] as List<AnalyzedVideoReport>;
    final interests = results[3] as List<Interest>;
    final specificData = results[4] as Map<String, dynamic>;

    return ProfileModel(
      id: baseInfo['id'],
      name: baseInfo['name'],
      profileImage: baseInfo['profileImage'],
      role: baseInfo['role'],
      description: baseInfo['description'],
      userType: baseInfo['userType'],
      stats: baseInfo['stats'],
      posts: posts,
      achievements: achievements,
      analyzedVideos: analyzedVideos,
      interests: interests,
      opportunities: specificData['opportunities'],
      courses: specificData['courses'],
      playerData: specificData['playerData'],
      coachData: specificData['coachData'],
      scoutData: specificData['scoutData'],
      clubData: specificData['clubData'],
      instituteData: specificData['instituteData'],
      otherData: specificData['otherData'],
      isConnected: baseInfo['isConnected'],
      isFollowing: baseInfo['isFollowing'],
    );
  }

  // Simulate GET /profile/{userId}/base-info endpoint
  Future<Map<String, dynamic>> _getBaseProfileInfo(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Mock API: GET /profile/$userId/base-info');
    
    final stats = ProfileStats(
      followers: '115500',
      following: '150',
      connections: '2600000',
      analyzedPeople: '2600000',
    );
    
    if (userId == 'coach_001') {
      return {
        'id': 'coach_001',
        'name': 'Celeb Reed',
        'profileImage': 'https://i.pravatar.cc/300?img=5',
        'role': 'Coach - Football',
        'description': 'Passionate about sports and continuous improvement. Focused on performance.',
        'userType': UserType.coach,
        'stats': stats,
        'isConnected': false,
        'isFollowing': false,
      };
    }
    
    return {
      'id': 'player_001',
      'name': 'Abhishek Patel',
      'profileImage': 'https://i.pravatar.cc/300?img=12',
      'role': 'Athlete - Football',
      'description': 'Passionate about sports and continuous improvement. Focused on performance.',
      'userType': UserType.player,
      'stats': stats,
      'isConnected': false,
      'isFollowing': false,
    };
  }

  // Simulate GET /profile/{userId}/posts endpoint
  @override
  Future<List<Post>> getPosts({
    required String targetUserId,
    int page = 1,
    int size = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    print('Mock API: GET /profile/$targetUserId/posts?page=$page&size=$size');
    
    final allPosts = targetUserId == 'coach_001'
        ? [
            {"id": "post_1", "imageUrl": "https://picsum.photos/200/200?random=11"},
            {"id": "post_2", "imageUrl": "https://picsum.photos/200/200?random=12"},
            {"id": "post_3", "imageUrl": "https://picsum.photos/200/200?random=13"},
            {"id": "post_4", "imageUrl": "https://picsum.photos/200/200?random=14"},
            {"id": "post_5", "imageUrl": "https://picsum.photos/200/200?random=15"},
            {"id": "post_6", "imageUrl": "https://picsum.photos/200/200?random=16"},
          ]
        : [
            {"id": "post_1", "imageUrl": "https://picsum.photos/200/200?random=1"},
            {"id": "post_2", "imageUrl": "https://picsum.photos/200/200?random=2"},
            {"id": "post_3", "imageUrl": "https://picsum.photos/200/200?random=3"},
            {"id": "post_4", "imageUrl": "https://picsum.photos/200/200?random=4"},
            {"id": "post_5", "imageUrl": "https://picsum.photos/200/200?random=5"},
            {"id": "post_6", "imageUrl": "https://picsum.photos/200/200?random=6"},
          ];
    
    final start = (page - 1) * size;
    final end = start + size;
    final paginatedPosts = allPosts.skip(start).take(size).toList();
    
    return paginatedPosts.map((e) => Post.fromJson(e)).toList();
  }

  // Simulate GET /profile/{userId}/achievements endpoint
  @override
  Future<List<Achievement>> getAchievements({
    required String userId,
    int page = 1,
    int size = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    print('Mock API: GET /profile/$userId/achievements?page=$page&size=$size');
    
    final allAchievements = [
      {
        "id": "ach_1",
        "title": "National Championship",
        "subtitle": "Won the national championship in basketball",
        "imageUrl": "https://i.pravatar.cc/100?img=1",
        "date": "2022-12-15T00:00:00Z"
      },
      {
        "id": "ach_2",
        "title": "MVP Award",
        "subtitle": "Awarded as the most valuable player in the league",
        "imageUrl": "https://i.pravatar.cc/100?img=2",
        "date": "2023-05-20T00:00:00Z"
      },
      {
        "id": "ach_3",
        "title": "All-Star Selection",
        "subtitle": "Selected for the All-Star team",
        "imageUrl": "https://i.pravatar.cc/100?img=3",
        "date": "2023-08-10T00:00:00Z"
      },
      {
        "id": "ach_4",
        "title": "Golden Boot",
        "subtitle": "Top scorer of the season",
        "imageUrl": "https://i.pravatar.cc/100?img=4",
        "date": "2023-11-30T00:00:00Z"
      },
    ];
    
    final start = (page - 1) * size;
    final paginatedAchievements = allAchievements.skip(start).take(size).toList();
    
    return paginatedAchievements.map((e) => Achievement.fromJson(e)).toList();
  }

  // Simulate GET /profile/{userId}/analyzed-videos endpoint
  Future<List<AnalyzedVideoReport>> _getAnalyzedVideos(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Mock API: GET /profile/$userId/analyzed-videos');
    
    final videoId = userId == 'coach_001' ? 18 : 6;
    return [
      AnalyzedVideoReport(
        id: 'vid_1',
        thumbnailUrl: 'https://picsum.photos/400/200?random=$videoId',
        duration: '17:45',
        speed: '3990/6000',
        distance: '6h/8h',
        calories: '156/900kcal',
      ),
    ];
  }

  // Simulate GET /profile/{userId}/interests endpoint
  @override
  Future<List<Interest>> getInterests({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    print('Mock API: GET /profile/$userId/interests?page=$page&size=$pageSize');
    
    final allInterests = userId == 'coach_001'
        ? [
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
          ]
        : [
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
          ];
    
    final start = (page - 1) * pageSize;
    final paginatedInterests = allInterests.skip(start).take(pageSize).toList();
    
    return paginatedInterests.map((e) => Interest.fromJson(e)).toList();
  }

  // Simulate GET /profile/{userId}/opportunities endpoint
  @override
  Future<List<Opportunity>> getOpportunities({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    print('Mock API: GET /profile/$userId/opportunities?page=$page&size=$pageSize');
    
    if (userId == 'coach_001') {
      return [
        Opportunity(id: 'opp_1', imageUrl: 'https://picsum.photos/200/200?random=14'),
        Opportunity(id: 'opp_2', imageUrl: 'https://picsum.photos/200/200?random=15'),
      ];
    }
    
    return [];
  }

  // Simulate GET /profile/{userId}/courses endpoint
  @override
  Future<List<Course>> getCourses({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    print('Mock API: GET /profile/$userId/courses?page=$page&size=$pageSize');
    
    if (userId == 'coach_001') {
      return [
        Course(id: 'course_1', imageUrl: 'https://picsum.photos/200/200?random=16'),
        Course(id: 'course_2', imageUrl: 'https://picsum.photos/200/200?random=17'),
      ];
    }
    
    return [];
  }

  // Simulate GET /profile/{userId}/user-specific-data endpoint
  Future<Map<String, dynamic>> _getUserSpecificData(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Mock API: GET /profile/$userId/user-specific-data');
    
    if (userId == 'coach_001') {
      return {
        'opportunities': await getOpportunities(userId: userId),
        'courses': await getCourses(userId: userId),
        'coachData': CoachSpecificData(
          specializedSport: 'Football',
          yearsOfExperience: 5,
        ),
        'playerData': null,
        'scoutData': null,
        'clubData': null,
        'instituteData': null,
        'otherData': null,
      };
    }
    
    // Default player data
    return {
      'opportunities': null,
      'courses': null,
      'playerData': PlayerSpecificData(
        position: 'Striker',
        height: '180',
        weight: '75',
        preferredFoot: 'Shooting, Heading, Passing',
        age: '27',
        specializedSport: 'Football',
        yearsOfExperience: 5,
      ),
      'coachData': null,
      'scoutData': null,
      'clubData': null,
      'instituteData': null,
      'otherData': null,
    };
  }

  @override
  Future<Achievement> createAchievement({
    required String title,
    required String subtitle,
    required String imageUrl,
    required DateTime date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    print('Mock API: POST /achievements');
    return Achievement(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
      date: date,
    );
  }

  @override
  Future<Achievement> updateAchievement({
    required String achievementId,
    required String title,
    required String subtitle,
    required String imageUrl,
    required DateTime date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    print('Mock API: PUT /achievements/$achievementId');
    return Achievement(
      id: achievementId,
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
      date: date,
    );
  }

  @override
  Future<void> deleteAchievement(String achievementId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Mock API: DELETE /achievements/$achievementId');
  }

  @override
  Future<void> toggleFollow(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Mock API: POST /profile/$userId/follow');
  }

  @override
  Future<void> toggleConnect(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Mock API: POST /profile/$userId/connect');
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Mock API: PUT /profile with data: $updateData');
    
    // Return updated profile by fetching it again
    return getMyProfile();
  }
}