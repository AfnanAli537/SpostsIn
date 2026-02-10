import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/mappers/enum_mapper.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/core/utils/helper/gender_helper.dart';
import 'package:sports_in/generated/l10n.dart';
import '../interface/i_profile_data_source.dart';
import '../../model/profile_model.dart';

@LazySingleton(as: IProfileDataSource)
class ApiProfileDataSource implements IProfileDataSource {
  final ApiClient _apiClient;
  final SharedPref _prefs;

  ApiProfileDataSource(this._apiClient, this._prefs);

  // Helper to get current user ID
  String? get _currentUserId => _prefs.getUserId();

  @override
  Future<ProfileModel> getMyProfile() async {
    try {
      final userId = _currentUserId;
      if (userId == null || userId.isEmpty) {
        throw Exception('User not logged in');
      }

      return await getUserProfile(userId);
    } on DioException catch (e) {
      final errorKey = ApiErrorHandler.handleDioErrorKey(e);
      throw ApiException(message: 'failed to fetch profile', key: errorKey);
    }
  }

  @override
  Future<ProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.getProfile.replaceAll('{userId}', userId),
      );

      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;

        // Convert API response to ProfileModel
        final profile = _apiResponseToProfile(json);

        // Fetch all related data in parallel
        final results = await Future.wait([
          getPosts(targetUserId: userId, page: 1, size: 3),
          getAchievements(userId: userId, page: 1, size: 3),
          _getAnalyzedVideos(userId), // Mock for now
          getInterests(userId: userId, page: 1, pageSize: 6),
          getOpportunities(userId: userId, page: 1, pageSize: 10),
          getCourses(userId: userId, page: 1, pageSize: 10), // Mock for now
        ]);

        final posts = results[0] as List<Post>;
        final achievements = results[1] as List<Achievement>;
        final analyzedVideos = results[2] as List<AnalyzedVideoReport>;
        final interests = results[3] as List<Interest>;
        final opportunities = results[4] as List<Opportunity>;
        final courses = results[5] as List<Course>;

        return profile.copyWith(
          posts: posts,
          achievements: achievements,
          analyzedVideos: analyzedVideos,
          interests: interests,
          opportunities: opportunities,
          courses: courses,
        );
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      final errorKey = ApiErrorHandler.handleDioErrorKey(e);
      throw ApiException(
        message: 'failed to fetch user\'s profile',
        key: errorKey,
      );
    }
  }

  /// Convert API response to ProfileModel
  ProfileModel _apiResponseToProfile(Map<String, dynamic> json) {
    final userType = _parseUserType(json['userType']);
    final isOwner = json['isOwner']; // ✅ Get isOwner from API
    final connectionStatus = json['connectionStatus']?.toString();
    final gender = json['gender'];
    // Extract sports from array
    final sportsList = json['sports'] as List?;
    final sportsText = sportsList != null && sportsList.isNotEmpty
        ? sportsList.first.toString()
        : null;
    return ProfileModel(
      id: json['userId'] ?? '',
      name: json['fullName'] ?? 'Unknown User',
      profileImage: json['profilePictureUrl'],
      role: _getRoleText(userType, json['specialization'], sportsList),
      description: json['bio'] ?? '',
      userType: userType,
      stats: ProfileStats(
        followers: json['followersCount']?.toString() ?? '0',
        following: json['followingCount']?.toString() ?? '0',
        connections: json['connectionsCount']?.toString() ?? '0',
        analyzedPeople: json['analyzedPeopleCount']?.toString() ?? '0',
      ),
      posts: [],
      achievements: [],
      analyzedVideos: [],
      interests: [],
      opportunities: null,
      courses: null,
      playerData: userType == UserType.player
          ? _buildPlayerData(json, sportsText)
          : null,
      coachData: userType == UserType.coach
          ? _buildCoachData(json, sportsText)
          : null,
      scoutData: userType == UserType.scout
          ? _buildScoutData(json, sportsText)
          : null,
      clubData: userType == UserType.club
          ? _buildClubData(json, sportsList)
          : null,
      instituteData: userType == UserType.institute
          ? _buildInstituteData(json)
          : null,
      otherData: userType == UserType.other ? _buildOtherData(json) : null,
      isConnected: connectionStatus == 'Connected',
      isFollowing: json['isFollowedByMe'] == true,
      isOwner: isOwner, // ✅ Set isOwner from API
    );
  }

  UserType _parseUserType(String? type) {
    switch (type?.toLowerCase()) {
      case 'player':
        return UserType.player;
      case 'coach':
        return UserType.coach;
      case 'scout':
        return UserType.scout;
      case 'club':
        return UserType.club;
      case 'institute':
        return UserType.institute;
      case 'other':
      default:
        return UserType.other;
    }
  }

  String _getRoleText(UserType type, String? specialization, List? sports) {
    // Priority: specialization > sports[0] > empty
    final sportText =
        specialization ??
        (sports != null && sports.isNotEmpty ? sports.first.toString() : '');

    switch (type) {
      case UserType.player:
        return sportText.isNotEmpty ? 'Athlete - $sportText' : 'Athlete';
      case UserType.coach:
        return sportText.isNotEmpty ? 'Coach - $sportText' : 'Coach';
      case UserType.scout:
        return sportText.isNotEmpty ? 'Scout - $sportText' : 'Scout';
      case UserType.club:
        return 'Club';
      case UserType.institute:
        return 'Institute';
      case UserType.other:
        return 'User';
    }
  }

  PlayerSpecificData _buildPlayerData(
    Map<String, dynamic> json,
    String? sportsText,
  ) {
    return PlayerSpecificData(
      position: json['position'],
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      preferredFoot: null,
      age: json['age']?.toString(),
      specializedSport: sportsText ?? json['specialization'],
      yearsOfExperience: json['yearsOfExperience'],
      gender: json['gender'],
    );
  }

  CoachSpecificData _buildCoachData(
    Map<String, dynamic> json,
    String? sportsText,
  ) {
    return CoachSpecificData(
      specializedSport: sportsText ?? json['specialization'],
      yearsOfExperience: json['yearsOfExperience'],
      certifications: null,
      age: json['age']?.toString(),
      gender: json['gender'],
    );
  }

  ScoutSpecificData _buildScoutData(
    Map<String, dynamic> json,
    String? sportsText,
  ) {
    S? s;
    try {
      s = S.current;
    } catch (_) {
      s = null;
    }
    final genderEnum = json['gender'] != null
        ? EnumMapper.fromLabel(EnumMapper.genderLabels(s), json['gender'])
        : null;
    final genderId = genderEnum != null
        ? EnumMapper.getGenderId(genderEnum)
        : null;

    return ScoutSpecificData(
      specializedSport: sportsText ?? json['specialization'],
      yearsOfExperience: json['yearsOfExperience'],
      organization: null,
      gender: genderId,
    );
  }

  ClubSpecificData _buildClubData(Map<String, dynamic> json, List? sportsList) {
    // For clubs, store all sports (up to 6)
    final sports =
        sportsList?.take(6).map((s) => s.toString()).join(', ') ?? '';

    return ClubSpecificData(
      location: null,
      foundedYear: json['foundationDate'],
      sport: sports.isNotEmpty ? sports : json['specialization'],
    );
  }

  InstituteSpecificData _buildInstituteData(Map<String, dynamic> json) {
    return InstituteSpecificData(
      location: null,
      foundedYear: json['foundationDate'],
      accreditation: null,
      industry: json['industry'],
    );
  }

  OtherSpecificData _buildOtherData(Map<String, dynamic> json) {
    return OtherSpecificData(gender: json['gender'], customData: null);
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _apiClient.put(
        Endpoints.updateProfile,
        data: updateData,
      );

      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;

        // ✅ Check if API returned profile or just message
        if (json.containsKey('message') && !json.containsKey('userId')) {
          // API only returned success message, fetch the updated profile
          final userId = _currentUserId;
          if (userId == null) throw Exception('User not logged in');

          return await getUserProfile(userId); // ✅ Fetch complete profile
        } else {
          // API returned full profile
          return _apiResponseToProfile(json);
        }
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      final errorKey = ApiErrorHandler.handleDioErrorKey(e);
      throw ApiException(message: 'failed to update profile', key: errorKey);
    }
  }

  @override
  Future<List<Post>> getPosts({
    required String targetUserId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        Endpoints.allPosts,
        params: {'targetUserId': targetUserId, 'page': page, 'size': size},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>? ?? [];
        print("posts: $items>>>>>>>>>>>>>>>>>>>>");
        return items.map((json) {
          return Post(
            id: json['id'] ?? '',
            imageUrl: json['mediaUrl'] ?? '',
            title: json['title'],
          );
        }).toList();
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } catch (e) {
      print('Error loading posts: $e');
      return []; // Return empty list on error
    }
  }

  @override
  Future<List<Achievement>> getAchievements({
    required String userId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        Endpoints.getAchievements.replaceAll('{userId}', userId),
        params: {'page': page, 'size': size},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>? ?? [];

        return items.map((json) {
          return Achievement(
            id: json['id'] ?? '',
            title: json['title'] ?? '',
            subtitle: json['description'] ?? '',
            imageUrl: json['mediaUrl'] ?? '',
            date: json['achievementDate'] != null
                ? DateTime.parse(json['achievementDate'])
                : null,
          );
        }).toList();
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } catch (e) {
      print('Error loading achievements: $e');
      return []; // Return empty list on error
    }
  }

  @override
  Future<Achievement> createAchievement({
    required String title,
    required String subtitle,
    required String imageUrl,
    required DateTime date,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'Title': title,
        'Description': subtitle,
        'AchievementDate': date.toIso8601String(),
      });

      // If imageUrl is a local file path, add it as multipart
      if (imageUrl.isNotEmpty && File(imageUrl).existsSync()) {
        formData.files.add(
          MapEntry(
            'MediaFile',
            await MultipartFile.fromFile(
              imageUrl,
              filename: imageUrl.split('/').last,
            ),
          ),
        );
      }

      final response = await _apiClient.post(
        Endpoints.createAchievement,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = response.data;
        return Achievement(
          id: json['id'] ?? '',
          title: json['title'] ?? title,
          subtitle: json['description'] ?? subtitle,
          imageUrl: json['mediaUrl'] ?? imageUrl,
          date: DateTime.parse(
            json['achievementDate'] ?? date.toIso8601String(),
          ),
        );
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      final errorKey = ApiErrorHandler.handleDioErrorKey(e);
      throw ApiException(
        message: 'failed to create achievement',
        key: errorKey,
      );
    }
  }

  @override
  Future<Achievement> updateAchievement({
    required String achievementId,
    required String title,
    required String subtitle,
    required String imageUrl,
    required DateTime date,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'Title': title,
        'Description': subtitle,
        'AchievementDate': date.toIso8601String(),
      });

      // If imageUrl is a local file path, add it as multipart
      if (imageUrl.isNotEmpty && File(imageUrl).existsSync()) {
        formData.files.add(
          MapEntry(
            'MediaFile',
            await MultipartFile.fromFile(
              imageUrl,
              filename: imageUrl.split('/').last,
            ),
          ),
        );
      }

      final response = await _apiClient.put(
        Endpoints.updateAchievement.replaceAll('{id}', achievementId),
        data: formData,
      );

      if (response.statusCode == 200) {
        final json = response.data;
        return Achievement(
          id: json['id'] ?? achievementId,
          title: json['title'] ?? title,
          subtitle: json['description'] ?? subtitle,
          imageUrl: json['mediaUrl'] ?? imageUrl,
          date: DateTime.parse(
            json['achievementDate'] ?? date.toIso8601String(),
          ),
        );
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      final errorKey = ApiErrorHandler.handleDioErrorKey(e);
      throw ApiException(
        message: 'failed to update achievement',
        key: errorKey,
      );
    }
  }

  @override
  Future<void> deleteAchievement(String achievementId) async {
    try {
      final response = await _apiClient.delete(
        Endpoints.deleteAchievement.replaceAll('{id}', achievementId),
        // params: {'id': achievementId},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      final errorKey = ApiErrorHandler.handleDioErrorKey(e);
      throw ApiException(
        message: 'failed to delete achievement',
        key: errorKey,
      );
    }
  }

  @override
  Future<List<Opportunity>> getOpportunities({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        Endpoints.myActiveOpportunities,
        params: {'page': page, 'pageSize': pageSize},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>? ?? [];

        return items.map((json) => Opportunity.fromJson(json)).toList();
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } catch (e) {
      print('Error loading opportunities: $e');
      return []; // Return empty list on error
    }
  }

  @override
  Future<List<Course>> getCourses({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    // Keep mock data for now as per requirements
    await Future.delayed(const Duration(milliseconds: 350));
    print('Mock API: GET /profile/$userId/courses?page=$page&size=$pageSize');

    return [
      Course(
        id: 'course_1',
        imageUrl: 'https://picsum.photos/200/200?random=16',
      ),
      Course(
        id: 'course_2',
        imageUrl: 'https://picsum.photos/200/200?random=17',
      ),
    ];
  }

  @override
  Future<List<Interest>> getInterests({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    // Use actual user IDs as specified
    final interestUserIds = [
      "07f4e4d8-0315-48fc-82a0-89e37b67648a",
      "3bdbe490-f7a7-4a1b-9d60-6fb1ef5d8fbf",
      "8ee439e7-c504-4407-9ec0-24fb7b406623",
    ];

    try {
      final interests = <Interest>[];

      for (final interestUserId in interestUserIds) {
        try {
          final response = await _apiClient.get(
            Endpoints.getProfile.replaceAll('{userId}', interestUserId),
          );

          if (response.statusCode == 200) {
            final json = response.data as Map<String, dynamic>;

            // Don't show own profile in interests
            if (json['isOwner'] == true || json['userId'] == _currentUserId) {
              continue;
            }

            final userType = _parseUserType(json['userType']);
            final sportsList = json['sports'] as List?;

            interests.add(
              Interest(
                id: json['userId'] ?? '',
                name: json['fullName'] ?? 'Unknown',
                role: _getRoleText(
                  userType,
                  json['specialization'],
                  sportsList,
                ),
                profileImage: json['profilePictureUrl'] ?? '',
                isConnected: json['connectionStatus'] == 'Connected',
                isFollowing: json['isFollowedByMe'] == true,
              ),
            );
          }
        } catch (e) {
          print('Error loading interest user $interestUserId: $e');
          continue;
        }
      }

      return interests;
    } catch (e) {
      print('Error loading interests: $e');
      return [];
    }
  }

  Future<List<AnalyzedVideoReport>> _getAnalyzedVideos(String userId) async {
    // Keep mock data for now as per requirements
    await Future.delayed(const Duration(milliseconds: 300));
    print('Mock API: GET /profile/$userId/analyzed-videos');

    return [
      AnalyzedVideoReport(
        id: 'vid_1',
        thumbnailUrl: 'https://picsum.photos/400/200?random=18',
        duration: '17:45',
        speed: '3990/6000',
        distance: '6h/8h',
        calories: '156/900kcal',
      ),
    ];
  }

  @override
  Future<void> toggleFollow(String targetUserId) async {
    try {
      final response = await _apiClient.post(
        Endpoints.toggleFollow.replaceAll('{targetId}', targetUserId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      final errorKey = ApiErrorHandler.handleDioErrorKey(e);
      throw ApiException(message: 'failed to toggle follow', key: errorKey);
    }
  }

  @override
  Future<void> toggleConnect(String receiverId) async {
    try {
      final response = await _apiClient.post(
        Endpoints.toggleConnect,
        data: {'receiverId': receiverId},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      final errorKey = ApiErrorHandler.handleDioErrorKey(e);
      throw ApiException(
        message: 'failed to request connection',
        key: errorKey,
      );
    }
  }
}
