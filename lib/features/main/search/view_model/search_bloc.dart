import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../data/repo/search_repo.dart';
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
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final results = await _repository.search(query: event.query);
      
      if (results.isEmpty) {
        emit(SearchEmpty(event.query));
      } else {
        emit(SearchLoaded(results: results, query: event.query));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchWithFilters(
    SearchWithFilters event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(SearchLoading());
      final results = await _repository.search(
        query: event.query,
        filters: event.filters,
      );
      
      if (results.isEmpty) {
        emit(SearchEmpty(event.query));
      } else {
        emit(SearchLoaded(
          results: results,
          query: event.query,
          filters: event.filters,
        ));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
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

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchInitial());
  }

  Future<void> _onUpdateFilters(
    UpdateFilters event,
    Emitter<SearchState> emit,
  ) async {
    // Just update the state with new filters
    // The UI will trigger SearchWithFilters when ready
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(SearchLoaded(
        results: currentState.results,
        query: currentState.query,
        filters: event.filters,
      ));
    }
  }
}