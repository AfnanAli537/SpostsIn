import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/notitification/data/interface/notifi_interface.dart';
import 'package:sports_in/features/notitification/data/model/notifi_model.dart';


@lazySingleton
class NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepository(
      {required NotificationRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  ///✅ ─── Get Notifications ───────────────────────────────────────────────────
  Future<Either<ApiException, PaginatedNotificationsResponse>>
      getNotifications({
    int pageNumber = 1,
    int pageSize = 20,
    String? category,
  }) async {
    try {
      final response = await _remoteDataSource.getNotifications(
        pageNumber: pageNumber,
        pageSize: pageSize,
        category: category,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Get Unread Count ────────────────────────────────────────────────────
  Future<Either<ApiException, int>> getUnreadCount() async {
    try {
      final count = await _remoteDataSource.getUnreadCount();
      return Right(count);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Mark As Read ────────────────────────────────────────────────────────
  Future<Either<ApiException, Unit>> markAsRead({required String id}) async {
    try {
      await _remoteDataSource.markAsRead(id: id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  ///✅ ─── Mark All As Read ────────────────────────────────────────────────────
  Future<Either<ApiException, Unit>> markAllAsRead() async {
    try {
      await _remoteDataSource.markAllAsRead();
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString(),));
    }
  }
}