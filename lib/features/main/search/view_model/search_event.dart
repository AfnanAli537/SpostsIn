import 'package:equatable/equatable.dart';
import 'package:sports_in/features/main/search/model/search_result_model.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchWithFilters extends SearchEvent {
  final String query;
  final SearchFilters? filters; // nullable now

  const SearchWithFilters({
    required this.query,
    this.filters,
  });

  @override
  List<Object?> get props => [query, filters];
}
class LoadFilterOptions extends SearchEvent {}

class ClearSearch extends SearchEvent {}

class UpdateFilters extends SearchEvent {
  final SearchFilters filters;

  const UpdateFilters(this.filters);

  @override
  List<Object?> get props => [filters];
}