import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/mappers/enum_mapper.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import '../interface/i_profile_data_source.dart';
import '../../model/profile_model.dart';

@LazySingleton(as: IProfileDataSource)
class ApiProfileDataSource implements IProfileDataSource {
  final ApiClient _apiClient;
  final SharedPref _prefs;

  ApiProfileDataSource(this._apiClient, this._prefs);

  String? get _currentUserId => _prefs.getUserId();

  DioException _badResponse(Response response) => DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

  // ── Profile ─────────────────────────────────────────────────────────────────

  @override
  Future<ProfileModel> getMyProfile() async {
    try {
      final userId = _currentUserId;
      if (userId == null || userId.isEmpty) {
        throw ApiException(
          message: 'User not logged in',
          key: StringKeys.unauthorized,
        );
      }
      return await getUserProfile(userId);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
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
        final profile = _apiResponseToProfile(json);

        final results = await Future.wait([
          getPosts(targetUserId: userId, page: 1, size: 3),
          getAchievements(userId: userId, page: 1, size: 3),
          _getAnalyzedVideos(userId),
          (profile.userType == UserType.coach ||
                  profile.userType == UserType.scout ||
                  profile.userType == UserType.club)
              ? getOpportunities(userId: userId, page: 1, pageSize: 3)
              : Future.value(<Opportunity>[]),
          (profile.userType == UserType.club ||
                  profile.userType == UserType.coach ||
                  profile.userType == UserType.institute)
              ? getCourses(userId: userId, page: 1, pageSize: 10)
              : Future.value(<Course>[]),
          getInterests(userId: userId, page: 1, pageSize: 6),
        ]);

        return profile.copyWith(
          posts: results[0] as List<Post>,
          achievements: results[1] as List<Achievement>,
          analyzedVideos: results[2] as List<AnalyzedVideoReport>,
          opportunities: results[3] as List<Opportunity>,
          courses: results[4] as List<Course>,
          interests: results[5] as List<Interest>,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _apiClient.put(
        Endpoints.updateProfile,
        data: FormData.fromMap(updateData),
      );

      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        if (json.containsKey('message') && !json.containsKey('userId')) {
          final userId = _currentUserId;
          if (userId == null) {
            throw ApiException(
              message: 'User not logged in',
              key: StringKeys.unauthorized,
            );
          }
          return await getUserProfile(userId);
        }
        return _apiResponseToProfile(json);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ── Posts ────────────────────────────────────────────────────────────────────

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
        return items
            .map((json) => Post(
                  id: json['id'] ?? '',
                  imageUrl: json['mediaUrl'] ?? '',
                  title: json['title'],
                ))
            .toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('Error loading posts: $e');
      return [];
    }
  }

  // ── Achievements ─────────────────────────────────────────────────────────────

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
        return items
            .map((json) => Achievement(
                  id: json['id'] ?? '',
                  title: json['title'] ?? '',
                  subtitle: json['description'] ?? '',
                  imageUrl: json['mediaUrl'] ?? '',
                  date: json['achievementDate'] != null
                      ? DateTime.parse(json['achievementDate'])
                      : null,
                ))
            .toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('Error loading achievements: $e');
      return [];
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

      if (imageUrl.isNotEmpty && File(imageUrl).existsSync()) {
        formData.files.add(MapEntry(
          'MediaFile',
          await MultipartFile.fromFile(imageUrl,
              filename: imageUrl.split('/').last),
        ));
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
          date: DateTime.parse(json['achievementDate'] ?? date.toIso8601String()),
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
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

      if (imageUrl.isNotEmpty && File(imageUrl).existsSync()) {
        formData.files.add(MapEntry(
          'MediaFile',
          await MultipartFile.fromFile(imageUrl,
              filename: imageUrl.split('/').last),
        ));
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
          date: DateTime.parse(json['achievementDate'] ?? date.toIso8601String()),
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteAchievement(String achievementId) async {
    try {
      final response = await _apiClient.delete(
        Endpoints.deleteAchievement.replaceAll('{id}', achievementId),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ── Opportunities ────────────────────────────────────────────────────────────

  @override
  Future<List<Opportunity>> getOpportunities({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        Endpoints.getOpportunities.replaceAll('{targetUserId}', userId),
        params: {'page': page, 'pageSize': pageSize},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>? ?? [];
        return items.map((json) => Opportunity.fromJson(json)).toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('Error loading opportunities: $e');
      return [];
    }
  }

  // ── Courses ──────────────────────────────────────────────────────────────────

  @override
  Future<List<Course>> getCourses({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        Endpoints.createdCourses,
        params: {'page': page, 'size': pageSize},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>? ?? [];
        return items
            .map((json) => Course(
                  id: json['id'] ?? '',
                  imageUrl: json['thumbnailUrl'] ?? '',
                  title: json['title'] ?? '',
                  description: json['description'],
                  price: json['price']?.toDouble(),
                  isFree: json['isFree'] ?? false,
                  lessonsCount: json['lessonsCount'] ?? 0,
                  enrolledCount: json['enrolledUsersCount'] ?? 0,
                ))
            .toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } catch (e) {
      debugPrint('Error loading courses: $e');
      return [];
    }
  }

  // ── Interests ────────────────────────────────────────────────────────────────
// Replace the getInterests method in api_profile_data_source.dart with this:

  @override
  Future<List<Interest>> getInterests({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
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

            if (json['isOwner'] == true || json['userId'] == userId) continue;

            final userType = _parseUserType(json['userType']);
            final sportsList = EnumMapper.sportIdsToLabels(
              (json['sports'] as List<dynamic>?)
                      ?.map((id) => id as int)
                      .toList() ??
                  [],
            );
            final sport = sportsList.isNotEmpty ? sportsList.first : null;

            interests.add(Interest(
              id: json['userId'] ?? '',
              name: json['fullName'] ?? 'Unknown',
              role: _getRoleText(userType, json['specialization'], sport),
              profileImage: json['profilePictureUrl'] ?? '',
              // Store the raw string: null / "Pending" / "Accepted"
              connectionStatus: json['connectionStatus'] as String?,
              isFollowing: json['isFollowedByMe'] == true,
            ));
          }
        } on DioException catch (e) {
          debugPrint('Error loading interest user $interestUserId: $e');
          continue;
        }
      }

      return interests;
    } catch (e) {
      debugPrint('Error loading interests: $e');
      return [];
    }
  }
  // ── Follow ───────────────────────────────────────────────────────────────────

  @override
  Future<void> toggleFollow(String targetUserId) async {
    try {
      final response = await _apiClient.post(
        Endpoints.toggleFollow.replaceAll('{targetId}', targetUserId),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ── Connection ───────────────────────────────────────────────────────────────

  /// POST /api/Social/connect
  @override
  Future<void> sendConnectionRequest(String receiverId) async {
    try {
      final response = await _apiClient.post(
        Endpoints.sendConnectionRequest,
        data: {'receiverId': receiverId},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  /// DELETE /api/Social/connect/{targetId}
  @override
  Future<void> removeContact(String targetId) async {
    try {
      final response = await _apiClient.delete(
        Endpoints.removeContact.replaceAll('{targetId}', targetId),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  /// PUT /api/Social/respond-connection
  @override
  Future<void> respondConnection({
    required String senderId,
    required String status,
  }) async {
    try {
      final response = await _apiClient.put(
        Endpoints.respondConnection,
        data: {'senderId': senderId, 'status': status},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  /// GET /api/Social/connection-requests
@override
Future<({List<ConnectionRequest> items, bool hasNextPage})> getConnectionRequests({
  int pageNumber = 1,
  int pageSize = 20,
}) async {
  try {
    final response = await _apiClient.get(
      Endpoints.connectionRequests,
      params: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>? ?? [])
          .map((json) => ConnectionRequest.fromJson(json as Map<String, dynamic>))
          .toList();
      final hasNextPage = data['hasNextPage'] as bool? ?? false;
      return (items: items, hasNextPage: hasNextPage);
    }
    throw ApiErrorHandler.handleDioError(_badResponse(response));
  } on DioException catch (e) {
    throw ApiErrorHandler.handleDioError(e);
  }
}
 
  /// GET /api/Chat/contacts
  @override
  Future<List<ContactItem>> getContacts() async {
    try {
      final response = await _apiClient.get(Endpoints.contacts);
      if (response.statusCode == 200) {
        final items = response.data as List<dynamic>? ?? [];
        return items
            .map((json) => ContactItem.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ── Analyzed Videos (mock) ───────────────────────────────────────────────────

  Future<List<AnalyzedVideoReport>> _getAnalyzedVideos(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
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

  // ── Helpers ──────────────────────────────────────────────────────────────────

  ProfileModel _apiResponseToProfile(Map<String, dynamic> json) {
    final userType = _parseUserType(json['userType']);
    final connectionStatus = json['connectionStatus'] as String?;
    final sportsList = json['sports'] as List?;
    final sportsText = sportsList != null && sportsList.isNotEmpty
        ? EnumMapper.sportIdToLabel((sportsList.first as int))
        : json['specialization'];

    return ProfileModel(
      id: json['userId'] ?? '',
      name: json['fullName'] ?? 'Unknown User',
      profileImage: json['profilePictureUrl'],
      role: _getRoleText(userType, json['specialization'], sportsText),
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
      coachData:
          userType == UserType.coach ? _buildCoachData(json, sportsText) : null,
      scoutData:
          userType == UserType.scout ? _buildScoutData(json, sportsText) : null,
      clubData:
          userType == UserType.club ? _buildClubData(json, sportsList) : null,
      instituteData:
          userType == UserType.institute ? _buildInstituteData(json) : null,
      otherData: userType == UserType.other ? _buildOtherData(json) : null,
      // Store raw connectionStatus string — null / "Pending" / "Accepted"
      connectionStatus: connectionStatus,
      isFollowing: json['isFollowedByMe'] == true,
      isOwner: json['isOwner'] ?? false,
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
      default:
        return UserType.other;
    }
  }

  String _getRoleText(UserType type, String? specialization, String? sport) {
    final sportText = specialization ?? sport;
    switch (type) {
      case UserType.player:
        return (sportText != null && sportText.isNotEmpty)
            ? 'Athlete - $sportText'
            : 'Athlete';
      case UserType.coach:
        return (sportText != null && sportText.isNotEmpty)
            ? 'Coach - $sportText'
            : 'Coach';
      case UserType.scout:
        return (sportText != null && sportText.isNotEmpty)
            ? 'Scout - $sportText'
            : 'Scout';
      case UserType.club:
        return 'Club';
      case UserType.institute:
        return 'Institute';
      case UserType.other:
        return 'User';
    }
  }

  PlayerSpecificData _buildPlayerData(
          Map<String, dynamic> json, String? sportsText) =>
      PlayerSpecificData(
        position: json['position'],
        height: json['height']?.toString(),
        weight: json['weight']?.toString(),
        preferredFoot: null,
        age: json['age']?.toString(),
        specializedSport: sportsText ?? json['specialization'],
        yearsOfExperience: json['yearsOfExperience'],
        gender: json['gender'],
      );

  CoachSpecificData _buildCoachData(
          Map<String, dynamic> json, String? sportsText) =>
      CoachSpecificData(
        specializedSport: json['specialization'] ?? sportsText,
        yearsOfExperience: json['yearsOfExperience'],
        certifications: null,
        age: json['age']?.toString(),
        gender: json['gender'],
      );

  ScoutSpecificData _buildScoutData(
          Map<String, dynamic> json, String? sportsText) =>
      ScoutSpecificData(
        specializedSport: json['specialization'] ?? sportsText,
        yearsOfExperience: json['yearsOfExperience'],
        gender: json['gender'],
        organization: null,
      );

  ClubSpecificData _buildClubData(Map<String, dynamic> json, List? sportsList) {
    final sports = EnumMapper.sportIdsToLabels(
      (json['sports'] as List<dynamic>?)?.map((id) => id as int).toList() ?? [],
    );
    return ClubSpecificData(
      location: null,
      foundedYear: json['foundationDate'],
      sport: sports.isNotEmpty ? sports : json['specialization'],
    );
  }

  InstituteSpecificData _buildInstituteData(Map<String, dynamic> json) =>
      InstituteSpecificData(
        location: null,
        foundedYear: json['foundationDate'],
        accreditation: null,
        industry: json['industry'],
      );

  OtherSpecificData _buildOtherData(Map<String, dynamic> json) =>
      OtherSpecificData(gender: json['gender'], customData: null);
}