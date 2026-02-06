// part of 'opportunity_bloc.dart';


// sealed class OpportunitiesEvent extends Equatable {
//   const OpportunitiesEvent();

//   @override
//   List<Object> get props => [];
// }

// class LoadJobsEvent extends OpportunitiesEvent {}

// class SearchJobsEvent extends OpportunitiesEvent {
//   final String query;

//   const SearchJobsEvent(this.query);

//   @override
//   List<Object> get props => [query];
// }

// class FilterJobsBySportEvent extends OpportunitiesEvent {
//   final String sport;

//   const FilterJobsBySportEvent(this.sport);

//   @override
//   List<Object> get props => [sport];
// }

// class FilterJobsByLocationEvent extends OpportunitiesEvent {
//   final String location;

//   const FilterJobsByLocationEvent(this.location);

//   @override
//   List<Object> get props => [location];
// }

// class FilterJobsByTypeEvent extends OpportunitiesEvent {
//   final String type;

//   const FilterJobsByTypeEvent(this.type);

//   @override
//   List<Object> get props => [type];
// }

// class ClearFiltersEvent extends OpportunitiesEvent {}