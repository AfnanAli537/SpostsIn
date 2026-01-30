import 'dart:async';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/main/home/data/interface/post_interface.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';
import 'package:sports_in/core/network/api_client.dart';

@LazySingleton(as: PostsRepository)
class PostsRemoteDataSourceImpl implements PostsRepository {
  final ApiClient apiClient;  // ✅ Use ApiClient

  PostsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getAllPosts({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiClient.get(  // ✅ Use apiClient
        Endpoints.allPosts,
        params: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );

      print('📦 Response status: ${response.statusCode}');
      print('📦 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        return items.map((json) => PostModel.fromJson(json)).toList();
      }

      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      print('❌ Error Response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioErrorKey(e);
    } catch (e) {
      print('❌ Unknown Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> likePost({required String postId}) async {
    try {
      final url = Endpoints.putLike.replaceFirst('{id}', postId);
      final response = await apiClient.put(url);  // ✅

      if (response.statusCode != 200) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioErrorKey(e);
    }
  }

  @override
  Future<void> addComment({
    required String postId,
    required String comment,
  }) async {
    try {
      final url = Endpoints.putComment.replaceFirst('{id}', postId);
      final response = await apiClient.put(  // ✅
        url,
        data: {'text': comment},
      );

      if (response.statusCode != 200) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioErrorKey(e);
    }
  }

  @override
  Future<void> uploadPost({
    required String title,
    required String description,
    required String mediaUrl,
  }) async {
    try {
      final response = await apiClient.post(  // ✅
        Endpoints.postPost,
        data: {
          'title': title,
          'description': description,
          'mediaUrl': mediaUrl,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioErrorKey(e);
    }
  }

  @override
  Future<void> editComment({
    required String commentId,
    required String comment,
  }) async {
    try {
      final url = Endpoints.editComment.replaceFirst('{commentId}', commentId);
      final response = await apiClient.put(  // ✅
        url,
        data: {'text': comment},
      );

      if (response.statusCode != 200) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioErrorKey(e);
    }
  }

  @override
  Future<void> deleteComment({required String commentId}) async {
    try {
      final url = Endpoints.deletComment.replaceFirst('{commentId}', commentId);
      final response = await apiClient.delete(url);  // ✅

      if (response.statusCode != 200) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioErrorKey(e);
    }
  }
}