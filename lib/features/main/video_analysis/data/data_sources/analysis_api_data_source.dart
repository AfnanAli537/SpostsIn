import 'package:injectable/injectable.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/features/main/video_analysis/data/interface/i_analysis_data_source.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/model/create_analysis_response.dart';

@LazySingleton(as: IAnalysisDataSource)
class AnalysisApiDataSource implements IAnalysisDataSource {
  final ApiClient _apiClient;

  AnalysisApiDataSource(this._apiClient);

  @override
  Future<AnalyzedUsersPage> getMyAnalyzedUsers({
    int page = 1,
    int size = 10,
  }) async {
    final response = await _apiClient.get(
      '/api/Analysis/my-analyzed-users',
      params: {'page': page, 'size': size},
    );
    return AnalyzedUsersPage.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AnalysisListPage> getTargetAnalyses({
    required String targetUserId,
    bool? isPaid,
    int page = 1,
    int size = 10,
  }) async {
    final response = await _apiClient.get(
      '/api/Analysis/target-analyses/$targetUserId',
      params: {
        if (isPaid != null) 'isPaid': isPaid,
        'page': page,
        'size': size,
      },
    );
    return AnalysisListPage.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AnalysisListPage> getMySelfAnalyses({
    required String targetUserId,
    int page = 1,
    int size = 10,
  }) async {
    final response = await _apiClient.get(
      '/api/Analysis/my-self-analyses',
      params: {'userId': targetUserId, 'page': page, 'size': size},
    );
    return AnalysisListPage.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AnalysisListPage> searchLibrary({
    String? term,
    String? type,
    int page = 1,
    int size = 10,
  }) async {
    final response = await _apiClient.get(
      '/api/Analysis/search/library',
      params: {
        if (term != null && term.isNotEmpty) 'term': term,
        if (type != null) 'type': type,
        'page': page,
        'size': size,
      },
    );
    return AnalysisListPage.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AnalysisListPage> searchPublic({
    String? term,
    String? type,
    int page = 1,
    int size = 10,
  }) async {
    final response = await _apiClient.get(
      '/api/Analysis/search/public',
      params: {
        if (term != null && term.isNotEmpty) 'term': term,
        if (type != null) 'type': type,
        'page': page,
        'size': size,
      },
    );
    return AnalysisListPage.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AnalysisReportModel> getReport(String id) async {
    final response = await _apiClient.get('/api/Analysis/report/$id');
    return AnalysisReportModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteAnalysis(String id) async {
    await _apiClient.delete('/api/Analysis/$id');
  }

@override
  Future<CreateAnalysisResponse> analyzeGoalkeeper({
    required String targetUserId,
    required String videoUrl,
    required double keeperHeightM,
  }) async {
    final response = await _apiClient.post(
      '/api/Analysis/analyze-drill',
      params: {'targetUserId': targetUserId},
      data: {
        'video_url': videoUrl,
        'keeper_height_m': keeperHeightM,
      },
    );
    return CreateAnalysisResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CreateAnalysisResponse> analyzePassing({
    required String targetUserId,
    required String videoUrl,
  }) async {
    final response = await _apiClient.post(
      '/api/Analysis/analyze-player',
      params: {'targetUserId': targetUserId},
      data: {'video_url': videoUrl},
    );
    return CreateAnalysisResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CreateAnalysisResponse> analyzeDribbling({
    required String targetUserId,
    required String videoUrl,
  }) async {
    final response = await _apiClient.post(
      '/api/Analysis/analyze-dribbling',
      params: {'targetUserId': targetUserId},
      data: {'video_url': videoUrl},
    );
    return CreateAnalysisResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CreateAnalysisResponse> analyzeMatch({
    required String targetUserId,
    required String videoUrl,
  }) async {
    final response = await _apiClient.post(
      '/api/Analysis/analyze-match',
      params: {'targetUserId': targetUserId},
      data: {'video_url': videoUrl},
    );
    return CreateAnalysisResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> executePaidAnalysis(String gatewayTransactionId) async {
    await _apiClient.post(
      '/api/Analysis/execute-paid-analysis/$gatewayTransactionId',
    );
  }
}