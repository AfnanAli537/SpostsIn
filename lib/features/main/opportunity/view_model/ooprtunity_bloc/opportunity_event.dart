part of 'opportunity_bloc.dart';

abstract class OpportunityEvent extends Equatable {
  const OpportunityEvent();

  @override
  List<Object?> get props => [];
}

class FetchOpportunities extends OpportunityEvent {
  final bool isRefresh;

  const FetchOpportunities({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class UpdateSearchTerm extends OpportunityEvent {
  final String searchTerm;

  const UpdateSearchTerm({required this.searchTerm});

  @override
  List<Object?> get props => [searchTerm];
}

class UpdateSportFilter extends OpportunityEvent {
  final int? sportTypeId;
  final String sportName;

  const UpdateSportFilter({
    required this.sportTypeId,
    required this.sportName,
  });

  @override
  List<Object?> get props => [sportTypeId, sportName];
}

class ClearFilters extends OpportunityEvent {
  const ClearFilters();
}

class CreateOpportunity extends OpportunityEvent {
  final String title;
  final String description;
  final String requirements;
  final String endDate;
  final int sportTypeId;
  final String? mediaFile;
  final String? mediaUrl;

  const CreateOpportunity({
    required this.title,
    required this.description,
    required this.requirements,
    required this.endDate,
    required this.sportTypeId,
    this.mediaFile,
    this.mediaUrl,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        requirements,
        endDate,
        sportTypeId,
        mediaFile,
        mediaUrl,
      ];
}

class FetchOpportunityDetails extends OpportunityEvent {
  final String opportunityId;

  const FetchOpportunityDetails({required this.opportunityId});

  @override
  List<Object?> get props => [opportunityId];
}

class ApplyToOpportunity extends OpportunityEvent {
  final String opportunityId;

  const ApplyToOpportunity({required this.opportunityId});

  @override
  List<Object?> get props => [opportunityId];
}
class UpdateOpportunity extends OpportunityEvent {
  final String opportunityId;
  final String title;
  final String description;
  final String requirements;
  final DateTime endDate;
  final int sportTypeId;
  final String? mediaFile;

  const UpdateOpportunity({
    required this.opportunityId,
    required this.title,
    required this.description,
    required this.requirements,
    required this.endDate,
    required this.sportTypeId,
    this.mediaFile,
  });

  @override
  List<Object?> get props => [
        opportunityId,
        title,
        description,
        requirements,
        endDate,
        sportTypeId,
        mediaFile,
      ];
}

class DeleteOpportunity extends OpportunityEvent {
  final String opportunityId;

  const DeleteOpportunity({required this.opportunityId});

  @override
  List<Object?> get props => [opportunityId];
}
class FetchMyOpportunities extends OpportunityEvent {
  final bool showActive; // true = active, false = inactive
  final int page;
  final int pageSize;

  const FetchMyOpportunities({
    this.showActive = true,
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [showActive, page, pageSize];
}