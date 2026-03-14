
enum PaymentTargetType {

  course(1),
  supscription(2),
  advertsment(3),
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


enum PaymentMethod {
  creditCard(1),
 fawryPay(2),
  mobileWallet(3);
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