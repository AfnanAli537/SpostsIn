// lib/features/payment/domain/repositories/i_payment_repository.dart

import 'package:sports_in/features/payment/data/model/initiate_payment_model.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';


/// Abstract contract for all payment-related operations.
///
/// The domain layer depends ONLY on this interface (DIP).
/// The data layer provides the concrete implementation.
///
/// Usage with your DI container (e.g. get_it):
/// ```dart
/// sl.registerLazySingleton<IPaymentRepository>(
///   () => PaymentRepository(remoteDataSource: sl()),
/// );
/// ```
abstract interface class IPaymentRepository {
  // ──────────────────────────────────────────
  // GET /api/Payments/plans
  // ──────────────────────────────────────────

  /// Fetches all available subscription plans (Free, Premium, Gold).
  ///
  /// Returns a list of [SubscriptionPlanModel].
  /// Throws [PaymentException] on failure.
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans();

  // ──────────────────────────────────────────
  // GET /api/Payments/my-subscription?userId=
  // ──────────────────────────────────────────

  /// Fetches the current user's active subscription.
  ///
  /// Returns [MySubscriptionModel] if the user has an active subscription.
  /// Returns **null** if the user has no subscription — the caller should
  /// then navigate to the SubscriptionScreen.
  ///
  /// ```dart
  /// final sub = await repo.getMySubscription(userId: currentUserId);
  /// if (sub == null) {
  ///   // → push SubscriptionScreen
  /// } else {
  ///   // → continue normal flow
  /// }
  /// ```
  Future<MySubscriptionModel?> getMySubscription({required String userId});
Future<void> manualTest({
  required String orderId
});
  // ──────────────────────────────────────────
  // POST /api/Payments/initiate
  // ──────────────────────────────────────────

  /// Initiates a payment for a given target using the chosen method.
  ///
  /// [request] contains targetId, targetType, method, and optional mobileNumber.
  /// Returns [InitiatePaymentResponse] with transactionId / redirectUrl.
  /// Throws [PaymentException] on failure.
  Future<InitiatePaymentResponse> initiatePayment(
      InitiatePaymentRequest request);
}

// ──────────────────────────────────────────────
//  Domain exception
// ──────────────────────────────────────────────

/// Thrown by the repository layer for any payment-related failure.
class PaymentException implements Exception {
  final String message;
  final int? statusCode;

  const PaymentException({required this.message, this.statusCode});

  @override
  String toString() =>
      'PaymentException(statusCode: $statusCode, message: $message)';
}