import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/video_analysis/data/repo/analysis_repo.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

@injectable
class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final IAnalysisRepo _repo;

  // Kept in-memory for load-more context
  String? _currentTargetUserId;

  AnalysisBloc(this._repo) : super(const AnalysisInitial()) {
    on<LoadAnalyzedUsers>(_onLoadAnalyzedUsers);
    on<LoadMoreAnalyzedUsers>(_onLoadMoreAnalyzedUsers);
    on<LoadTargetAnalyses>(_onLoadTargetAnalyses);
    on<LoadMoreTargetAnalyses>(_onLoadMoreTargetAnalyses);
    on<FilterTargetAnalyses>(_onFilterTargetAnalyses);
    on<LoadAnalysisReport>(_onLoadAnalysisReport);
    on<LoadAnalysisSearch>(_onLoadAnalysisSearch);
    on<LoadMoreAnalysisSearch>(_onLoadMoreAnalysisSearch);
    on<DeleteAnalysis>(_onDeleteAnalysis);
  }

  // ── Screen 1 ──────────────────────────────────────────────────────────────

  Future<void> _onLoadAnalyzedUsers(
    LoadAnalyzedUsers event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      emit(const AnalyzedUsersLoading());
      final page = await _repo.getMyAnalyzedUsers(
        page: event.page,
        size: event.size,
      );
      emit(AnalyzedUsersLoaded(
        users: page.items,
        hasMore: page.hasNextPage,
        currentPage: page.pageNumber,
      ));
    } catch (e) {
      log('Error fetching analyzed users: $e');
      emit(AnalyzedUsersError(
          e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onLoadMoreAnalyzedUsers(
    LoadMoreAnalyzedUsers event,
    Emitter<AnalysisState> emit,
  ) async {
    final current = state;
    if (current is! AnalyzedUsersLoaded || !current.hasMore) return;

    try {
      emit(AnalyzedUsersLoadingMore(
        users: current.users,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
      ));
      final page = await _repo.getMyAnalyzedUsers(
        page: current.currentPage + 1,
      );
      emit(AnalyzedUsersLoaded(
        users: [...current.users, ...page.items],
        hasMore: page.hasNextPage,
        currentPage: page.pageNumber,
      ));
    } catch (e) {
      log('Error loading more analyzed users: $e');
      // Restore previous loaded state so the list stays visible
      emit(AnalyzedUsersLoaded(
        users: current.users,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
      ));
    }
  }

  // ── Screen 2 ──────────────────────────────────────────────────────────────

  Future<void> _onLoadTargetAnalyses(
    LoadTargetAnalyses event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      _currentTargetUserId = event.targetUserId;
      emit(const TargetAnalysesLoading());
      final page = await _repo.getTargetAnalyses(
        targetUserId: event.targetUserId,
        isPaid: event.isPaid,
        page: event.page,
        size: event.size,
      );
      emit(TargetAnalysesLoaded(
        items: page.items,
        hasMore: page.hasNextPage,
        currentPage: page.pageNumber,
        isPaidFilter: event.isPaid,
      ));
    } catch (e) {
      log('Error fetching target analyses: $e');
      emit(TargetAnalysesError(
          e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onLoadMoreTargetAnalyses(
    LoadMoreTargetAnalyses event,
    Emitter<AnalysisState> emit,
  ) async {
    final current = state;
    if (current is! TargetAnalysesLoaded ||
        !current.hasMore ||
        _currentTargetUserId == null) return;

    try {
      emit(TargetAnalysesLoadingMore(
        items: current.items,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
        isPaidFilter: current.isPaidFilter,
      ));
      final page = await _repo.getTargetAnalyses(
        targetUserId: _currentTargetUserId!,
        isPaid: current.isPaidFilter,
        page: current.currentPage + 1,
      );
      emit(TargetAnalysesLoaded(
        items: [...current.items, ...page.items],
        hasMore: page.hasNextPage,
        currentPage: page.pageNumber,
        isPaidFilter: current.isPaidFilter,
      ));
    } catch (e) {
      log('Error loading more target analyses: $e');
      // Restore previous loaded state
      emit(TargetAnalysesLoaded(
        items: current.items,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
        isPaidFilter: current.isPaidFilter,
      ));
    }
  }

  Future<void> _onFilterTargetAnalyses(
    FilterTargetAnalyses event,
    Emitter<AnalysisState> emit,
  ) async {
    if (_currentTargetUserId == null) return;
    add(LoadTargetAnalyses(
      targetUserId: _currentTargetUserId!,
      isPaid: event.isPaid,
    ));
  }

  // ── Screen 3 ──────────────────────────────────────────────────────────────

  Future<void> _onLoadAnalysisReport(
    LoadAnalysisReport event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      emit(const AnalysisReportLoading());
      final report = await _repo.getReport(event.id);
      emit(AnalysisReportLoaded(report));
    } catch (e) {
      log('Error fetching analysis report: $e');
      emit(AnalysisReportError(
          e is ApiException ? e.message : e.toString()));
    }
  }

  // ── Library / Public search ────────────────────────────────────────────────

  // Tracks last search params for load-more
  bool? _lastSearchIsLibrary;
  String? _lastSearchTerm;
  String? _lastSearchType;

  Future<void> _onLoadAnalysisSearch(
    LoadAnalysisSearch event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      _lastSearchIsLibrary = event.isLibrary;
      _lastSearchTerm = event.term;
      _lastSearchType = event.type;

      emit(const AnalysisSearchLoading());

      final page = event.isLibrary
          ? await _repo.searchLibrary(
              term: event.term,
              type: event.type,
              page: event.page,
              size: event.size,
            )
          : await _repo.searchPublic(
              term: event.term,
              type: event.type,
              page: event.page,
              size: event.size,
            );

      emit(AnalysisSearchLoaded(
        items: page.items,
        hasMore: page.hasNextPage,
        currentPage: page.pageNumber,
        isLibrary: event.isLibrary,
      ));
    } catch (e) {
      log('Error loading analysis search: $e');
      emit(AnalysisSearchError(
          e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onLoadMoreAnalysisSearch(
    LoadMoreAnalysisSearch event,
    Emitter<AnalysisState> emit,
  ) async {
    final current = state;
    if (current is! AnalysisSearchLoaded ||
        !current.hasMore ||
        _lastSearchIsLibrary == null) return;

    try {
      emit(AnalysisSearchLoadingMore(
        items: current.items,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
        isLibrary: current.isLibrary,
      ));

      final page = current.isLibrary
          ? await _repo.searchLibrary(
              term: _lastSearchTerm,
              type: _lastSearchType,
              page: current.currentPage + 1,
            )
          : await _repo.searchPublic(
              term: _lastSearchTerm,
              type: _lastSearchType,
              page: current.currentPage + 1,
            );

      emit(AnalysisSearchLoaded(
        items: [...current.items, ...page.items],
        hasMore: page.hasNextPage,
        currentPage: page.pageNumber,
        isLibrary: current.isLibrary,
      ));
    } catch (e) {
      log('Error loading more search results: $e');
      emit(AnalysisSearchLoaded(
        items: current.items,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
        isLibrary: current.isLibrary,
      ));
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> _onDeleteAnalysis(
    DeleteAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      await _repo.deleteAnalysis(event.id);
      emit(AnalysisDeleteSuccess(event.id));
    } catch (e) {
      log('Error deleting analysis: $e');
      emit(AnalysisDeleteError(
          e is ApiException ? e.message : e.toString()));
    }
  }
}