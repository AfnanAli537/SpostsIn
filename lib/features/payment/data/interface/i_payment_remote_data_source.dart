import 'package:sports_in/features/payment/data/model/initiate_payment_model.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription_plan_model.dart';

abstract interface class IPaymentRemoteDataSource {
  Future<List<SubscriptionPlanModel>> fetchPlans();
  Future<void> manualTest({
  required String orderId
});

  Future<MySubscriptionModel?> fetchMySubscription({required String userId});
  Future<InitiatePaymentResponse> initiatePayment(
      InitiatePaymentRequest request);
}