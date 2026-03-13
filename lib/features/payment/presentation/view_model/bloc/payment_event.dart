// part of 'payment_bloc.dart';

// sealed class PaymentEvent extends Equatable {
//   const PaymentEvent();

//   @override
//   List<Object> get props => [];
// }

// // lib/features/payment/presentation/bloc/payment_event.dart



// /// Fired on app start or screen init — checks if user has an active subscription.
// /// If result is null → BLoC emits [PaymentNoSubscription] → navigate to screen.
// /// If result has value → BLoC emits [PaymentHasSubscription] → skip screen.
// class CheckMySubscriptionEvent extends PaymentEvent {
//   final String userId;
//   CheckMySubscriptionEvent({required this.userId});
// }

// /// Fired when the SubscriptionScreen opens — loads all available plans.
// class LoadPlansEvent extends PaymentEvent {}

// /// Fired when user taps "Subscribe Now" on the SubscriptionScreen.
// /// Sends the selected plan + chosen payment method to the backend.
// class InitiatePaymentEvent extends PaymentEvent {
//   /// The plan ID selected by the user (from [SubscriptionPlanModel.id]).
//   final String planId;

//   /// What is being paid for (maps to targetType int 1–4).
//   final PaymentTargetType targetType;

//   /// How the user wants to pay (maps to method int 1–3).
//   final PaymentMethod paymentMethod;

//   /// Required for Mobile Wallet and Fawry Pay.
//   final String? mobileNumber;

//   InitiatePaymentEvent({
//     required this.planId,
//     required this.targetType,
//     required this.paymentMethod,
//     this.mobileNumber,
//   });
// }



part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

// ─────────────────────────────────────────────
// Plans
// ─────────────────────────────────────────────

/// Fetch all available subscription plans from the server.
final class FetchPlansEvent extends PaymentEvent {
  const FetchPlansEvent();
}

/// User tapped a plan card — store the selection locally.
final class SelectPlanEvent extends PaymentEvent {
  final SubscriptionPlanModel plan;

  const SelectPlanEvent(this.plan);

  @override
  List<Object?> get props => [plan];
}

// ─────────────────────────────────────────────
// My Subscription
// ─────────────────────────────────────────────

/// Check whether the current user already has an active subscription.
final class FetchMySubscriptionEvent extends PaymentEvent {
  final String userId;

  const FetchMySubscriptionEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// ─────────────────────────────────────────────
// Payment Method Selection
// ─────────────────────────────────────────────

/// User chose a payment method (Credit Card / Fawry / Mobile Wallet).
final class SelectPaymentMethodEvent extends PaymentEvent {
  final PaymentMethod method;

  const SelectPaymentMethodEvent(this.method);

  @override
  List<Object?> get props => [method];
}

// ─────────────────────────────────────────────
// Initiate Payment
// ─────────────────────────────────────────────

/// User confirmed payment — triggers POST /api/Payments/initiate.
///
/// [selectedPlan] and [selectedMethod] must already be set in state,
/// but we pass them explicitly here for safety.
final class InitiatePaymentEvent extends PaymentEvent {
  final String targetId;
  final PaymentTargetType targetType;
  final PaymentMethod method;

  /// Required only for Fawry / Mobile Wallet.
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

// ─────────────────────────────────────────────
// Manual Activate (Fawry / Wallet only)
// ─────────────────────────────────────────────

/// After Fawry / Wallet payment succeeds, send the transactionId as orderId
/// to the manual-activate endpoint to unlock the subscription server-side.
final class ManualActivateEvent extends PaymentEvent {
  final String orderId;

  const ManualActivateEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

// ─────────────────────────────────────────────
// Reset
// ─────────────────────────────────────────────

/// Clear all payment state (e.g. when leaving the payment flow).
final class ResetPaymentEvent extends PaymentEvent {
  const ResetPaymentEvent();
}