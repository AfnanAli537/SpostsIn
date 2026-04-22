import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/payment/data/interface/payment_interface.dart';
import 'package:sports_in/features/payment/data/model/initiate_payment_model.dart';
import 'package:sports_in/features/payment/data/model/manual_test_model.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription_plan_model.dart';

@LazySingleton(as: PaymentInterface)
class PaymentRemoteDataSourceImpl implements PaymentInterface {
  final ApiClient apiClient;

  PaymentRemoteDataSourceImpl({required this.apiClient});

  DioException _badResponse(Response response) => DioException(
    requestOptions: response.requestOptions,
    response: response,
    type: DioExceptionType.badResponse,
  );
  @override
  Future<List<SubscriptionPlanModel>> getPlans() async {
    try {
      final response = await apiClient.get(Endpoints.showPlans);

      log('📦 [Payment] getPlans status: ${response.statusCode}');
      log('📦 [Payment] getPlans data: ${response.data}');

      if (response.statusCode == 200) {
        final List items = response.data as List? ?? [];
        return items
            .map(
              (json) =>
                  SubscriptionPlanModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      log('❌ [Payment] getPlans Dio error: ${e.message}');
      log('❌ [Payment] getPlans response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioError(e);
    } catch (e) {
      log('❌ [Payment] getPlans unknown error: $e');
      rethrow;
    }
  }

  @override
  Future<MySubscriptionModel?> getMySubscription({
    required String userId,
  }) async {
    try {
      final response = await apiClient.get(
        Endpoints.mySubscription,
        params: {'userId': userId},
      );

      log('📦 [Payment] mySubscription status: ${response.statusCode}');
      log('📦 [Payment] mySubscription data: ${response.data}');
      if (response.statusCode == 204 ||
          response.data == null ||
          (response.data is Map && (response.data as Map).isEmpty)) {
        log('ℹ️ [Payment] User has no active subscription');
        return null;
      }

      if (response.statusCode == 200) {
        return MySubscriptionModel.fromJsonNullable(
          response.data as Map<String, dynamic>?,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        log('ℹ️ [Payment] 404 → no subscription found for user');
        return null;
      }
      log('❌ [Payment] mySubscription Dio error: ${e.message}');
      log('❌ [Payment] mySubscription response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioError(e);
    } catch (e) {
      log('❌ [Payment] mySubscription unknown error: $e');
      rethrow;
    }
  }

  @override
  Future<InitiatePaymentResponse> initiatePayment(
    InitiatePaymentRequest request,
  ) async {
    try {
      final body = request.toJson();
      final id = request.targetId;
      final type = body['targetType'];
      final method = body['method'];
      final mobileNumber = body['mobileNumber'];
      log('🚀 [Payment] initiatePayment request: $body');

      final response = await apiClient.post(
        Endpoints.initiate,
        data: {
          "targetId": id,
          "targetType": type,
          "method": method,
          if (mobileNumber != null) "mobileNumber": mobileNumber,
        },
      );

      log('📦 [Payment] initiatePayment status: ${response.statusCode}');
      log('📦 [Payment] initiatePayment data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic resBody = response.data;

        if (resBody is String) {
          return InitiatePaymentResponse(transactionId: resBody);
        }

        return InitiatePaymentResponse.fromJson(
          resBody as Map<String, dynamic>,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      log('❌ [Payment] initiatePayment Dio error: ${e.message}');
      log('❌ [Payment] initiatePayment response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioError(e);
    } catch (e) {
      log('❌ [Payment] initiatePayment unknown error: $e');
      rethrow;
    }
  }

  @override
  Future<ManualActivateResponse> manualTest({required String orderId}) async {
    try {
      log('🚀 [Payment] manualActivate orderId: $orderId');

      final url = Endpoints.manualActivate.replaceFirst('{orderId}', orderId);
      final response = await apiClient.post(url);

      log('📦 [Payment] manualActivate status: ${response.statusCode}');
      log('📦 [Payment] manualActivate data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ManualActivateResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      log('❌ [Payment] manualActivate Dio error: ${e.message}');
      log('❌ [Payment] manualActivate response: ${e.response?.data}');
      throw ApiErrorHandler.handleDioError(e);
    } catch (e) {
      log('❌ [Payment] manualActivate unknown error: $e');
      rethrow;
    }
  }
}
