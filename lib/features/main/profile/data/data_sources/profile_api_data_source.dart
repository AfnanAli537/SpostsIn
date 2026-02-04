import 'package:dio/dio.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/main/profile/data/interface/i_profile_data_source.dart';

import '../../model/profile_model.dart';
// import 'package:injectable/injectable.dart';

// @LazySingleton(as: IProfileDataSource)
class ProfileApiDataSource implements IProfileDataSource {
  final ApiClient _apiClient;
  final SharedPref _sharedPref;

  ProfileApiDataSource(this._apiClient, this._sharedPref);

  @override
  Future<ProfileModel> getMyProfile() async {
    try {
      // final response = await _apiClient.get(Endpoints.getMyProfile);
      final response = await _apiClient.get(
        Endpoints.getProfile,
        params: {'userId': _sharedPref.getUserId()},
      );
      return ProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.getProfile,
        params: {'userId': userId},
      );
      return ProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
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
        Endpoints.getPosts,
        params: {
          'targetUserId': targetUserId,
          'page': page,
          'size': size,
        },
      );
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => Post.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
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
        Endpoints.getAchievements,
        params: {
          'userId': userId,
          'page': page,
          'size': size,
        },
      );
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => Achievement.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
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
      final response = await _apiClient.post(
        Endpoints.createAchievement,
        data: {
          'title': title,
          'subtitle': subtitle,
          'imageUrl': imageUrl,
          'date': date.toIso8601String(),
        },
      );
      return Achievement.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
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
      final response = await _apiClient.put(
        '${Endpoints.updateAchievement}/$achievementId',
        data: {
          'title': title,
          'subtitle': subtitle,
          'imageUrl': imageUrl,
          'date': date.toIso8601String(),
        },
      );
      return Achievement.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteAchievement(String achievementId) async {
    try {
      await _apiClient.delete('${Endpoints.deleteAchievement}/$achievementId');
    } on DioException catch (e) {
      throw _handleError(e);
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
        Endpoints.getOpportunities,
        params: {
          'userId': userId,
          'page': page,
          'pageSize': pageSize,
        },
      );
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => Opportunity.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<Course>> getCourses({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        Endpoints.getCourses,
        params: {
          'userId': userId,
          'page': page,
          'pageSize': pageSize,
        },
      );
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => Course.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<Interest>> getInterests({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        Endpoints.getInterests,
        params: {
          'userId': userId,
          'page': page,
          'pageSize': pageSize,
        },
      );
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => Interest.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> toggleFollow(String userId) async {
    try {
      await _apiClient.post(
        Endpoints.toggleFollow,
        data: {'userId': userId},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> toggleConnect(String userId) async {
    try {
      await _apiClient.post(
        Endpoints.toggleConnect,
        data: {'userId': userId},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _apiClient.put(
        Endpoints.getMyProfile,
        data: updateData,
      );
      return ProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    if (error.response != null) {
      final message = error.response?.data['message'] ?? 'An error occurred';
      return Exception(message);
    } else {
      return Exception('Network error: ${error.message}');
    }
  }
}