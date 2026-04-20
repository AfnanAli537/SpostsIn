import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/video_analysis/data/repo/analysis_repo.dart';
import 'package:sports_in/features/main/video_analysis/model/create_analysis_response.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_event.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_state.dart';
import '../../data/enums/analysis_type.dart';

class CreateAnalysisBloc
    extends Bloc<CreateAnalysisEvent, CreateAnalysisState> {
  final IAnalysisRepo _repo;

  static const double kAnalysisPrice = 10.0;

  /// After [_optimisticDelay] the form screen navigates to AnalysisProcessingScreen
  /// regardless of whether the backend has responded yet.
  static const Duration _optimisticDelay = Duration(seconds: 3);

  CreateAnalysisBloc(this._repo) : super(CreateAnalysisInitial()) {
    on<SubmitAnalysisEvent>(_onSubmit);
    on<ExecutePaidAnalysisEvent>(_onExecutePaid);
    // Private self-events posted when the background API call finishes.
    // Using self-events (instead of holding the emitter) is the safe pattern
    // because the Emitter is invalidated once _onSubmit returns.
    on<_BackgroundResponseReceived>(_onBackgroundResponse);
    on<_BackgroundErrorReceived>(_onBackgroundError);
  }

  Future<void> _onSubmit(
    SubmitAnalysisEvent event,
    Emitter<CreateAnalysisState> emit,
  ) async {
    emit(CreateAnalysisLoading());

    final apiFuture = _callEndpoint(event);
    bool queuedEmitted = false;

    // ── Race: 3-second timer vs. API response ─────────────────────────────
    await Future.any([
      // Branch A — 3 s elapsed → optimistic navigation
      Future.delayed(_optimisticDelay).then((_) {
        if (!queuedEmitted && !isClosed) {
          queuedEmitted = true;
          emit(const AnalysisQueued());
        }
      }),

      // Branch B — API responded before 3 s
      apiFuture.then((response) {
        if (!queuedEmitted) {
          queuedEmitted = true;
          if (response.requiresPayment) {
            // Payment required — show payment screen immediately
            emit(CreateAnalysisRequiresPayment(
              analysisId: response.id,
              price: kAnalysisPrice,
            ));
          } else {
            // Paid and fast — queue then complete in the same frame
            emit(const AnalysisQueued());
            emit(AnalysisCompleted(response));
          }
        }
      }).catchError((Object e) {
        if (!queuedEmitted) {
          queuedEmitted = true;
          emit(CreateAnalysisError(e.toString()));
        }
      }),
    ]);

    // ── After 3 s: wait for the real response via self-events ─────────────
    // We schedule background self-events rather than awaiting apiFuture here,
    // because the Emitter is invalidated after _onSubmit returns.
    // self-events go through the BLoC's own queue so they're safe.
    if (state is AnalysisQueued) {
      apiFuture.then((response) {
        if (!isClosed) add(_BackgroundResponseReceived(response));
      }).catchError((Object e) {
        if (!isClosed) add(_BackgroundErrorReceived(e.toString()));
      });
    }
  }

  /// Handles the background API response arriving after the optimistic navigation.
  void _onBackgroundResponse(
    _BackgroundResponseReceived event,
    Emitter<CreateAnalysisState> emit,
  ) {
    if (event.response.requiresPayment) {
      // Edge case: payment required but user already sees processing screen.
      emit(CreateAnalysisRequiresPayment(
        analysisId: event.response.id,
        price: kAnalysisPrice,
      ));
    } else {
      // ✅ Analysis complete — CustomBottomNav listener will toast the user.
      emit(AnalysisCompleted(event.response));
    }
  }

  void _onBackgroundError(
    _BackgroundErrorReceived event,
    Emitter<CreateAnalysisState> emit,
  ) {
    emit(CreateAnalysisError(event.message));
  }

  Future<void> _onExecutePaid(
    ExecutePaidAnalysisEvent event,
    Emitter<CreateAnalysisState> emit,
  ) async {
    emit(CreateAnalysisLoading());
    try {
      await _repo.executePaidAnalysis(event.gatewayTransactionId);
      emit(PaidAnalysisExecuted());
    } catch (e) {
      emit(CreateAnalysisError(e.toString()));
    }
  }

  Future<CreateAnalysisResponse> _callEndpoint(SubmitAnalysisEvent event) {
    switch (event.type) {
      case AnalysisType.goalkeeper:
        return _repo.analyzeGoalkeeper(
          targetUserId: event.targetUserId,
          videoUrl: event.videoUrl,
          keeperHeightM: event.keeperHeightM ?? 1.80,
        );
      case AnalysisType.passing:
        return _repo.analyzePassing(
          targetUserId: event.targetUserId,
          videoUrl: event.videoUrl,
        );
      case AnalysisType.dribbling:
        return _repo.analyzeDribbling(
          targetUserId: event.targetUserId,
          videoUrl: event.videoUrl,
        );
      case AnalysisType.match:
        return _repo.analyzeMatch(
          targetUserId: event.targetUserId,
          videoUrl: event.videoUrl,
        );
    }
  }
}

// ── Private self-events ───────────────────────────────────────────────────────

class _BackgroundResponseReceived extends CreateAnalysisEvent {
  final CreateAnalysisResponse response;
  const _BackgroundResponseReceived(this.response);
  @override
  List<Object?> get props => [response];
}

class _BackgroundErrorReceived extends CreateAnalysisEvent {
  final String message;
  const _BackgroundErrorReceived(this.message);
  @override
  List<Object?> get props => [message];
}