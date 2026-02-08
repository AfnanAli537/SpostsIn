import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/main/opportunity/data/interface/opportunity_interface.dart';
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
        'page': pageNumber,
        'size': pageSize,
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
  /*
  @override
  Future<Map<String, dynamic>> getApplicants({
    required int pageNumber,
    int pageSize = 10,
    required String opportunityID,
    String? status,
  }) async {
    try {
      final url = Endpoints.getApplicants.replaceFirst('{id}', opportunityID);
      
      final params = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };

      if (status != null && status.isNotEmpty) {
        params['status'] = status;
      }

      final response = await apiClient.get(url, params: params);

      log('📦 Response status: ${response.statusCode}');
      log('📦 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        final List<ApplicantModel> applicants = items
            .map((json) => ApplicantModel.fromJson(json))
            .toList();

        return {
          'applicants': applicants,
          'hasNextPage': response.data['hasNextPage'] ?? false,
        };
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
  Future<void> acceptOrRejectApplicant({
    required String applicationId,
    required String status, // e.g., "accepted" or "rejected"
  }) async {
    try {
      final url = Endpoints.manageApplication.replaceFirst('{id}', applicationId);
      final response = await apiClient.put(url, data: {'status': status});

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }

      log("${response.statusCode}============== Application $status successfully");
    } on DioException catch (e) {
      log('❌ Dio Error: ${e.message}');
      log('❌ Error Response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioErrorKey(e);
    } catch (e) {
      log('❌ Unknown Error: $e');
      rethrow;
    }
  }
  */
}