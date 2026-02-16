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

  @override
  Future<List<OpportunityModel>> getOpportunities({
    required int pageNumber,
    int pageSize = 10,
    String? searchTerm,
    int? sportTypeId,
  }) async {
    try {
      final Map<String,dynamic>params = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };

      if (searchTerm != null && searchTerm.isNotEmpty) {
        params['searchTerm'] = searchTerm;
      }

      if (sportTypeId != null) {
        params['sportTypeId'] = sportTypeId;
      }

      final response = await apiClient.get(
        Endpoints.getOpportunity,
        params: params,
      );

      log('📦 Response status: ${response.statusCode}');
      log('📦 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        return items.map((json) => OpportunityModel.fromJson(json)).toList();
      }

      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    } on DioException catch (e) {
      log('❌ Dio Error: ${e.message}');
      log('❌ Error Response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioErrorKey(e);
    } catch (e) {
      log('❌ Unknown Error: $e');
      rethrow;
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
      log("🔍 Creating opportunity with sport type ID: $sportTypeId");

      final formData = FormData.fromMap({
        'Title': title,
        'Description': description,
        'Requirements': requirements,
        'EndDate': endDate,
        'SportTypeId': sportTypeId,
        if (mediaFile != null)
          'MediaFile': await MultipartFile.fromFile(mediaFile),
        if (mediaUrl != null && mediaFile == null)
          'MediaUrl': mediaUrl,
      });
      final response = await apiClient.post(
        Endpoints.postOpportunity,
        data: formData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }

      log("${response.statusCode}============== Opportunity created successfully");
    } on DioException catch (e) {
      log('❌ Dio Error: ${e.message}');
      log('❌ Error Response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioErrorKey(e);
    } catch (e) {
      log('❌ Unknown Error: $e');
      rethrow;
    }
  }

  @override
  Future<DetailsModel> opportunityDetails({
    required String opportunityID,
  }) async {
    try {
      final url = Endpoints.opportunityDetails.replaceFirst('{id}', opportunityID);
      final response = await apiClient.get(url);

      log('📦 Response status: ${response.statusCode}');
      log('📦 Response data: ${response.data}');

      if (response.statusCode == 200) {
        return DetailsModel.fromJson(response.data);
      }

      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    } on DioException catch (e) {
      log('❌ Dio Error: ${e.message}');
      log('❌ Error Response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioErrorKey(e);
    } catch (e) {
      log('❌ Unknown Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> applyOpportunity({
    required String opportunityID,
  }) async {
    try {
      final url = Endpoints.applyOpportunity.replaceFirst('{id}', opportunityID);
      final response = await apiClient.post(url);

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }

      log("${response.statusCode}============== Application submitted successfully");
    } on DioException catch (e) {
      log('❌ Dio Error: ${e.message}');
      log('❌ Error Response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioErrorKey(e);
    } catch (e) {
      log('❌ Unknown Error: $e');
      rethrow;
    }
  }

  // Uncomment and implement when needed:
  
@override
  Future<ApplicantsResponseModel> getApplicants({
    required int pageNumber,
    int pageSize = 10,
    required String opportunityID,
    String? status = 'pending',
  }) async {
    try {
      final url = Endpoints.getApplicants.replaceFirst('{id}', opportunityID);
      
      final params = {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      };

      if (status != null && status.isNotEmpty) {
        params['status'] = status;
      }

      final response = await apiClient.get(url, params: params);

      log('📦 Response status: ${response.statusCode}');
      log('📦 Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Parse the entire response using the model
        return ApplicantsResponseModel.fromJson(response.data);
      }

      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    } on DioException catch (e) {
      log('❌ Dio Error: ${e.message}');
      log('❌ Error Response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioErrorKey(e);
    } catch (e) {
      log('❌ Unknown Error: $e');
      rethrow;
    }
  }

@override
  Future<ApplicantsResponseModel> acceptOrRejectApplicant({
    required String applicationId,
   required  String status,
  }) async {
    try {
      final url = Endpoints.detectAcceptOrReject.replaceFirst('{applicationId}', applicationId);
      final response = await apiClient.patch(url, params: {'status': status});

      if (response.statusCode == 200 || response.statusCode == 204) {
        log("${response.statusCode}============== Application $status successfully");
        
        // Return the response data if available, or create a minimal response
        if (response.data != null && response.data is Map<String, dynamic>) {
          return ApplicantsResponseModel.fromJson(response.data);
        } else {
          // If the API doesn't return data, create a minimal response
          // This is typically for 204 No Content responses
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
      }

      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    } on DioException catch (e) {
      log('❌ Dio Error: ${e.message}');
      log('❌ Error Response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioErrorKey(e);
    } catch (e) {
      log('❌ Unknown Error: $e');
      rethrow;
    }
  }
  @override
/// Get my opportunities (active or inactive)
Future<PaginatedOpportunitiesResponse> getMyOpportunities({
  required bool showActive,
  int page = 1,
  int pageSize = 10,
}) async {
  try {
    // Use correct endpoint based on showActive parameter
    final endpoint = showActive 
        ? Endpoints.getActiveOp 
        : Endpoints.getInActiveOp;
    
    final response = await apiClient.get(
      endpoint,
      params: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return PaginatedOpportunitiesResponse.fromJson(data);
    } else {
      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    }
  } on DioException catch (e) {
    final errorKey = ApiErrorHandler.handleDioErrorKey(e);
    throw ApiException(
      message: 'Failed to load opportunities',
      key: errorKey,
    );
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
      if (mediaFile != null)
        'MediaFile': await MultipartFile.fromFile(mediaFile),
    });

    final url = Endpoints.editOpportunity.replaceFirst('{id}', opportunityId);
    final response = await apiClient.put(url, data: formData);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    }

    log('✅ Opportunity updated successfully (API)');
  } on DioException catch (e) {
    log('❌ Error updating opportunity: ${e.message}');
    throw ApiErrorHandler.handleDioErrorKey(e);
  }
}

@override
Future<void> deleteOpportunity({
  required String opportunityId,
}) async {
  try {
    final url = Endpoints.deleteOpportunity.replaceFirst('{id}', opportunityId);
    final response = await apiClient.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    }

    log('✅ Opportunity deleted successfully (API)');
  } on DioException catch (e) {
    log('❌ Error deleting opportunity: ${e.message}');
    throw ApiErrorHandler.handleDioErrorKey(e);
  }
}
}