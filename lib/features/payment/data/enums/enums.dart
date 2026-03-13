// lib/features/payment/data/models/payment_enums.dart

/// The thing you are paying FOR (subscription target type).
/// Maps to the API's `targetType` integer field.
enum PaymentTargetType {
  /// targetType = 1
  course(1),

  /// targetType = 2
  supscription(2),

  /// targetType = 3
  advertsment(3),

  /// targetType = 4
  videoAnalysis(4);

  const PaymentTargetType(this.value);
  final int value;

  static PaymentTargetType fromInt(int value) {
    return PaymentTargetType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown PaymentTargetType: $value'),
    );
  }
}

/// The payment METHOD chosen by the user.
/// Maps to the API's `method` integer field.
enum PaymentMethod {
  /// method = 1 — Credit / Debit Card
  creditCard(1),

  /// method = 2 — Mobile Wallet
 fawryPay(2),

  /// method = 3 — Fawry Pay
  mobileWallet(2);
  const PaymentMethod(this.value);
  final int value;

  String get displayName {
    switch (this) {
      case PaymentMethod.creditCard:
        return 'Credit / Debit Card';
      case PaymentMethod.fawryPay:
        return 'Fawry Pay';
      case PaymentMethod.mobileWallet:
        return 'Mobile Wallet';
    }
  }

  static PaymentMethod fromInt(int value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown PaymentMethod: $value'),
    );
  }
}