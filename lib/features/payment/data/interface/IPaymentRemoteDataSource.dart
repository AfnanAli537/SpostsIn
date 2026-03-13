// lib/features/payment/data/datasources/i_payment_remote_datasource.dart

import 'package:sports_in/features/payment/data/model/initiate_payment_model.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';


/// Contract for the raw HTTP calls.
/// The repository depends on this abstraction, not on Dio/http directly (DIP).
abstract interface class IPaymentRemoteDataSource {
  /// GET /api/Payments/plans
  Future<List<SubscriptionPlanModel>> fetchPlans();
  Future<void> manualTest({
  required String orderId
});

  /// GET /api/Payments/my-subscription?userId={userId}
  /// Returns null when the server returns 204 or an empty body.
  Future<MySubscriptionModel?> fetchMySubscription({required String userId});

  /// POST /api/Payments/initiate
  Future<InitiatePaymentResponse> initiatePayment(
      InitiatePaymentRequest request);
}