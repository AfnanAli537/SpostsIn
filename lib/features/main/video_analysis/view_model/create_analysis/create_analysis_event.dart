import 'package:equatable/equatable.dart';
import '../../data/enums/analysis_type.dart';

abstract class CreateAnalysisEvent extends Equatable {
  const CreateAnalysisEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAnalysisEvent extends CreateAnalysisEvent {
  final AnalysisType type;
  final String targetUserId;
  final String videoUrl;
  final double? keeperHeightM; // only for Goalkeeper

  const SubmitAnalysisEvent({
    required this.type,
    required this.targetUserId,
    required this.videoUrl,
    this.keeperHeightM,
  });

  @override
  List<Object?> get props => [type, targetUserId, videoUrl, keeperHeightM];
}

class ExecutePaidAnalysisEvent extends CreateAnalysisEvent {
  final String gatewayTransactionId;

  const ExecutePaidAnalysisEvent(this.gatewayTransactionId);

  @override
  List<Object?> get props => [gatewayTransactionId];
}