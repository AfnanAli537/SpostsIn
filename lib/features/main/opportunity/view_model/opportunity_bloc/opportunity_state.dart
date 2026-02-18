part of 'opportunity_bloc.dart';

abstract class OpportunityState extends Equatable {
  const OpportunityState();

  @override
  List<Object?> get props => [];
}

class OpportunityInitial extends OpportunityState {}

class OpportunityLoading extends OpportunityState {}

class OpportunityLoadingMore extends OpportunityState {
  final List<OpportunityModel> currentOpportunities;

  const OpportunityLoadingMore(this.currentOpportunities);

  @override
  List<Object?> get props => [currentOpportunities];
}

class OpportunityLoaded extends OpportunityState {
  final List<OpportunityModel> opportunities;
  final bool hasNextPage;
  final int currentPage;
  final int totalCount;
  final String? searchTerm;
  final int? sportTypeId;
  final String? sportName;

  const OpportunityLoaded({
    required this.opportunities,
    required this.hasNextPage,
    required this.currentPage,
    required this.totalCount,
    this.searchTerm,
    this.sportTypeId,
    this.sportName,
  });

  @override
  List<Object?> get props => [
    opportunities,
    hasNextPage,
    currentPage,
    totalCount,
    searchTerm,
    sportTypeId,
    sportName,
  ];

  OpportunityLoaded copyWith({
    List<OpportunityModel>? opportunities,
    bool? hasNextPage,
    int? currentPage,
    int? totalCount,
    String? searchTerm,
    int? sportTypeId,
    String? sportName,
  }) {
    return OpportunityLoaded(
      opportunities: opportunities ?? this.opportunities,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      searchTerm: searchTerm ?? this.searchTerm,
      sportTypeId: sportTypeId ?? this.sportTypeId,
      sportName: sportName ?? this.sportName,
    );
  }
}

class OpportunityError extends OpportunityState {
  final String message;

  const OpportunityError(this.message);

  @override
  List<Object?> get props => [message];
}

class OpportunityDetailsLoading extends OpportunityState {}

class OpportunityDetailsLoaded extends OpportunityState {
  final DetailsModel opportunity;

  const OpportunityDetailsLoaded({required this.opportunity});

  @override
  List<Object?> get props => [opportunity];
}

class OpportunityCreating extends OpportunityState {}

class OpportunityCreated extends OpportunityState {
  const OpportunityCreated();
}

class OpportunityApplying extends OpportunityState {}

class OpportunityApplied extends OpportunityState {
  const OpportunityApplied();
}

class OpportunityUpdateSuccess extends OpportunityState {
  const OpportunityUpdateSuccess();
}

class OpportunityDeleteSuccess extends OpportunityState {
  const OpportunityDeleteSuccess();
}

class MyOpportunitiesLoaded extends OpportunityState {
  final List<OpportunityModel> opportunities;
  final bool hasMore;

  const MyOpportunitiesLoaded({
    required this.opportunities,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [opportunities, hasMore];
}

class OpportunityUpdated extends OpportunityState {
  final String opportunityId;

  const OpportunityUpdated({required this.opportunityId});

  @override
  List<Object?> get props => [opportunityId];
}

class OpportunityDeleted extends OpportunityState {
  final String opportunityId;

  const OpportunityDeleted({required this.opportunityId});

  @override
  List<Object?> get props => [opportunityId];
}
