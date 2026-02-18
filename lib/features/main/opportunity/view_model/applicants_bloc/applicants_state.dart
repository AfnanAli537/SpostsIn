part of 'applicants_bloc.dart';

sealed class ApplicantsState extends Equatable {
  const ApplicantsState();

  @override
  List<Object?> get props => [];
}

class ApplicantsInitial extends ApplicantsState {}

class ApplicantsLoading extends ApplicantsState {}

class ApplicantsLoaded extends ApplicantsState {
  final ApplicantsResponseModel response;
  final bool isLoadingMore;

  const ApplicantsLoaded({
    required this.response,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [response, isLoadingMore];

  ApplicantsLoaded copyWith({
    ApplicantsResponseModel? response,
    bool? isLoadingMore,
  }) {
    return ApplicantsLoaded(
      response: response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ApplicantActionLoading extends ApplicantsState {
  final String applicationId;

  const ApplicantActionLoading(this.applicationId);

  @override
  List<Object?> get props => [applicationId];
}

class ApplicantActionSuccess extends ApplicantsState {
  final String message;
  final String applicationId;

  const ApplicantActionSuccess({
    required this.message,
    required this.applicationId,
  });

  @override
  List<Object?> get props => [message, applicationId];
}

class ApplicantsError extends ApplicantsState {
  final String message;

  const ApplicantsError(this.message);

  @override
  List<Object?> get props => [message];
}