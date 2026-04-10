import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/video_analysis/data/repo/analysis_repo.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_event.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_state.dart';
import '../../data/enums/analysis_type.dart';


class CreateAnalysisBloc
    extends Bloc<CreateAnalysisEvent, CreateAnalysisState> {
  final IAnalysisRepo _repo;

  // Fixed price per analysis (adjust if backend returns dynamic price)
  static const double kAnalysisPrice = 10.0;

  CreateAnalysisBloc(this._repo) : super(CreateAnalysisInitial()) {
    on<SubmitAnalysisEvent>(_onSubmit);
    on<ExecutePaidAnalysisEvent>(_onExecutePaid);
  }

  Future<void> _onSubmit(
    SubmitAnalysisEvent event,
    Emitter<CreateAnalysisState> emit,
  ) async {
    emit(CreateAnalysisLoading());
    try {
      final response = await _callEndpoint(event);

      if (response.requiresPayment) {
        emit(CreateAnalysisRequiresPayment(
          analysisId: response.id,
          price: kAnalysisPrice,
        ));
      } else {
        emit(CreateAnalysisSuccess(response));
      }
    } catch (e) {
      emit(CreateAnalysisError(e.toString()));
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

  Future<dynamic> _callEndpoint(SubmitAnalysisEvent event) {
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