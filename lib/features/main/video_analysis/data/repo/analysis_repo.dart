import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/video_analysis/data/interface/i_analysis_data_source.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Abstract
// ─────────────────────────────────────────────────────────────────────────────

abstract class IAnalysisRepo {
  Future<AnalyzedUsersPage> getMyAnalyzedUsers({int page = 1, int size = 10});

  Future<AnalysisListPage> getTargetAnalyses({
    required String targetUserId,
    bool? isPaid,
    int page = 1,
    int size = 10,
  });

  /// Other user's self-analyses — /api/Analysis/my-self-analyses?userId=
  Future<AnalysisListPage> getMySelfAnalyses({
    required String targetUserId,
    int page = 1,
    int size = 10,
  });

  Future<AnalysisListPage> searchLibrary({
    String? term,
    String? type,
    int page = 1,
    int size = 10,
  });

  Future<AnalysisListPage> searchPublic({
    String? term,
    String? type,
    int page = 1,
    int size = 10,
  });

  Future<AnalysisReportModel> getReport(String id);

  Future<void> deleteAnalysis(String id);
}

// ─────────────────────────────────────────────────────────────────────────────
// Implementation
// ─────────────────────────────────────────────────────────────────────────────

@LazySingleton(as: IAnalysisRepo)
class AnalysisRepo implements IAnalysisRepo {
  final IAnalysisDataSource _dataSource;

  AnalysisRepo(this._dataSource);

  @override
  Future<AnalyzedUsersPage> getMyAnalyzedUsers({
    int page = 1,
    int size = 10,
  }) async {
    try {
      return await _dataSource.getMyAnalyzedUsers(page: page, size: size);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AnalysisListPage> getTargetAnalyses({
    required String targetUserId,
    bool? isPaid,
    int page = 1,
    int size = 10,
  }) async {
    try {
      return await _dataSource.getTargetAnalyses(
        targetUserId: targetUserId,
        isPaid: isPaid,
        page: page,
        size: size,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AnalysisListPage> getMySelfAnalyses({
    required String targetUserId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      return await _dataSource.getMySelfAnalyses(
        targetUserId: targetUserId,
        page: page,
        size: size,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AnalysisListPage> searchLibrary({
    String? term,
    String? type,
    int page = 1,
    int size = 10,
  }) async {
    try {
      return await _dataSource.searchLibrary(
        term: term,
        type: type,
        page: page,
        size: size,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AnalysisListPage> searchPublic({
    String? term,
    String? type,
    int page = 1,
    int size = 10,
  }) async {
    try {
      return await _dataSource.searchPublic(
        term: term,
        type: type,
        page: page,
        size: size,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AnalysisReportModel> getReport(String id) async {
    try {
      return await _dataSource.getReport(id);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteAnalysis(String id) async {
    try {
      await _dataSource.deleteAnalysis(id);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }
}