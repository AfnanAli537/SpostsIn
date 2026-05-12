import 'package:sports_in/features/payment/data/enums/enums.dart';

class InitiatePaymentRequest {
  final String targetId;
  final PaymentTargetType targetType;
  final PaymentMethod method;
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
 