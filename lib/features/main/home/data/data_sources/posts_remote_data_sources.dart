import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/mappers/enum_mapper.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/main/home/data/interface/post_interface.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/features/main/home/data/model/user_model.dart';

@LazySingleton(as: PostsRepository)
class PostsRemoteDataSourceImpl implements PostsRepository {
  final ApiClient apiClient;
  DioException _badResponse(Response response) => DioException(
    requestOptions: response.requestOptions,
    response: response,
    type: DioExceptionType.badResponse,
  );
  PostsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getAllPosts({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiClient.get(
        Endpoints.allPosts,
        params: {'page': pageNumber, 'size': pageSize},
      );

      log(' Response status: ${response.statusCode}');
      log(' Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        return items.map((json) => PostModel.fromJson(json)).toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      log(' Dio Error: ${e.message}');
      log(' Error Response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioError(e);
    } catch (e) {
      log(' Unknown Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> likePost({required String postId}) async {
    try {
      final url = Endpoints.putLike.replaceFirst('{id}', postId);
      final response = await apiClient.post(url);

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
      log("${response.statusCode}=================================");
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> uploadPost({
    required String description,
    String? mediaUrl,
    required String sport,
    required String title,
  }) async {
    try {
      final sportEnum = EnumMapper.fromLabel(EnumMapper.sportLabels(), sport);

      final sportId = sportEnum != null
          ? EnumMapper.getSportId(sportEnum)
          : null;
      final formData = FormData.fromMap({
        'Title': title,
        'Description': description,
        'SportTypeId': sportId,
        if (mediaUrl != null)
          'MediaFile': await MultipartFile.fromFile(mediaUrl),
      });

      final response = await apiClient.post(Endpoints.postPost, data: formData);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }

      log("${response.statusCode}==============");
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
@override
Future<PostModel> getPostById({required String postId}) async {
  try {
    final url = Endpoints.getPostById.replaceFirst('{id}', postId);
    final response = await apiClient.get(url);
 
    log('getPostById status: ${response.statusCode}');
    log('getPostById data: ${response.data}');
 
    if (response.statusCode == 200) {
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    }
 
    throw ApiErrorHandler.handleDioError(_badResponse(response));
  } on DioException catch (e) {
    log('Dio Error getPostById: ${e.message}');
    throw ApiErrorHandler.handleDioError(e);
  } catch (e) {
    log('Unknown Error getPostById: $e');
    rethrow;
  }
}
  @override
  Future<Map<String, dynamic>> getLikes({
    required String postId,
    required int pageNumber,
    int pageSize = 20,
  }) async {
    try {
      final url = Endpoints.getLikes.replaceFirst('{id}', postId);
      final response = await apiClient.get(
        url,
        params: {'page': pageNumber, 'size': pageSize},
      );

      log(' Response status: ${response.statusCode}');
      log(' Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        final List<UserLists> likes = items
            .map((json) => UserLists.fromJson(json))
            .toList();

        return {
          'likes': likes,
          'hasNextPage': response.data['hasNextPage'] ?? false,
        };
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      log(' Dio Error: ${e.message}');
      log(' Error Response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioError(e);
    } catch (e) {
      log(' Unknown Error: $e');
      rethrow;
    }
  }

  @override
  Future<PaginatedCommentsResponse> getComments({
    required String postId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final url = Endpoints.getComments.replaceFirst('{id}', postId);
      final response = await apiClient.get(
        url,
        params: {'page': pageNumber, 'size': pageSize},
      );
      log('${pageNumber}=========');
      if (response.statusCode == 200) {
        log("${response.data}========================");
        return PaginatedCommentsResponse.fromJson(response.data);
      } else {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> addComment({
    required String postId,
    required String text,
  }) async {
    try {
      final url = Endpoints.putComment.replaceFirst('{id}', postId);
      final response = await apiClient.post(url, data: jsonEncode(text));

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("${response.data}=======================");
      } else {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> editComment({
    required String commentId,
    required String text,
  }) async {
    try {
      final url = Endpoints.editComment.replaceFirst('{commentId}', commentId);
      final response = await apiClient.put(url, data: {'text': text});

      if (response.statusCode == 200) {
        log('Edit Response: ${response.data}');
      } else {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      final url = Endpoints.deleteComment
          .replaceFirst('{id}', postId)
          .replaceFirst('{commentId}', commentId);

      final response = await apiClient.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<List<PostModel>> getUserPosts({
    required String userId,
    required int page,
    required int pageSize,
    bool onlyInactive = false,
  }) async {
    try {
      final response = await apiClient.get(
        Endpoints.allPosts,
        params: {'targetUserId': userId, 'page': page, 'size': pageSize, 'onlyInactive':onlyInactive},
      );

      log(' User Posts Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        return items.map((json) => PostModel.fromJson(json)).toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      log(' Error fetching user posts: ${e.message}');
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> updatePost({
    required String postId,
    required String title,
    required String description,
    required int sportTypeId,
    String? mediaFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'Title': title,
        'Description': description,
        'SportTypeId': sportTypeId,
        if (mediaFile != null)
          'MediaFile': await MultipartFile.fromFile(mediaFile),
      });

      final url = Endpoints.putPost.replaceFirst('{id}', postId);
      final response = await apiClient.put(url, data: formData);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }

      log(' Post updated successfully');
    } on DioException catch (e) {
      log(' Error updating post: ${e.message}');
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deletePost({required String postId}) async {
    try {
      final url = Endpoints.deletePost.replaceFirst('{id}', postId);
      final response = await apiClient.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }

      log(' Post deleted successfully');
    } on DioException catch (e) {
      log(' Error deleting post: ${e.message}');
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> togglePostVisibility({required String postId}) async {
    try {
      final url = Endpoints.postToggleVisibility.replaceFirst('{id}', postId);
      final response = await apiClient.patch(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }

      log(' Post visibility toggled successfully');
    } on DioException catch (e) {
      log(' Error toggling post visibility: ${e.message}');
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> sendPostProgress({
    required String postId,
    required double watchedTime,
    required bool isWatched,
    required double zoomScale,
  }) async {
    try {
      final url = Endpoints.postProgress.replaceFirst('{id}', postId);
      await apiClient.post(url, data: {
        'watchedTime': watchedTime,
        'isWatched': isWatched,
        'zoomScale': zoomScale,
      });
    } on DioException catch (e) {
      log('Failed to send post progress: ${e.message}');
    }
  }
}