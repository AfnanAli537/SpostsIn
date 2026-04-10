import 'package:equatable/equatable.dart';
import 'package:sports_in/features/main/video_analysis/model/create_analysis_response.dart';

abstract class CreateAnalysisState extends Equatable {
  const CreateAnalysisState();

  @override
  List<Object?> get props => [];
}

class CreateAnalysisInitial extends CreateAnalysisState {}

class CreateAnalysisLoading extends CreateAnalysisState {}

/// Analysis submitted and paid — result available or processing in background.
class CreateAnalysisSuccess extends CreateAnalysisState {
  final CreateAnalysisResponse response;

  const CreateAnalysisSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Backend returned isPaid: false — user must pay before analysis runs.
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