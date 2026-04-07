import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/chat_bot/data/interface/chatbot_interface.dart';
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';

@lazySingleton
class ChatbotRepository {
  final ChatbotRemoteDataSource _remoteDataSource;

  ChatbotRepository({required ChatbotRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  ///✅ ─── Ask ───────────────────────────────────────────────────────────────
  Future<Either<ApiException, AskResponse>> ask({
    required String question,
    required String sessionId,
  }) async {
    try {
      final response = await _remoteDataSource.ask(
        question: question,
        sessionId: sessionId,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Get Sessions ───────────────────────────────────────────────────────
  Future<Either<ApiException, List<ChatSession>>> getSessions() async {
    try {
      final sessions = await _remoteDataSource.getSessions();
      return Right(sessions);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Get Messages ───────────────────────────────────────────────────────
  Future<Either<ApiException, List<ChatMessage>>> getMessages({
    required String sessionId,
  }) async {
    try {
      final messages = await _remoteDataSource.getMessages(
        sessionId: sessionId,
      );
      return Right(messages);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Delete Session ─────────────────────────────────────────────────────
  Future<Either<ApiException, Unit>> deleteSession({
    required String sessionId,
  }) async {
    try {
      await _remoteDataSource.deleteSession(sessionId: sessionId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Rename Session ─────────────────────────────────────────────────────
  Future<Either<ApiException, Unit>> renameSession({
    required String sessionId,
    required String newName,
  }) async {
    try {
      await _remoteDataSource.renameSession(
        sessionId: sessionId,
        newName: newName,
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}