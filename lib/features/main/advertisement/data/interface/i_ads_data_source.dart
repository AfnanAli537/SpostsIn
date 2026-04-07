import 'package:sports_in/features/main/advertisement/model/ad_model.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';
// import 'package:sports_in/features/main/home/data/model/user_model.dart';

abstract class IAdsDataSource {
  // ─── Feed ──────────────────────────────────────────────────────────────────
  Future<PaginatedAdsResponse> getAdsFeed({int page = 1, int size = 10});

  // ─── CRUD ──────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> createAd({
    required String title,
    required String description,
    String? mediaFilePath,
    required double price,
    String? actionUrl,
    String? actionText,
    required DateTime startDate,
    required DateTime endDate,
    required int sportTypeId,
    double videoDuration,
    List<int> targetAudiences,
  });

  Future<void> updateAd({
    required String adId,
    required String title,
    required String description,
    String? mediaFilePath,
    required double price,
    String? actionUrl,
    String? actionText,
    required DateTime startDate,
    required DateTime endDate,
    int? sportTypeId,
    double videoDuration,
    List<int> targetAudiences,
  });

  Future<void> deleteAd({required String adId});

  Future<AdModel> getAdById({required String adId});

  // ─── Status ────────────────────────────────────────────────────────────────
  Future<void> toggleAdStatus({required String adId});

  // ─── User ads ──────────────────────────────────────────────────────────────
  Future<PaginatedAdsResponse> getUserAds({
    String? userId,
    bool? isActive,
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  });

  // ─── Dashboard ─────────────────────────────────────────────────────────────
  Future<AdDashboardModel> getDashboard({required String adId});

  // ─── Tracking ──────────────────────────────────────────────────────────────
  Future<void> logAdClick({required String adId});

  Future<void> sendAdProgress({
    required String adId,
    required double watchedTime,
    required bool isWatched,
    required double zoomScale,
  });

  // ─── Like ──────────────────────────────────────────────────────────────────
  Future<void> likeAd({required String adId});

  Future<Map<String, dynamic>> getAdLikes({
    required String adId,
    required int pageNumber,
    int pageSize = 20,
  });

  // ─── Comments ──────────────────────────────────────────────────────────────
  Future<PaginatedCommentsResponse> getAdComments({
    required String adId,
    int pageNumber = 1,
    int pageSize = 10,
  });

  Future<void> addAdComment({required String adId, required String text});

  Future<void> editAdComment({
    required String commentId,
    required String text,
  });

  Future<void> deleteAdComment({
    required String adId,
    required String commentId,
  });
}