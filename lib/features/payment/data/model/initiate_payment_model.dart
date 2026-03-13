// lib/features/payment/data/models/initiate_payment_model.dart


import 'package:sports_in/features/payment/data/enums/enums.dart';

/// Request body for:
/// POST https://sportsin.runasp.net/api/Payments/initiate
///
/// ```json
/// {
///   "targetId": "7d2ebef6-9c93-479b-a0e0-e41fcd91a0ff",
///   "targetType": 1,
///   "method": 1,
///   "mobileNumber": "string"
/// }
/// ```
class InitiatePaymentRequest {
  /// The ID of the entity being paid for (e.g. plan ID, video ID, etc.).
  final String targetId;

  /// What you are paying for — maps to [PaymentTargetType] enum.
  final PaymentTargetType targetType;

  /// The chosen payment method — maps to [PaymentMethod] enum.
  final PaymentMethod method;

  /// Required only when [method] is [PaymentMethod.mobileWallet] or
  /// [PaymentMethod.fawryPay]. Pass null for credit card.
  final String? mobileNumber;

  const InitiatePaymentRequest({
    required this.targetId,
    required this.targetType,
    required this.method,
    this.mobileNumber,
  });

  Map<String, dynamic> toJson() => {
        'targetId': targetId,
        'targetType': targetType.value,
        'method': method.value,
        if (mobileNumber != null) 'mobileNumber': mobileNumber,
      };

  @override
  String toString() =>
      'InitiatePaymentRequest(targetId: $targetId, targetType: $targetType, method: $method)';
}
 
class InitiatePaymentResponse {
  final String? transactionId;
  final String? paymentUrl;
  final String? referenceCode;
  final String? status;
 
  const InitiatePaymentResponse({
    this.transactionId,
    this.paymentUrl,
    this.referenceCode,
    this.status,
  });
 
  factory InitiatePaymentResponse.fromJson(Map<String, dynamic> json) {
    return InitiatePaymentResponse(
      transactionId: json['transactionId'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
      referenceCode: json['referenceCode'] as String?,
      status: json['status'] as String?,
    );
  }
 
  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'paymentUrl': paymentUrl,
        'referenceCode': referenceCode,
        'status': status,
      };
 
  @override
  String toString() => 'InitiatePaymentResponse('
      'transactionId: $transactionId, '
      'paymentUrl: $paymentUrl, '
      'referenceCode: $referenceCode, '
      'status: $status)';
}
 