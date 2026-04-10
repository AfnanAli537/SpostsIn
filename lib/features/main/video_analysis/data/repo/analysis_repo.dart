import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/video_analysis/data/interface/i_analysis_data_source.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/model/create_analysis_response.dart';

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
Future<CreateAnalysisResponse> analyzeGoalkeeper({
    required String targetUserId,
    required String videoUrl,
    required double keeperHeightM,
  });

  Future<CreateAnalysisResponse> analyzePassing({
    required String targetUserId,
    required String videoUrl,
  });

  Future<CreateAnalysisResponse> analyzeDribbling({
    required String targetUserId,
    required String videoUrl,
  });

  Future<CreateAnalysisResponse> analyzeMatch({
    required String targetUserId,
    required String videoUrl,
  });

  Future<void> executePaidAnalysis(String gatewayTransactionId);
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
@override
  Future<CreateAnalysisResponse> analyzeGoalkeeper({
    required String targetUserId,
    required String videoUrl,
    required double keeperHeightM,
  }) async {
    try {
      return await _dataSource.analyzeGoalkeeper(
        targetUserId: targetUserId,
        videoUrl: videoUrl,
        keeperHeightM: keeperHeightM,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<CreateAnalysisResponse> analyzePassing({
    required String targetUserId,
    required String videoUrl,
  }) async {
    try {
      return await _dataSource.analyzePassing(
        targetUserId: targetUserId,
        videoUrl: videoUrl,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<CreateAnalysisResponse> analyzeDribbling({
    required String targetUserId,
    required String videoUrl,
  }) async {
    try {
      return await _dataSource.analyzeDribbling(
        targetUserId: targetUserId,
        videoUrl: videoUrl,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<CreateAnalysisResponse> analyzeMatch({
    required String targetUserId,
    required String videoUrl,
  }) async {
    try {
      return await _dataSource.analyzeMatch(
        targetUserId: targetUserId,
        videoUrl: videoUrl,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> executePaidAnalysis(String gatewayTransactionId) async {
    try {
      await _dataSource.executePaidAnalysis(gatewayTransactionId);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }
}