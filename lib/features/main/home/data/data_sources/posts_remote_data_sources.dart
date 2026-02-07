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

  @override
  Future<List<PostModel>> getAllPosts({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiClient.get(
        // ✅ Use apiClient
        Endpoints.allPosts,
        params: {'pageNumber': pageNumber, 'pageSize': pageSize},
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
      final response = await apiClient.post(url);

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
log("${response.statusCode}=================================");
      // ✅ Return updated post data
      // return PostModel.fromJson(response.data['post']);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioErrorKey(e);
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
    print("🔍 Input sport value: '$sport'");
    
    final sportEnum = EnumMapper.fromLabel(EnumMapper.sportLabels(), sport);
    print("🔍 Sport enum: $sportEnum");
    
    final sportId = sportEnum != null ? EnumMapper.getSportId(sportEnum) : null;
    print("🔍 Sport ID: $sportId");

    // ✅ Use FormData instead of JSON
    final formData = FormData.fromMap({
      'Title': title,
      'Description': description,
      'SportTypeId': sportId,
      // Don't include MediaFile if it's null - server expects file upload
      if (mediaUrl != null) 'MediaFile': await MultipartFile.fromFile(mediaUrl),
    });

    final response = await apiClient.post(
      Endpoints.postPost,
      data: formData, // ✅ Send FormData
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    }
    
    log("${response.statusCode}==============");
    // return PostModel.fromJson(response.data['post']);
    
  } on DioException catch (e) {
    throw ApiErrorHandler.handleDioErrorKey(e);
  } catch (e) {
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

      print('📦 Response status: ${response.statusCode}');
      print('📦 Response data: ${response.data}');

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
  Future<PaginatedCommentsResponse> getComments({
    required String postId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final url = Endpoints.getComments.replaceFirst('{id}', postId);
      final response = await apiClient.get(
        url,
        params: {'pageNumber': pageNumber, 'pageSize': pageSize},
      );
log('${pageNumber}=========');
//inspector almost 
      if (response.statusCode == 200) {
        log("${response.data}========================");
        return PaginatedCommentsResponse.fromJson(response.data);
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioErrorKey(e);
    }
  }

  @override
  Future<void> addComment({
    required String postId,
    required String text,
  }) async {
    try {
      final url = Endpoints.putComment.replaceFirst('{id}', postId);
      final response = await apiClient.post(
        url,
        // data: '$text',
        data: jsonEncode(text),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("${response.data}=======================");
        // return CommentModel.fromJson(response.data);
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioErrorKey(e);
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
        print('Edit Response: ${response.data}');

        // لو الـ response فيه wrapper
        // if (response.data is Map && response.data.containsKey('comment')) {
        //   return CommentModel.fromJson(response.data['comment']);
        // }

        // لو الـ response direct
        // return CommentModel.fromJson(response.data);
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioErrorKey(e);
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
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioErrorKey(e);
    }
  }
}
