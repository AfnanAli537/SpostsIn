import 'package:equatable/equatable.dart';
import 'package:sports_in/features/main/video_analysis/model/create_analysis_response.dart';

abstract class CreateAnalysisState extends Equatable {
  const CreateAnalysisState();

  @override
  List<Object?> get props => [];
}

class CreateAnalysisInitial extends CreateAnalysisState {}

/// Uploading video to Cloudinary or waiting for the POST to be dispatched.
class CreateAnalysisLoading extends CreateAnalysisState {}

/// ── OPTIMISTIC STATE ──────────────────────────────────────────────────────────
/// Emitted ~3 s after the API call is fired, regardless of whether the response
/// has arrived yet. The screen navigates to AnalysisProcessingScreen immediately.
/// The API call continues in the background.
class AnalysisQueued extends CreateAnalysisState {
  const AnalysisQueued();
}

/// ── BACKGROUND COMPLETION ────────────────────────────────────────────────────
/// Emitted when the API response finally arrives successfully (paid, analyzed).
/// The main layout listener shows a toast. Navigation has already happened.
class AnalysisCompleted extends CreateAnalysisState {
  final CreateAnalysisResponse  response;

  const AnalysisCompleted(this.response);

  @override
  List<Object?> get props => [response];
}

/// Backend returned isPaid:false — user must pay before analysis runs.
/// Emitted immediately (no 3s delay) since the user needs to act.
class CreateAnalysisRequiresPayment extends CreateAnalysisState {
  final String analysisId;
  final double price;

  const CreateAnalysisRequiresPayment({
    required this.analysisId,
    required this.price,
  });

  @override
  List<Object?> get props => [analysisId, price];
}

/// execute-paid-analysis was called successfully after payment.
class PaidAnalysisExecuted extends CreateAnalysisState {}

class CreateAnalysisError extends CreateAnalysisState {
  final String message;

  const CreateAnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}