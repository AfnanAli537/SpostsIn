// import 'dart:developer';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:injectable/injectable.dart';
// import 'package:sports_in/features/payment/data/enums/enums.dart';
// import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
// import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
// import 'package:sports_in/features/payment/data/repo/payment_repo.dart';

// part 'payment_event.dart';
// part 'payment_state.dart';
// // lib/features/payment/presentation/bloc/payment_bloc.dart


// @injectable
// class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
//   final PaymentRepository _repository;

//   PaymentBloc({required PaymentRepository repository})
//       : _repository = repository,
//         super(PaymentInitial()) {
//     on<CheckMySubscriptionEvent>(_onCheckMySubscription);
//     on<LoadPlansEvent>(_onLoadPlans);
//     on<InitiatePaymentEvent>(_onInitiatePayment);
//   }

//   // ─────────────────────────────────────────────
//   // CheckMySubscriptionEvent
//   // → null   : emit PaymentNoSubscription  → UI navigates to SubscriptionScreen
//   // → model  : emit PaymentHasSubscription → UI continues normal flow
//   // ─────────────────────────────────────────────
//   Future<void> _onCheckMySubscription(
//     CheckMySubscriptionEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     emit(PaymentLoading());
//     try {
//       final subscription =
//           await _repository.getMySubscription(userId: event.userId);

//       log('📦 [PaymentBloc] mySubscription result: $subscription');

//       if (subscription == null || !subscription.isValid) {
//         // No subscription or expired → must go to SubscriptionScreen
//         log('ℹ️ [PaymentBloc] No active subscription → navigate to screen');
//         emit(PaymentNoSubscription());
//       } else {
//         // Has valid subscription → skip screen
//         log('✅ [PaymentBloc] Active subscription: ${subscription.planName}');
//         emit(PaymentHasSubscription(subscription: subscription));
//       }
//     } catch (e) {
//       log('❌ [PaymentBloc] CheckMySubscription error: $e');
//       emit(PaymentError(message: e.toString()));
//     }
//   }

//   // ─────────────────────────────────────────────
//   // LoadPlansEvent
//   // Called when SubscriptionScreen opens
//   // ─────────────────────────────────────────────
//   Future<void> _onLoadPlans(
//     LoadPlansEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     emit(PaymentLoading());
//     try {
//       final plans = await _repository.getPlans();
//       log('✅ [PaymentBloc] Loaded ${plans.length} plans');
//       emit(PaymentPlansLoaded(plans: plans));
//     } catch (e) {
//       log('❌ [PaymentBloc] LoadPlans error: $e');
//       emit(PaymentError(message: e.toString()));
//     }
//   }

//   // ─────────────────────────────────────────────
//   // InitiatePaymentEvent
//   // Called when user taps "Subscribe Now"
//   // ─────────────────────────────────────────────
//   Future<void> _onInitiatePayment(
//     InitiatePaymentEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     emit(PaymentLoading());
//     try {
//       final response = await _repository.initiatePayment(
//         targetId: event.planId,
//         targetType: event.targetType,
//         method: event.paymentMethod,
//         mobileNumber: event.mobileNumber,
//       );

//       log('✅ [PaymentBloc] Payment initiated: ${response.transactionId}');
//       emit(PaymentSuccess(transactionId: response.transactionId ?? ''));
//     } catch (e) {
//       log('❌ [PaymentBloc] InitiatePayment error: $e');
//       emit(PaymentError(message: e.toString()));
//     }
//   }
// }


import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/data/repo/payment_repo.dart';

part 'payment_event.dart';
part 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repository;

  PaymentBloc({required PaymentRepository repository})
      : _repository = repository,
        super(const PaymentInitial()) {
    on<FetchPlansEvent>(_onFetchPlans);
    on<SelectPlanEvent>(_onSelectPlan);
    on<FetchMySubscriptionEvent>(_onFetchMySubscription);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<ManualActivateEvent>(_onManualActivate);
    on<ResetPaymentEvent>(_onReset);
  }

  // ─────────────────────────────────────────────
  // Internal helpers
  // ─────────────────────────────────────────────

  /// The plan selected by the user, kept in-memory across state transitions.
  SubscriptionPlanModel? _selectedPlan;

  // ─────────────────────────────────────────────
  // Handlers
  // ─────────────────────────────────────────────

  Future<void> _onFetchPlans(
    FetchPlansEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PlansLoading());
    try {
      final plans = await _repository.getPlans();
      log('✅ [PaymentBloc] fetched ${plans.length} plans');
      emit(PlansLoaded(plans: plans));
    } catch (e) {
      log('❌ [PaymentBloc] FetchPlansEvent error: $e');
      emit(PlansError(e.toString()));
    }
  }

  void _onSelectPlan(
    SelectPlanEvent event,
    Emitter<PaymentState> emit,
  ) {
    _selectedPlan = event.plan;
    log('✅ [PaymentBloc] plan selected: ${event.plan.name}');

    // Keep the plan list visible and mark the selection.
    if (state is PlansLoaded) {
      emit((state as PlansLoaded).copyWith(selectedPlan: event.plan));
    } else {
      // Edge-case: state was reset or something unexpected — re-wrap.
      emit(PlansLoaded(plans: const [], selectedPlan: event.plan));
    }
  }

  Future<void> _onFetchMySubscription(
    FetchMySubscriptionEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const MySubscriptionLoading());
    try {
      final sub = await _repository.getMySubscription(userId: event.userId);
      if (sub == null) {
        log('ℹ️ [PaymentBloc] no active subscription');
        emit(const NoActiveSubscription());
      } else {
        log('✅ [PaymentBloc] subscription: ${sub.planName}');
        emit(MySubscriptionLoaded(sub));
      }
    } catch (e) {
      log('❌ [PaymentBloc] FetchMySubscriptionEvent error: $e');
      emit(MySubscriptionError(e.toString()));
    }
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethodEvent event,
    Emitter<PaymentState> emit,
  ) {
    if (_selectedPlan == null) {
      // Guard: plan must be selected before choosing a method.
      log('⚠️ [PaymentBloc] SelectPaymentMethodEvent fired but no plan selected');
      emit(const PlansError('Please select a plan before choosing a payment method.'));
      return;
    }
    log('✅ [PaymentBloc] method selected: ${event.method.displayName}');
    emit(PaymentMethodSelected(plan: _selectedPlan!, method: event.method));
  }

  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentInitiating());
    try {
      final response = await _repository.initiatePayment(
        targetId: event.targetId,
        targetType: event.targetType,
        method: event.method,
        mobileNumber: event.mobileNumber,
      );

      log('✅ [PaymentBloc] initiatePayment response: $response');

      // ── Credit Card ──────────────────────────────
      // Backend returns a redirectUrl — open in browser / WebView.
      if (event.method == PaymentMethod.creditCard) {
        final url = response.paymentUrl;
        if (url == null || url.isEmpty) {
          emit(const PaymentInitiateError(
            'Credit card flow: no redirect URL returned by server.',
          ));
          return;
        }
        emit(PaymentRedirectReady(
          redirectUrl: url,
          transactionId: response.transactionId ?? '',
        ));
        return;
      }

      // ── Fawry / Mobile Wallet ────────────────────
      // Use the transactionId as the orderId for manual activation.
      final txId = response.transactionId;
      if (txId == null || txId.isEmpty) {
        emit(const PaymentInitiateError(
          'No transaction ID returned. Cannot activate subscription.',
        ));
        return;
      }

      emit(PaymentInitiatedAwaitingActivation(
        transactionId: txId,
        method: event.method,
      ));

      // Auto-trigger manual activation immediately.
      add(ManualActivateEvent(orderId: txId));
    } catch (e) {
      log('❌ [PaymentBloc] InitiatePaymentEvent error: $e');
      emit(PaymentInitiateError(e.toString()));
    }
  }

  Future<void> _onManualActivate(
    ManualActivateEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const ManualActivating());
    try {
      await _repository.manualTest(orderId: event.orderId);
      log('✅ [PaymentBloc] manual activation success for orderId: ${event.orderId}');

      // The ManualActivateResponse contains a new token + user info.
      // Pass the token to the state so the UI / auth layer can refresh it.
      emit(const ManualActivateSuccess(
        message: 'Subscription activated successfully!',
      ));
    } catch (e) {
      log('❌ [PaymentBloc] ManualActivateEvent error: $e');
      emit(ManualActivateError(e.toString()));
    }
  }

  void _onReset(
    ResetPaymentEvent event,
    Emitter<PaymentState> emit,
  ) {
    _selectedPlan = null;
    emit(const PaymentInitial());
  }
}