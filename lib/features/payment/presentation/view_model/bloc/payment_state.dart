// part of 'payment_bloc.dart';

// sealed class PaymentState extends Equatable {
//   const PaymentState();
  
//   @override
//   List<Object> get props => [];
// }
// // lib/features/payment/presentation/bloc/payment_state.dart

// /// Initial idle state before any event fires.
// class PaymentInitial extends PaymentState {}

// /// Loading indicator — covers subscription check, plan load, and payment.
// class PaymentLoading extends PaymentState {}

// // ─── Subscription check states ───────────────

// /// User has NO active subscription → UI must navigate to SubscriptionScreen.
// class PaymentNoSubscription extends PaymentState {}

// /// User already has an active subscription → skip SubscriptionScreen.
// class PaymentHasSubscription extends PaymentState {
//   final MySubscriptionModel subscription;
//   PaymentHasSubscription({required this.subscription});
// }

// // ─── Plans states ─────────────────────────────

// /// Plans fetched successfully — pass them to the SubscriptionScreen.
// class PaymentPlansLoaded extends PaymentState {
//   final List<SubscriptionPlanModel> plans;
//   PaymentPlansLoaded({required this.plans});
// }

// // ─── Payment initiation states ────────────────

// /// Payment was accepted by the gateway.
// class PaymentSuccess extends PaymentState {
//   final String transactionId;
//   PaymentSuccess({required this.transactionId});
// }

// /// Any error across all operations.
// class PaymentError extends PaymentState {
//   final String message;
//   PaymentError({required this.message});
// }




part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

// ─────────────────────────────────────────────
// Base / Initial
// ─────────────────────────────────────────────

final class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

// ─────────────────────────────────────────────
// Plans
// ─────────────────────────────────────────────

final class PlansLoading extends PaymentState {
  const PlansLoading();
}

final class PlansLoaded extends PaymentState {
  final List<SubscriptionPlanModel> plans;

  /// The plan the user has tapped — null until [SelectPlanEvent] fires.
  final SubscriptionPlanModel? selectedPlan;

  const PlansLoaded({
    required this.plans,
    this.selectedPlan,
  });

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

// ─────────────────────────────────────────────
// My Subscription
// ─────────────────────────────────────────────

final class MySubscriptionLoading extends PaymentState {
  const MySubscriptionLoading();
}

/// User has an active subscription.
final class MySubscriptionLoaded extends PaymentState {
  final MySubscriptionModel subscription;

  const MySubscriptionLoaded(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

/// User has no subscription → UI should push SubscriptionScreen.
final class NoActiveSubscription extends PaymentState {
  const NoActiveSubscription();
}

final class MySubscriptionError extends PaymentState {
  final String message;

  const MySubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─────────────────────────────────────────────
// Payment Flow
// ─────────────────────────────────────────────

/// User picked a payment method — UI can now show the confirm button.
final class PaymentMethodSelected extends PaymentState {
  final SubscriptionPlanModel plan;
  final PaymentMethod method;

  const PaymentMethodSelected({
    required this.plan,
    required this.method,
  });

  @override
  List<Object?> get props => [plan, method];
}

final class PaymentInitiating extends PaymentState {
  const PaymentInitiating();
}

/// Credit card flow: backend returned a redirect URL — open in browser/WebView.
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

/// Fawry / Wallet flow: initiation succeeded, transactionId ready
/// — will trigger [ManualActivateEvent] automatically.
final class PaymentInitiatedAwaitingActivation extends PaymentState {
  final String transactionId;
  final PaymentMethod method;

  const PaymentInitiatedAwaitingActivation({
    required this.transactionId,
    required this.method,
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

// ─────────────────────────────────────────────
// Manual Activate (Fawry / Wallet)
// ─────────────────────────────────────────────

final class ManualActivating extends PaymentState {
  const ManualActivating();
}

final class ManualActivateSuccess extends PaymentState {
  /// The fresh JWT / token returned after successful activation.
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