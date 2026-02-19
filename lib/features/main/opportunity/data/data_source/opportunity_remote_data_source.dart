import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/main/opportunity/data/interface/opportunity_interface.dart';
import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
import 'package:sports_in/core/network/api_client.dart';

@LazySingleton(as: OpportunityInterface)
class OpportunityRemoteDataSourceImpl implements OpportunityInterface {
  final ApiClient apiClient;

  OpportunityRemoteDataSourceImpl({required this.apiClient});

  DioException _badResponse(Response response) => DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

  @override
  Future<List<OpportunityModel>> getOpportunities({
    required int pageNumber,
    int pageSize = 10,
    String? searchTerm,
    int? sportTypeId,
  }) async {
    try {
      final params = <String, dynamic>{
        'page': pageNumber,
        'size': pageSize,
        if (searchTerm != null && searchTerm.isNotEmpty) 'searchTerm': searchTerm,
        if (sportTypeId != null) 'sportTypeId': sportTypeId,
      };

      final response = await apiClient.get(Endpoints.getOpportunity, params: params);
      log('📦 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        return items.map((json) => OpportunityModel.fromJson(json)).toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> postOpportunity({
    required String title,
    required String description,
    required String requirements,
    required String endDate,
    required int sportTypeId,
    String? mediaFile,
    String? mediaUrl,
  }) async {
    try {
      final formData = FormData.fromMap({
        'Title': title,
        'Description': description,
        'Requirements': requirements,
        'EndDate': endDate,
        'SportTypeId': sportTypeId,
        if (mediaFile != null) 'MediaFile': await MultipartFile.fromFile(mediaFile),
        if (mediaUrl != null && mediaFile == null) 'MediaUrl': mediaUrl,
      });

      final response = await apiClient.post(Endpoints.postOpportunity, data: formData);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }

      log('✅ Opportunity created successfully');
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<DetailsModel> opportunityDetails({required String opportunityID}) async {
    try {
      final url = Endpoints.opportunityDetails.replaceFirst('{id}', opportunityID);
      final response = await apiClient.get(url);
      log('📦 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return DetailsModel.fromJson(response.data);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> applyOpportunity({required String opportunityID}) async {
    try {
      final url = Endpoints.applyOpportunity.replaceFirst('{id}', opportunityID);
      final response = await apiClient.post(url);

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }

      log('✅ Application submitted successfully');
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<ApplicantsResponseModel> getApplicants({
    required int pageNumber,
    int pageSize = 10,
    required String opportunityID,
    String? status = 'pending',
  }) async {
    try {
      final url = Endpoints.getApplicants.replaceFirst('{id}', opportunityID);
      final params = <String, dynamic>{
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        if (status != null && status.isNotEmpty) 'status': status,
      };

      final response = await apiClient.get(url, params: params);
      log('📦 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return ApplicantsResponseModel.fromJson(response.data);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<ApplicantsResponseModel> acceptOrRejectApplicant({
    required String applicationId,
    required String status,
  }) async {
    try {
      final url = Endpoints.detectAcceptOrReject.replaceFirst('{applicationId}', applicationId);
      final response = await apiClient.patch(url, params: {'status': status});

      if (response.statusCode == 200 || response.statusCode == 204) {
        log('✅ Application $status successfully');

        if (response.data != null && response.data is Map<String, dynamic>) {
          return ApplicantsResponseModel.fromJson(response.data);
        }

        return ApplicantsResponseModel(
          items: [],
          totalCount: 0,
          pageNumber: 1,
          pageSize: 10,
          totalPages: 0,
          hasNextPage: false,
          hasPreviousPage: false,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<PaginatedOpportunitiesResponse> getMyOpportunities({
    required bool showActive,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final endpoint = showActive ? Endpoints.getActiveOp : Endpoints.getInActiveOp;
      final response = await apiClient.get(
        endpoint,
        params: {'page': page, 'pageSize': pageSize},
      );

      if (response.statusCode == 200) {
        return PaginatedOpportunitiesResponse.fromJson(response.data);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> updateOpportunity({
    required String opportunityId,
    required String title,
    required String description,
    required String requirements,
    required DateTime endDate,
    required int sportTypeId,
    String? mediaFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'Title': title,
        'Description': description,
        'Requirements': requirements,
        'EndDate': endDate.toIso8601String(),
        'SportTypeId': sportTypeId,
        if (mediaFile != null) 'MediaFile': await MultipartFile.fromFile(mediaFile),
      });

      final url = Endpoints.editOpportunity.replaceFirst('{id}', opportunityId);
      final response = await apiClient.put(url, data: formData);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }

      log('✅ Opportunity updated successfully');
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteOpportunity({required String opportunityId}) async {
    try {
      final url = Endpoints.deleteOpportunity.replaceFirst('{id}', opportunityId);
      final response = await apiClient.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }

      log('✅ Opportunity deleted successfully');
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }
}