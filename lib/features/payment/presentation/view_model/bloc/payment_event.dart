part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

final class FetchPlansEvent extends PaymentEvent {
  const FetchPlansEvent();
}

final class SelectPlanEvent extends PaymentEvent {
  final SubscriptionPlanModel plan;

  const SelectPlanEvent(this.plan);

  @override
  List<Object?> get props => [plan];
}

final class FetchMySubscriptionEvent extends PaymentEvent {
  final String userId;

  const FetchMySubscriptionEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final class SelectPaymentMethodEvent extends PaymentEvent {
  final PaymentMethod method;

  const SelectPaymentMethodEvent(this.method);

  @override
  List<Object?> get props => [method];
}

final class InitiatePaymentEvent extends PaymentEvent {
  final String targetId;
  final PaymentTargetType targetType;
  final PaymentMethod method;
  final String? mobileNumber;

  const InitiatePaymentEvent({
    required this.targetId,
    required this.targetType,
    required this.method,
    this.mobileNumber,
  });

  @override
  List<Object?> get props => [targetId, targetType, method, mobileNumber];
}

final class ManualActivateEvent extends PaymentEvent {
  final String orderId;
  final PaymentTargetType targetType;

  const ManualActivateEvent({required this.orderId, required this.targetType});

  @override
  List<Object?> get props => [orderId, targetType];
}

final class ResetPaymentEvent extends PaymentEvent {
  const ResetPaymentEvent();
}
