import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';

@lazySingleton
class ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepository({required ChatRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  ///✅ ─── Get All Chats ──────────────────────────────────────────────
  Future<Either<ApiException, PaginatedChatsResponse>> getAllChats({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getAllChats(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Get Contacts ───────────────────────────────────────────────
  Future<Either<ApiException, List<ContactModel>>> getContacts() async {
    try {
      final response = await _remoteDataSource.getContacts();
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Search Chats ──────────────────────────────────────────────
  Future<Either<ApiException, PaginatedSearchResponse>> chatSearch({
    required String searchTerm,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _remoteDataSource.chatSearch(
        searchTerm: searchTerm,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Send Message ──────────────────────────────────────────────
  Future<Either<ApiException, MessageModel>> sendMessage({
    required String content,
    String? receiverId,
    String? groupId,
    String? attachmentFile,
  }) async {
    try {
      final response = await _remoteDataSource.sendMessage(
        content: content,
        receiverId: receiverId,
        groupId: groupId,
        attachmentFile: attachmentFile,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Get Message History ───────────────────────────────────────
  Future<Either<ApiException, PaginatedMessagesResponse>> getAllMessages({
    String? targetUserId,
    String? groupId,
    int page = 1,
  }) async {
    try {
      final response = await _remoteDataSource.getChatHistory(
        targetUserId: targetUserId,
        groupId: groupId,
        page: page,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Create Group ──────────────────────────────────────────────
  Future<Either<ApiException, ChatModel>> createGroup({
    required String title,
    required List<String> memberIds,
    String? description,
    String? groupPhoto,
  }) async {
    try {
      final response = await _remoteDataSource.createGroup(
        title: title,
        memberIds: memberIds,
        description: description,
        groupPhoto: groupPhoto,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Edit Message ──────────────────────────────────────────────
  Future<Either<ApiException, MessageModel>> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    try {
      final response = await _remoteDataSource.editMessage(
        messageId: messageId,
        newContent: newContent,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Delete Message ────────────────────────────────────────────
  Future<Either<ApiException, Unit>> deleteMessage({
    required String messageId,
  }) async {
    try {
      await _remoteDataSource.deleteMessage(messageId: messageId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}
