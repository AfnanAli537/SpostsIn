import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/features/main/video_analysis/data/repo/analysis_repo.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/my_subscription_model.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
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
      log('✅ [PaymentBloc] fetched ${plans.length} plans');
      emit(PlansLoaded(plans: plans));
    } catch (e) {
      log('❌ [PaymentBloc] FetchPlansEvent error: $e');
      emit(PlansError(e.toString()));
    }
  }

  void _onSelectPlan(SelectPlanEvent event, Emitter<PaymentState> emit) {
    _selectedPlan = event.plan;
    log('✅ [PaymentBloc] plan selected: ${event.plan.name}');
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
        log('[PaymentBloc] no active subscription');
        emit(const NoActiveSubscription());
      } else {
        log('[PaymentBloc] subscription: ${sub.planName}');
        emit(MySubscriptionLoaded(sub));
      }
    } catch (e) {
      log('[PaymentBloc] FetchMySubscriptionEvent error: $e');
      emit(MySubscriptionError(e.toString()));
    }
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethodEvent event,
    Emitter<PaymentState> emit,
  ) {
    if (_selectedPlan == null) {
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

      // Free plan
      if (_selectedPlan?.isFree == true) {
        emit(ProcessSuccessful(transactionId: response.transactionId));
        return;
      }

      log('✅ [PaymentBloc] initiatePayment response: $response');

      // Credit card → redirect
      if (event.method == PaymentMethod.creditCard) {
        final url = response.paymentUrl;
        if (url == null || url.isEmpty) {
          emit(const PaymentInitiateError('Credit card flow: no redirect URL returned.'));
          return;
        }
        emit(PaymentRedirectReady(
          redirectUrl: url,
          transactionId: response.transactionId ?? '',
        ));
        return;
      }

      // Fawry / Vodafone → awaiting manual activation
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
      // 1. Activate the order
      await _repository.manualTest(orderId: event.orderId);
      log('✅ [PaymentBloc] manual activation success for orderId: ${event.orderId}');

      // 2. If this is a video analysis payment, execute the analysis
      //    using the transactionId (= orderId passed from Fawry/Vodafone screen)
      if (event.targetType == PaymentTargetType.videoAnalysis) {
        try {
          await _analysisRepository.executePaidAnalysis(event.orderId);
          log('✅ [PaymentBloc] executePaidAnalysis success for txId: ${event.orderId}');
        } catch (e) {
          // executePaidAnalysis failure is non-fatal — the analysis may still
          // be queued by the backend webhook. Log and continue to success.
          log('⚠️ [PaymentBloc] executePaidAnalysis error (non-fatal): $e');
        }
      }

      emit(const ManualActivateSuccess(
        message: 'Payment activated successfully!',
      ));
    } catch (e) {
      log('❌ [PaymentBloc] ManualActivateEvent error: $e');
      emit(ManualActivateError(e.toString()));
    }
  }

  void _onReset(ResetPaymentEvent event, Emitter<PaymentState> emit) {
    _selectedPlan = null;
    emit(const PaymentInitial());
  }
}