import 'package:sports_in/features/payment/data/model/initiate_payment_model.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription_plan_model.dart';

abstract class PaymentInterface {
  Future<List<SubscriptionPlanModel>> getPlans();
  Future<void> manualTest({required String orderId});
  Future<MySubscriptionModel?> getMySubscription({required String userId});

  Future<InitiatePaymentResponse> initiatePayment(
    InitiatePaymentRequest request,
  );
}
