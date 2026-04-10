import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/video_analysis/data/repo/analysis_repo.dart';
import 'package:sports_in/features/main/video_analysis/model/create_analysis_response.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_event.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_state.dart';
import '../../data/enums/analysis_type.dart';


class CreateAnalysisBloc
    extends Bloc<CreateAnalysisEvent, CreateAnalysisState> {
  final IAnalysisRepo _repo;

  /// Price shown on the payment screen when isPaid:false is returned.
  static const double kAnalysisPrice = 10.0;

  /// How long to wait before navigating to the processing screen regardless
  /// of whether the API has responded yet.
  static const Duration _optimisticDelay = Duration(seconds: 3);

  CreateAnalysisBloc(this._repo) : super(CreateAnalysisInitial()) {
    on<SubmitAnalysisEvent>(_onSubmit);
    on<ExecutePaidAnalysisEvent>(_onExecutePaid);
  }

  Future<void> _onSubmit(
    SubmitAnalysisEvent event,
    Emitter<CreateAnalysisState> emit,
  ) async {
    emit(CreateAnalysisLoading());

    // ── Fire the API call without awaiting it yet ──────────────────────────
    final apiFuture = _callEndpoint(event);

    // ── Race: whichever comes first — 3s timer OR api response ─────────────
    bool queuedEmitted = false;

    await Future.any([
      // Branch A: 3 seconds elapsed → emit optimistic AnalysisQueued
      Future.delayed(_optimisticDelay).then((_) {
        if (!queuedEmitted && !isClosed) {
          queuedEmitted = true;
          emit(const AnalysisQueued());
        }
      }),

      // Branch B: API responded before 3 seconds
      apiFuture.then((response) {
        if (!queuedEmitted) {
          // Fast response (< 3s) — handle immediately without showing processing
          queuedEmitted = true; // prevent the timer from re-emitting
          if (response.requiresPayment) {
            emit(CreateAnalysisRequiresPayment(
              analysisId: response.id,
              price: kAnalysisPrice,
            ));
          } else {
            // Paid & done before 3s — treat same as queued then immediately complete
            emit(const AnalysisQueued());
            emit(AnalysisCompleted(response));
          }
        }
      }).catchError((e) {
        if (!queuedEmitted) {
          queuedEmitted = true;
          emit(CreateAnalysisError(e.toString()));
        }
      }),
    ]);

    // ── If we emitted AnalysisQueued, wait for the API to finish in bg ─────
    if (state is AnalysisQueued) {
      try {
        final response = await apiFuture;

        if (isClosed) return;

        if (response.requiresPayment) {
          // Rare: payment required but we already showed processing screen.
          // Emit payment state — the form screen or main layout listener
          // can intercept and redirect.
          emit(CreateAnalysisRequiresPayment(
            analysisId: response.id,
            price: kAnalysisPrice,
          ));
        } else {
          // ✅ Analysis done — emit completion so main layout shows toast.
          emit(AnalysisCompleted(response));
        }
      } catch (e) {
        if (!isClosed) {
          emit(CreateAnalysisError(e.toString()));
        }
      }
    }
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