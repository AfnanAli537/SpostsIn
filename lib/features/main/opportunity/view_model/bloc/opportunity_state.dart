// part of 'opportunity_bloc.dart';

// sealed  class OpportunitiesState extends Equatable {
//   const OpportunitiesState();

//   @override
//   List<Object> get props => [];
// }

// class OpportunitiesInitial extends OpportunitiesState {}

// class OpportunitiesLoading extends OpportunitiesState {}

// class OpportunitiesLoaded extends OpportunitiesState {
//   final List<OpportunityModel> opportunities;
//   final List<OpportunityModel> filteredOpportunities;
//   final String? selectedFilter;

//   const OpportunitiesLoaded({
//     required this.opportunities,
//     required this.filteredOpportunities,
//     this.selectedFilter,
//   });

//   @override
//   List<Object> get props => [
//         opportunities,
//         filteredOpportunities,
//         selectedFilter ?? '',
//       ];

//   OpportunitiesLoaded copyWith({
//     List<OpportunityModel>? opportunities,
//     List<OpportunityModel>? filteredOpportunities,
//     String? selectedFilter,
//     bool clearFilter = false,
//   }) {
//     return OpportunitiesLoaded(
//       opportunities: opportunities ?? this.opportunities,
//       filteredOpportunities: filteredOpportunities ?? this.filteredOpportunities,
//       selectedFilter: clearFilter ? null : (selectedFilter ?? this.selectedFilter),
//     );
//   }
// }

// class OpportunitiesError extends OpportunitiesState {
//   final String message;

//   const OpportunitiesError(this.message);

//   @override
//   List<Object> get props => [message];
// }