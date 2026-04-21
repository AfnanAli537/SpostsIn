import 'package:sports_in/features/payment/data/model/initiate_payment_model.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';

abstract interface class IPaymentRepository {
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans();
  Future<MySubscriptionModel?> getMySubscription({required String userId});
  Future<void> manualTest({required String orderId});

  Future<InitiatePaymentResponse> initiatePayment(
    InitiatePaymentRequest request,
  );
}

class PaymentException implements Exception {
  final String message;
  final int? statusCode;

  const PaymentException({required this.message, this.statusCode});

  @override
  String toString() =>
      'PaymentException(statusCode: $statusCode, message: $message)';
}
