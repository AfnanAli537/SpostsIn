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

  PostsRemoteDataSourceImpl({required this.apiClient});

  DioException _badResponse(Response response) => DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

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

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        return items.map((json) => PostModel.fromJson(json)).toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
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
      final sportId = sportEnum != null ? EnumMapper.getSportId(sportEnum) : null;

      final formData = FormData.fromMap({
        'Title': title,
        'Description': description,
        'SportTypeId': sportId,
        if (mediaUrl != null) 'MediaFile': await MultipartFile.fromFile(mediaUrl),
      });

      final response = await apiClient.post(Endpoints.postPost, data: formData);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
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

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        return {
          'likes': items.map((json) => UserLists.fromJson(json)).toList(),
          'hasNextPage': response.data['hasNextPage'] ?? false,
        };
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
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

      if (response.statusCode == 200) {
        return PaginatedCommentsResponse.fromJson(response.data);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> addComment({required String postId, required String text}) async {
    try {
      final url = Endpoints.putComment.replaceFirst('{id}', postId);
      final response = await apiClient.post(url, data: jsonEncode(text));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> editComment({required String commentId, required String text}) async {
    try {
      final url = Endpoints.editComment.replaceFirst('{commentId}', commentId);
      final response = await apiClient.put(url, data: {'text': text});

      if (response.statusCode != 200) {
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
      final url = Endpoints.deletComment
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
  }) async {
    try {
      final response = await apiClient.get(
        Endpoints.allPosts,
        params: {'targetUserId': userId, 'page': page, 'size': pageSize},
      );

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        return items.map((json) => PostModel.fromJson(json)).toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
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
        if (mediaFile != null) 'MediaFile': await MultipartFile.fromFile(mediaFile),
      });

      final url = Endpoints.putPost.replaceFirst('{id}', postId);
      final response = await apiClient.put(url, data: formData);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }

      log('✅ Post updated successfully');
    } on DioException catch (e) {
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

      log('✅ Post deleted successfully');
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }
}