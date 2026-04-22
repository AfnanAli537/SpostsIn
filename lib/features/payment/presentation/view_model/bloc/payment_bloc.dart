// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/features/main/video_analysis/data/repo/analysis_repo.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription_plan_model.dart';
import 'package:sports_in/features/payment/data/repo/payment_repo.dart';

part 'payment_event.dart';
part 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repository;
  final IAnalysisRepo _analysisRepository;

  PaymentBloc({
    required PaymentRepository repository,
    required IAnalysisRepo analysisRepository,
  })  : _repository = repository,
        _analysisRepository = analysisRepository,
        super(const PaymentInitial()) {
    on<FetchPlansEvent>(_onFetchPlans);
    on<SelectPlanEvent>(_onSelectPlan);
    on<FetchMySubscriptionEvent>(_onFetchMySubscription);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<ManualActivateEvent>(_onManualActivate);
    on<ResetPaymentEvent>(_onReset);
  }

  SubscriptionPlanModel? _selectedPlan;

  Future<void> _onFetchPlans(
    FetchPlansEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PlansLoading());
    try {
      final plans = await _repository.getPlans();
      emit(PlansLoaded(plans: plans));
    } catch (e) {
      log('❌ [PaymentBloc] FetchPlansEvent error: $e');
      emit(PlansError(e.toString()));
    }
  }

  void _onSelectPlan(SelectPlanEvent event, Emitter<PaymentState> emit) {
    _selectedPlan = event.plan;
    if (state is PlansLoaded) {
      emit((state as PlansLoaded).copyWith(selectedPlan: event.plan));
    } else {
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
        emit(const NoActiveSubscription());
      } else {
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
      emit(const PlansError(
          'Please select a plan before choosing a payment method.'));
      return;
    }
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

      if (_selectedPlan?.isFree == true) {
        emit(ProcessSuccessful(transactionId: response.transactionId));
        return;
      }

      if (event.method == PaymentMethod.creditCard) {
        final url = response.paymentUrl;
        if (url == null || url.isEmpty) {
          emit(const PaymentInitiateError(
              'Credit card flow: no redirect URL returned.'));
          return;
        }
        emit(PaymentRedirectReady(
          redirectUrl: url,
          transactionId: response.transactionId ?? '',
        ));
        return;
      }

      final txId = response.transactionId;
      if (txId == null || txId.isEmpty) {
        emit(const PaymentInitiateError('No transaction ID returned.'));
        return;
      }

      emit(PaymentInitiatedAwaitingActivation(
        transactionId: txId,
        method: event.method,
        referenceCode: response.referenceCode,
      ));
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
      // ── Step 1: Activate the order ────────────────────────────────────────
      // This is the only blocking call. The Fawry/Vodafone processing dialog
      // stays open until this resolves.
      await _repository.manualTest(orderId: event.orderId);
      log('✅ [PaymentBloc] manual activation success: ${event.orderId}');

      // ── Step 2: Emit success IMMEDIATELY ─────────────────────────────────
      // This dismisses the Fawry/Vodafone processing dialog right away.
      // executePaidAnalysis is NOT awaited here — it would block the UI
      // for the full AI processing time (minutes), keeping the dialog open.
      emit(const ManualActivateSuccess(message: 'Payment activated successfully!'));

      // ── Step 3: Fire-and-forget executePaidAnalysis ───────────────────────
      // Runs in the background AFTER the dialog has already dismissed.
      // Emits AnalysisExecutionCompleted / AnalysisExecutionFailed so the
      // global listener in CustomBottomNav can show a toast — even if the
      // user has already navigated away from the payment screen.
      if (event.targetType == PaymentTargetType.videoAnalysis) {
        _fireAndForgetAnalysis(event.orderId);
      }
    } catch (e) {
      log('❌ [PaymentBloc] ManualActivateEvent error: $e');
      emit(ManualActivateError(e.toString()));
    }
  }

  /// Calls executePaidAnalysis without blocking [_onManualActivate].
  /// On completion emits [AnalysisExecutionCompleted] or [AnalysisExecutionFailed].
  void _fireAndForgetAnalysis(String transactionId) {
    _analysisRepository.executePaidAnalysis(transactionId).then((_) {
      log('✅ [PaymentBloc] executePaidAnalysis done: $transactionId');
      if (!isClosed) emit(AnalysisExecutionCompleted());
    }).catchError((Object e) {
      log('⚠️ [PaymentBloc] executePaidAnalysis error (non-fatal): $e');
      // Still emit completed — backend webhook may have already queued it.
      if (!isClosed) emit(AnalysisExecutionFailed(e.toString()));
    });
  }

  void _onReset(ResetPaymentEvent event, Emitter<PaymentState> emit) {
    _selectedPlan = null;
    emit(const PaymentInitial());
  }
}