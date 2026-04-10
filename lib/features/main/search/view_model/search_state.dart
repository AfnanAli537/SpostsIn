import 'package:equatable/equatable.dart';
import 'package:sports_in/features/main/search/model/search_result_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoadingMore extends SearchState {
  final List<SearchResultModel> currentResults;
  final String query;
  final SearchFilters? filters;
  const SearchLoadingMore({
    required this.currentResults,
    required this.query,
    this.filters,
  });
  @override
  List<Object?> get props => [currentResults, query, filters];
}

class SearchLoaded extends SearchState {
  final List<SearchResultModel> results;
  final String query;
  final SearchFilters? filters;
  final bool hasMore;
  final int currentPage;

  const SearchLoaded({
    required this.results,
    required this.query,
    this.filters,
    this.hasMore = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [results, query, filters, hasMore, currentPage];
}

class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty(this.query);
  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}

class FilterOptionsLoaded extends SearchState {
  final List<String> locations;
  final List<String> positions;
  final List<String> typesOfPlay;
  const FilterOptionsLoaded({
    required this.locations,
    required this.positions,
    required this.typesOfPlay,
  });
  @override
  List<Object?> get props => [locations, positions, typesOfPlay];
}