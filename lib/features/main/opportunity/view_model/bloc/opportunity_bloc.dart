// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';

// part 'opportunity_event.dart';
// part 'opportunity_state.dart';


// class OpportunitiesBloc extends Bloc<OpportunitiesEvent, OpportunitiesState> {
//   OpportunitiesBloc() : super(OpportunitiesInitial()) {
//     on<LoadOpportunitiesEvent>(_onLoadOpportunities);
//     on<FilterOpportunitiesEvent>(_onFilterOpportunities);
//   }

//   Future<void> _onLoadOpportunities(
//       LoadOpportunitiesEvent event, Emitter<OpportunitiesState> emit) async {
//     emit(OpportunitiesLoading());
//     try {
//       // Simulate API call
//       await Future.delayed(const Duration(milliseconds: 500));
      
//       final opportunities = _getMockOpportunities();
//       emit(OpportunitiesLoaded(
//         opportunities: opportunities,
//         filteredOpportunities: opportunities,
//       ));
//     } catch (e) {
//       emit(OpportunitiesError(e.toString()));
//     }
//   }

//   void _onFilterOpportunities(
//       FilterOpportunitiesEvent event, Emitter<OpportunitiesState> emit) {
//     if (state is OpportunitiesLoaded) {
//       final currentState = state as OpportunitiesLoaded;
      
//       List<Opportunity> filtered = currentState.opportunities;
      
//       if (event.filter.isNotEmpty) {
//         filtered = filtered.where((opportunity) {
//           return opportunity.title.toLowerCase().contains(event.filter.toLowerCase()) ||
//               opportunity.location.toLowerCase().contains(event.filter.toLowerCase());
//         }).toList();
//       }
      
//       emit(currentState.copyWith(
//         filteredOpportunities: filtered,
//         selectedFilter: event.filter.isEmpty ? null : event.filter,
//       ));
//     }
//   }

//   List<Opportunity> _getMockOpportunities() {
//     return [
//       Opportunity(
//         id: '1',
//         title: 'Summer Training Camp',
//         location: 'California',
//         duration: 'June 15 - Aug 30',
//         imagePath: '🏕️',
//       ),
//       Opportunity(
//         id: '2',
//         title: 'Youth Basketball League',
//         location: 'New York',
//         duration: 'Sep 1 - Dec 15',
//         imagePath: '🏀',
//       ),
//       Opportunity(
//         id: '3',
//         title: 'Soccer Academy',
//         location: 'Texas',
//         duration: 'Year Round',
//         imagePath: '⚽',
//       ),
//     ];
//   }
// }