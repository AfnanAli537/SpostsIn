part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

final class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

final class PlansLoading extends PaymentState {
  const PlansLoading();
}
final class ProcessSuccessful extends PaymentState {
  const ProcessSuccessful();
}
final class PlansLoaded extends PaymentState {
  final List<SubscriptionPlanModel> plans;

  final SubscriptionPlanModel? selectedPlan;

  const PlansLoaded({required this.plans, this.selectedPlan});

  PlansLoaded copyWith({
    List<SubscriptionPlanModel>? plans,
    SubscriptionPlanModel? selectedPlan,
  }) {
    return PlansLoaded(
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }

  @override
  List<Object?> get props => [plans, selectedPlan];
}

final class PlansError extends PaymentState {
  final String message;

  const PlansError(this.message);

  @override
  List<Object?> get props => [message];
}

final class MySubscriptionLoading extends PaymentState {
  const MySubscriptionLoading();
}

final class MySubscriptionLoaded extends PaymentState {
  final MySubscriptionModel subscription;

  const MySubscriptionLoaded(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

final class NoActiveSubscription extends PaymentState {
  const NoActiveSubscription();
}

final class MySubscriptionError extends PaymentState {
  final String message;

  const MySubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}

final class PaymentMethodSelected extends PaymentState {
  final SubscriptionPlanModel plan;
  final PaymentMethod method;

  const PaymentMethodSelected({required this.plan, required this.method});

  @override
  List<Object?> get props => [plan, method];
}

final class PaymentInitiating extends PaymentState {
  const PaymentInitiating();
}

final class PaymentRedirectReady extends PaymentState {
  final String redirectUrl;
  final String transactionId;

  const PaymentRedirectReady({
    required this.redirectUrl,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [redirectUrl, transactionId];
}

final class PaymentInitiatedAwaitingActivation extends PaymentState {
  final String transactionId;
  final PaymentMethod method;
  final String? referenceCode;

  const PaymentInitiatedAwaitingActivation({
    required this.transactionId,
    required this.method,
    this.referenceCode,
  });

  @override
  List<Object?> get props => [transactionId, method];
}

final class PaymentInitiateError extends PaymentState {
  final String message;

  const PaymentInitiateError(this.message);

  @override
  List<Object?> get props => [message];
}

final class ManualActivating extends PaymentState {
  const ManualActivating();
}

final class ManualActivateSuccess extends PaymentState {
  final String? newToken;
  final String? message;

  const ManualActivateSuccess({this.newToken, this.message});

  @override
  List<Object?> get props => [newToken, message];
}

final class ManualActivateError extends PaymentState {
  final String message;

  const ManualActivateError(this.message);

  @override
  List<Object?> get props => [message];
}
