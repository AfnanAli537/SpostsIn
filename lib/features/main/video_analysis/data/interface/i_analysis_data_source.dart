import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/model/create_analysis_response.dart';

abstract class IAnalysisDataSource {
  /// GET /api/Analysis/my-analyzed-users
  Future<AnalyzedUsersPage> getMyAnalyzedUsers({int page = 1, int size = 10});

  /// GET /api/Analysis/target-analyses/{targetUserId}
  Future<AnalysisListPage> getTargetAnalyses({
    required String targetUserId,
    bool? isPaid,
    int page = 1,
    int size = 10,
  });

  /// GET /api/Analysis/my-self-analyses?userId=
  Future<AnalysisListPage> getMySelfAnalyses({
    required String targetUserId,
    int page = 1,
    int size = 10,
  });

  /// GET /api/Analysis/search/library
  Future<AnalysisListPage> searchLibrary({
    String? term,
    String? type,
    int page = 1,
    int size = 10,
  });

  /// GET /api/Analysis/search/public
  Future<AnalysisListPage> searchPublic({
    String? term,
    String? type,
    int page = 1,
    int size = 10,
  });

  /// GET /api/Analysis/report/{id}
  Future<AnalysisReportModel> getReport(String id);

  /// DELETE /api/Analysis/{id}
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