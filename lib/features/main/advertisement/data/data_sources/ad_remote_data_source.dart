import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/main/advertisement/data/interface/i_ads_data_source.dart';
import 'package:sports_in/features/main/advertisement/model/ad_model.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';
import 'package:sports_in/features/main/home/data/model/user_model.dart';

@LazySingleton(as: IAdsDataSource)
class AdRemoteDataSource implements IAdsDataSource {
  final ApiClient _apiClient;

  AdRemoteDataSource(this._apiClient);

  DioException _badResponse(Response response) => DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

  // ─── Feed ──────────────────────────────────────────────────────────────────

  @override
  Future<PaginatedAdsResponse> getAdsFeed({int page = 1, int size = 10}) async {
    try {
      log('Fetching ads feed - page: $page, size: $size');
      final response = await _apiClient.get(
        Endpoints.adsFeed,
        params: {'page': page, 'size': size},
      );
      if (response.statusCode == 200) {
        log('Ads feed loaded successfully');
        return PaginatedAdsResponse.fromJson(response.data);
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Create ────────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> createAd({
    required String title,
    required String description,
    String? mediaFilePath,
    required double price,
    String? actionUrl,
    String? actionText,
    required DateTime startDate,
    required DateTime endDate,
    required int sportTypeId,
    double videoDuration = 0,
    List<int> targetAudiences = const [],
  }) async {
    try {
      log('Creating new ad: $title');
      final formData = FormData.fromMap({
        'Title': title,
        'Description': description,
        'Price': price,
        if (actionUrl != null && actionUrl.isNotEmpty) 'ActionUrl': actionUrl,
        if (actionText != null && actionText.isNotEmpty)
          'ActionText': actionText,
        'StartDate': startDate.toIso8601String(),
        'EndDate': endDate.toIso8601String(),
        'SportTypeId': sportTypeId,
        'VideoDuration': videoDuration,
        if (mediaFilePath != null)
          'MediaFile': await MultipartFile.fromFile(mediaFilePath),
        for (final audience in targetAudiences) 'TargetAudiences': audience,
      });

      final response =
          await _apiClient.post(Endpoints.createAd, data: formData);
      log('Create ad status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Ad created successfully');
        return response.data as Map<String, dynamic>;
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Update ────────────────────────────────────────────────────────────────

  @override
  Future<void> updateAd({
    required String adId,
    required String title,
    required String description,
    String? mediaFilePath,
    required double price,
    String? actionUrl,
    String? actionText,
    required DateTime startDate,
    required DateTime endDate,
    int? sportTypeId,
    double videoDuration = 0,
    List<int> targetAudiences = const [],
  }) async {
    try {
      log('Updating ad: $adId');
      final formData = FormData.fromMap({
        'Title': title,
        'Description': description,
        'Price': price,
        if (actionUrl != null && actionUrl.isNotEmpty) 'ActionUrl': actionUrl,
        if (actionText != null && actionText.isNotEmpty)
          'ActionText': actionText,
        'StartDate': startDate.toIso8601String(),
        'EndDate': endDate.toIso8601String(),
        if (sportTypeId != null) 'SportTypeId': sportTypeId,
        'VideoDuration': videoDuration,
        if (mediaFilePath != null)
          'MediaFile': await MultipartFile.fromFile(mediaFilePath),
        for (final audience in targetAudiences) 'TargetAudiences': audience,
      });

      final url = Endpoints.updateAd.replaceFirst('{id}', adId);
      final response = await _apiClient.put(url, data: formData);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
      log('Ad updated successfully');
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Delete ────────────────────────────────────────────────────────────────

  @override
  Future<void> deleteAd({required String adId}) async {
    try {
      log('Deleting ad: $adId');
      final url = Endpoints.deleteAd.replaceFirst('{id}', adId);
      final response = await _apiClient.delete(url);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
      log('Ad deleted successfully');
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Get by id ─────────────────────────────────────────────────────────────

  @override
  Future<AdModel> getAdById({required String adId}) async {
    try {
      log('Fetching ad details for ID: $adId');
      final url = Endpoints.getAdById.replaceFirst('{id}', adId);
      final response = await _apiClient.get(url);
      if (response.statusCode == 200) {
        log('Ad details loaded successfully');
        _silentLogClick(adId);
        return AdModel.fromJson(response.data);
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Toggle status ─────────────────────────────────────────────────────────

  @override
  Future<void> toggleAdStatus({required String adId}) async {
    try {
      log('Toggling ad status: $adId');
      final url = Endpoints.toggleAdStatus.replaceFirst('{id}', adId);
      final response = await _apiClient.post(url);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
      log('Ad status toggled: ${response.data}');
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── User ads ──────────────────────────────────────────────────────────────

  @override
  Future<PaginatedAdsResponse> getUserAds({
    String? userId,
    bool? isActive,
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      log('Fetching user ads - page: $page');
      final response = await _apiClient.get(
        Endpoints.userAds,
        params: {
          if (userId != null) 'userId': userId,
          if (isActive != null) 'isActive': isActive,
          if (searchTerm != null && searchTerm.isNotEmpty)
            'searchTerm': searchTerm,
          if (sportTypeId != null) 'sportTypeId': sportTypeId,
          'page': page,
          'size': size,
        },
      );
      if (response.statusCode == 200) {
        log('User ads loaded successfully');
        return PaginatedAdsResponse.fromJson(response.data);
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Dashboard ─────────────────────────────────────────────────────────────

  @override
  Future<AdDashboardModel> getDashboard({required String adId}) async {
    try {
      log('Fetching dashboard for ad: $adId');
      final response = await _apiClient.get(
        Endpoints.adsDashboard,
        params: {'adId': adId},
      );
      if (response.statusCode == 200) {
        log('Dashboard loaded successfully');
        return AdDashboardModel.fromJson(response.data);
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Click ─────────────────────────────────────────────────────────────────

  @override
  Future<void> logAdClick({required String adId}) async {
    try {
      final url = Endpoints.logAdClick.replaceFirst('{id}', adId);
      await _apiClient.post(url);
    } on DioException catch (e) {
      log('Failed to log ad click: ${e.message}');
    }
  }

  void _silentLogClick(String adId) {
    logAdClick(adId: adId).catchError((_) {});
  }

  // ─── Progress ──────────────────────────────────────────────────────────────

  @override
  Future<void> sendAdProgress({
    required String adId,
    required double watchedTime,
    required bool isWatched,
    required double zoomScale,
  }) async {
    try {
      final url = Endpoints.sendAdProgress.replaceFirst('{id}', adId);
      await _apiClient.post(url, data: {
        'watchedTime': watchedTime,
        'isWatched': isWatched,
        'zoomScale': zoomScale,
      });
    } on DioException catch (e) {
      log('Failed to send ad progress: ${e.message}');
    }
  }

  // ─── Like ──────────────────────────────────────────────────────────────────

  @override
  Future<void> likeAd({required String adId}) async {
    try {
      final url = Endpoints.likeAd.replaceFirst('{id}', adId);
      final response = await _apiClient.post(url);
      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Likers ────────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getAdLikes({
    required String adId,
    required int pageNumber,
    int pageSize = 20,
  }) async {
    try {
      log('Fetching ad likers - page: $pageNumber');
      final url = Endpoints.getAdLikers.replaceFirst('{id}', adId);
      final response = await _apiClient.get(
        url,
        params: {'page': pageNumber, 'size': pageSize},
      );
      if (response.statusCode == 200) {
        log('Ad likers loaded successfully');
        final List items = response.data['items'] ?? [];
        return {
          'likes': items.map((j) => UserLists.fromJson(j)).toList(),
          'hasNextPage': response.data['hasNextPage'] ?? false,
        };
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Comments ──────────────────────────────────────────────────────────────

  @override
  Future<PaginatedCommentsResponse> getAdComments({
    required String adId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      log('Fetching ad comments - page: $pageNumber');
      final url = Endpoints.getAdComments.replaceFirst('{id}', adId);
      final response = await _apiClient.get(
        url,
        params: {'page': pageNumber, 'size': pageSize},
      );
      if (response.statusCode == 200) {
        return PaginatedCommentsResponse.fromJson(response.data);
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> addAdComment({
    required String adId,
    required String text,
  }) async {
    try {
      final url = Endpoints.addAdComment.replaceFirst('{id}', adId);
      final response = await _apiClient.post(url, data: jsonEncode(text));
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> editAdComment({
    required String commentId,
    required String text,
  }) async {
    try {
      final url =
          Endpoints.editAdComment.replaceFirst('{commentId}', commentId);
      final response = await _apiClient.put(url, data: {'text': text});
      if (response.statusCode != 200) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteAdComment({
    required String adId,
    required String commentId,
  }) async {
    try {
      final url =
          Endpoints.deleteAdComment.replaceFirst('{commentId}', commentId);
      final response = await _apiClient.delete(url);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }
}