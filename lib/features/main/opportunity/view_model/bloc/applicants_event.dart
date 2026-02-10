part of 'applicants_bloc.dart';

sealed class ApplicantsEvent extends Equatable {
  const ApplicantsEvent();

  @override
  List<Object?> get props => [];
}

class FetchApplicants extends ApplicantsEvent {
  final String opportunityId;
  final int pageNumber;
  final int pageSize;
  final String? status;

  const FetchApplicants({
    required this.opportunityId,
    this.pageNumber = 1,
    this.pageSize = 10,
    this.status,
  });

  @override
  List<Object?> get props => [opportunityId, pageNumber, pageSize, status];
}

class AcceptApplicant extends ApplicantsEvent {
  final String applicationId;
  final String? status;

  const AcceptApplicant({
    required this.applicationId,
    this.status
  });

  @override
  List<Object?> get props => [applicationId, status];
}

class RejectApplicant extends ApplicantsEvent {
  final String applicationId;
  final String? status ;

  const RejectApplicant({
    required this.applicationId,
     this.status,
  });

  @override
  List<Object?> get props => [applicationId, status];
}

class LoadMoreApplicants extends ApplicantsEvent {
  final String opportunityId;
  final String? status;

  const LoadMoreApplicants({
    required this.opportunityId,
    this.status,
  });

  @override
  List<Object?> get props => [opportunityId, status];
}