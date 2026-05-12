import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../data/repo/search_repo.dart';
import '../model/search_result_model.dart';

import 'search_event.dart';
import 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepo _repository;

  SearchBloc(this._repository) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchWithFilters>(_onSearchWithFilters);
    on<LoadFilterOptions>(_onLoadFilterOptions);
    on<ClearSearch>(_onClearSearch);
    on<UpdateFilters>(_onUpdateFilters);
    on<LoadMoreResults>(_onLoadMoreResults);
  }

  // Helper to get current filters with pageNumber reset to 1
  SearchFilters _resetPage(SearchFilters? filters) {
    return (filters ?? SearchFilters()).copyWith(pageNumber: 1);
  }

  // Helper to get next page filters
  SearchFilters _nextPage(SearchFilters? filters, int currentPage) {
    return (filters ?? SearchFilters()).copyWith(pageNumber: currentPage + 1);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    // Reset pagination
    final freshFilters = _resetPage(null);
    emit(SearchLoading());
    try {
      final results = await _repository.search(
        query: event.query,
        filters: freshFilters,
      );
      final hasMore = results.length >= (freshFilters.pageSize);
      if (results.isEmpty) {
        emit(SearchEmpty(event.query));
      } else {
        emit(SearchLoaded(
          results: results,
          query: event.query,
          filters: freshFilters,
          hasMore: hasMore,
          currentPage: 1,
        ));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchWithFilters(
    SearchWithFilters event,
    Emitter<SearchState> emit,
  ) async {
    // Reset pagination: start from page 1
    final freshFilters = _resetPage(event.filters);
    emit(SearchLoading());
    try {
      final results = await _repository.search(
        query: event.query,
        filters: freshFilters,
      );
      final hasMore = results.length >= (freshFilters.pageSize);
      if (results.isEmpty) {
        emit(SearchEmpty(event.query));
      } else {
        emit(SearchLoaded(
          results: results,
          query: event.query,
          filters: freshFilters,
          hasMore: hasMore,
          currentPage: 1,
        ));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
Future<void> _onLoadMoreResults(
  LoadMoreResults event,
  Emitter<SearchState> emit,
) async {
  final currentState = state;
  if (currentState is! SearchLoaded) return;
  if (!currentState.hasMore) return;
  if (state is SearchLoadingMore) return;

  final nextFilters = _nextPage(currentState.filters, currentState.currentPage);
  emit(SearchLoadingMore(
    currentResults: currentState.results,
    query: currentState.query,
    filters: nextFilters,
  ));

  try {
    final newResults = await _repository.search(
      query: currentState.query,
      filters: nextFilters,
    );
    final updatedResults = [...currentState.results, ...newResults];
    final hasMore = newResults.length >= (nextFilters.pageSize);

    // No mounted check needed; bloc can still emit
    emit(SearchLoaded(
      results: updatedResults,
      query: currentState.query,
      filters: nextFilters,
      hasMore: hasMore,
      currentPage: nextFilters.pageNumber,
    ));
  } catch (e) {
    // Revert to previous state
    emit(currentState);
    // Optionally, you could emit an error state but keep results
  }
}
  Future<void> _onLoadFilterOptions(
    LoadFilterOptions event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final locations = await _repository.getLocations();
      final positions = await _repository.getPositions();
      final typesOfPlay = await _repository.getTypesOfPlay();
      emit(FilterOptionsLoaded(
        locations: locations,
        positions: positions,
        typesOfPlay: typesOfPlay,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }

  void _onUpdateFilters(UpdateFilters event, Emitter<SearchState> emit) {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(SearchLoaded(
        results: currentState.results,
        query: currentState.query,
        filters: event.filters,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
      ));
    }
  }
}