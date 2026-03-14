import 'package:injectable/injectable.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/interface/payment_interface.dart';
import 'package:sports_in/features/payment/data/model/initiate_payment_model.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';

abstract class PaymentRepository {
  Future<List<SubscriptionPlanModel>> getPlans();
  Future<void> manualTest({required String orderId});
  Future<MySubscriptionModel?> getMySubscription({required String userId});

  Future<InitiatePaymentResponse> initiatePayment({
    required String targetId,
    required PaymentTargetType targetType,
    required PaymentMethod method,
    String? mobileNumber,
  });
}

@LazySingleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentInterface _dataSource;

  PaymentRepositoryImpl({required PaymentInterface dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<SubscriptionPlanModel>> getPlans() => _dataSource.getPlans();
  @override
  Future<void> manualTest({required String orderId}) async {
    await _dataSource.manualTest(orderId: orderId);
  }

  @override
  Future<MySubscriptionModel?> getMySubscription({required String userId}) =>
      _dataSource.getMySubscription(userId: userId);

  @override
  Future<InitiatePaymentResponse> initiatePayment({
    required String targetId,
    required PaymentTargetType targetType,
    required PaymentMethod method,
    String? mobileNumber,
  }) {
    if ((method == PaymentMethod.mobileWallet ||
            method == PaymentMethod.fawryPay) &&
        (mobileNumber == null || mobileNumber.trim().isEmpty)) {
      throw Exception('mobileNumber is required for ${method.displayName}');
    }

    return _dataSource.initiatePayment(
      InitiatePaymentRequest(
        targetId: targetId,
        targetType: targetType,
        method: method,
        mobileNumber: mobileNumber,
      ),
    );
  }
}
