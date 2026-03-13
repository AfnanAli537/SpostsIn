// // lib/features/payment/data/repositories/payment_repository.dart

// import 'package:sports_in/features/payment/data/interface/IPaymentRemoteDataSource.dart';
// import 'package:sports_in/features/payment/data/interface/IPaymentRepository.dart';
// import 'package:sports_in/features/payment/data/model/initiate_payment_model.dart';
// import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
// import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';

// /// Concrete implementation of [IPaymentRepository].
// ///
// /// Depends on [IPaymentRemoteDataSource] abstraction — not on Dio directly (DIP).
// ///
// /// Register with your DI container:
// /// ```dart
// /// sl.registerLazySingleton<IPaymentRepository>(
// ///   () => PaymentRepository(remoteDataSource: sl()),
// /// );
// /// ```
// class PaymentRepository implements IPaymentRepository {
//   final IPaymentRemoteDataSource _remoteDataSource;

//   const PaymentRepository({required IPaymentRemoteDataSource remoteDataSource})
//       : _remoteDataSource = remoteDataSource;

//   // ──────────────────────────────────────────
//   // GET /api/Payments/plans
//   // ──────────────────────────────────────────
//   @override
//   Future<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
//     // Re-throws PaymentException from datasource — let the caller handle UI
//     return _remoteDataSource.fetchPlans();
//   }

//   // ──────────────────────────────────────────
//   // GET /api/Payments/my-subscription?userId=
//   // ──────────────────────────────────────────
//   @override
//   Future<MySubscriptionModel?> getMySubscription(
//       {required String userId}) async {
//     if (userId.trim().isEmpty) {
//       throw const PaymentException(message: 'userId must not be empty');
//     }
//     return _remoteDataSource.fetchMySubscription(userId: userId);
//   }

//   // ──────────────────────────────────────────
//   // POST /api/Payments/initiate
//   // ──────────────────────────────────────────
//   @override
//   Future<InitiatePaymentResponse> initiatePayment(
//       InitiatePaymentRequest request) async {
//     _validateInitiateRequest(request);
//     return _remoteDataSource.initiatePayment(request);
//   }

//   // ──────────────────────────────────────────
//   // Validation
//   // ──────────────────────────────────────────
//   void _validateInitiateRequest(InitiatePaymentRequest request) {
//     if (request.targetId.trim().isEmpty) {
//       throw const PaymentException(message: 'targetId must not be empty');
//     }

//     // Mobile number is required for wallet and Fawry
//     final needsMobile = request.method.value == 2 || request.method.value == 3;
//     if (needsMobile &&
//         (request.mobileNumber == null ||
//             request.mobileNumber!.trim().isEmpty)) {
//       throw const PaymentException(
//         message: 'mobileNumber is required for Mobile Wallet and Fawry Pay',
//       );
//     }
//   }
// }




import 'package:injectable/injectable.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/interface/payment_interface.dart';
import 'package:sports_in/features/payment/data/model/initiate_payment_model.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';


/// Domain-level contract — BLoC depends only on this, never on impl.
abstract class PaymentRepository {
  Future<List<SubscriptionPlanModel>> getPlans();
Future<void> manualTest({
  required String orderId
});
  /// Returns null → navigate to SubscriptionScreen.
  /// Returns model → user already subscribed, skip screen.
  Future<MySubscriptionModel?> getMySubscription({required String userId});

  Future<InitiatePaymentResponse> initiatePayment({
    required String targetId,
    required PaymentTargetType targetType,
    required PaymentMethod method,
    String? mobileNumber, 
  });
}




// lib/features/payment/data/repositories/payment_repository_impl.dart




@LazySingleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentInterface _dataSource;

  PaymentRepositoryImpl({required PaymentInterface dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<SubscriptionPlanModel>> getPlans() =>
      _dataSource.getPlans();
@override
  Future<void> manualTest({
  required String orderId
})async {
 await _dataSource.manualTest(orderId:orderId);
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
    // Validate mobile number is present for wallet/fawry
    if ((method == PaymentMethod.mobileWallet ||
            method == PaymentMethod.fawryPay) &&
        (mobileNumber == null || mobileNumber.trim().isEmpty)) {
      throw Exception(
          'mobileNumber is required for ${method.displayName}');
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