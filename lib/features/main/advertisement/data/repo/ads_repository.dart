import 'package:injectable/injectable.dart';
import 'package:sports_in/features/main/advertisement/data/interface/i_ads_data_source.dart';
import 'package:sports_in/features/main/advertisement/model/ad_model.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';
// import 'package:sports_in/features/main/home/data/model/user_model.dart';

@injectable
class AdsRepositoryImpl {
  final IAdsDataSource _dataSource;

  AdsRepositoryImpl(this._dataSource);

  // ─── Feed ──────────────────────────────────────────────────────────────────

  Future<PaginatedAdsResponse> getAdsFeed({
    int page = 1,
    int size = 10,
  }) async {
    return await _dataSource.getAdsFeed(page: page, size: size);
  }

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
    double videoDuration = 0,
    List<int> targetAudiences = const [],
  }) async {
    return await _dataSource.createAd(
      title: title,
      description: description,
      mediaFilePath: mediaFilePath,
      price: price,
      actionUrl: actionUrl,
      actionText: actionText,
      startDate: startDate,
      endDate: endDate,
      sportTypeId: sportTypeId,
      videoDuration: videoDuration,
      targetAudiences: targetAudiences,
    );
  }

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
    double videoDuration = 0,
    List<int> targetAudiences = const [],
  }) async {
    return await _dataSource.updateAd(
      adId: adId,
      title: title,
      description: description,
      mediaFilePath: mediaFilePath,
      price: price,
      actionUrl: actionUrl,
      actionText: actionText,
      startDate: startDate,
      endDate: endDate,
      sportTypeId: sportTypeId,
      videoDuration: videoDuration,
      targetAudiences: targetAudiences,
    );
  }

  Future<void> deleteAd({required String adId}) async {
    return await _dataSource.deleteAd(adId: adId);
  }

  Future<AdModel> getAdById({required String adId}) async {
    return await _dataSource.getAdById(adId: adId);
  }

  // ─── Status ────────────────────────────────────────────────────────────────

  Future<void> toggleAdStatus({required String adId}) async {
    return await _dataSource.toggleAdStatus(adId: adId);
  }

  // ─── User ads ──────────────────────────────────────────────────────────────

  Future<PaginatedAdsResponse> getUserAds({
    String? userId,
    bool? isActive,
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  }) async {
    return await _dataSource.getUserAds(
      userId: userId,
      isActive: isActive,
      searchTerm: searchTerm,
      sportTypeId: sportTypeId,
      page: page,
      size: size,
    );
  }

  // ─── Dashboard ─────────────────────────────────────────────────────────────

  Future<AdDashboardModel> getDashboard({required String adId}) async {
    return await _dataSource.getDashboard(adId: adId);
  }

  // ─── Tracking ──────────────────────────────────────────────────────────────

  Future<void> logAdClick({required String adId}) async {
    return await _dataSource.logAdClick(adId: adId);
  }

  Future<void> sendAdProgress({
    required String adId,
    required double watchedTime,
    required bool isWatched,
    required double zoomScale,
  }) async {
    return await _dataSource.sendAdProgress(
      adId: adId,
      watchedTime: watchedTime,
      isWatched: isWatched,
      zoomScale: zoomScale,
    );
  }

  // ─── Like ──────────────────────────────────────────────────────────────────

  Future<void> likeAd({required String adId}) async {
    return await _dataSource.likeAd(adId: adId);
  }

  Future<Map<String, dynamic>> getAdLikes({
    required String adId,
    required int pageNumber,
    int pageSize = 20,
  }) async {
    return await _dataSource.getAdLikes(
      adId: adId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  // ─── Comments ──────────────────────────────────────────────────────────────

  Future<PaginatedCommentsResponse> getAdComments({
    required String adId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    return await _dataSource.getAdComments(
      adId: adId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<void> addAdComment({
    required String adId,
    required String text,
  }) async {
    return await _dataSource.addAdComment(adId: adId, text: text);
  }

  Future<void> editAdComment({
    required String commentId,
    required String text,
  }) async {
    return await _dataSource.editAdComment(commentId: commentId, text: text);
  }

  Future<void> deleteAdComment({
    required String adId,
    required String commentId,
  }) async {
    return await _dataSource.deleteAdComment(
        adId: adId, commentId: commentId);
  }
}