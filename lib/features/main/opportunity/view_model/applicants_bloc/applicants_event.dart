part of 'applicants_bloc.dart';

abstract class ApplicantsEvent extends Equatable {
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

class AcceptApplicant extends ApplicantsEvent {
  final String applicationId;
  final String status;
  final String opportunityId;

  const AcceptApplicant({
    required this.applicationId,
    required this.status,
    required this.opportunityId,
  });

  @override
  List<Object?> get props => [applicationId, status, opportunityId];
}

class RejectApplicant extends ApplicantsEvent {
  final String applicationId;
  final String status;
  final String opportunityId; 

  const RejectApplicant({
    required this.applicationId,
    required this.status,
    required this.opportunityId,
  });

  @override
  List<Object?> get props => [applicationId, status, opportunityId];
}

class FetchRecommendations extends ApplicantsEvent {
  final String opportunityId;
  final int pageNumber;
  final int pageSize;
 
  const FetchRecommendations({
    required this.opportunityId,
    this.pageNumber = 1,
    this.pageSize = 10,
  });
 
  @override
  List<Object?> get props => [opportunityId, pageNumber, pageSize];
}
 