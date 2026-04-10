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

  // In-memory context for load-more
  String? _currentTargetUserId;
  String? _lastSearchTargetUserId;
  String? _lastSearchTerm;
  String? _lastSearchType;

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

  // ── Screen 1 — my-analyzed-users ─────────────────────────────────────────

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
      emit(AnalyzedUsersError(e is ApiException ? e.message : e.toString()));
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
      emit(AnalyzedUsersLoaded(
        users: current.users,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
      ));
    }
  }

  // ── Screen 2 — target-analyses ───────────────────────────────────────────

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
      emit(TargetAnalysesError(e is ApiException ? e.message : e.toString()));
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

  // ── Screen 3 — report ────────────────────────────────────────────────────

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
      emit(AnalysisReportError(e is ApiException ? e.message : e.toString()));
    }
  }

  // ── Search — library / selfAnalyses / public ─────────────────────────────

  Future<void> _onLoadAnalysisSearch(
    LoadAnalysisSearch event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      // Cache params for load-more
      _lastSearchTargetUserId = event.targetUserId;
      _lastSearchTerm = event.term;
      _lastSearchType = event.type;

      emit(const AnalysisSearchLoading());

      final page = await _fetchSearchPage(
        mode: event.mode,
        targetUserId: event.targetUserId,
        term: event.term,
        type: event.type,
        page: event.page,
        size: event.size,
      );

      emit(AnalysisSearchLoaded(
        items: page.items,
        hasMore: page.hasNextPage,
        currentPage: page.pageNumber,
        mode: event.mode,
      ));
    } catch (e) {
      log('Error loading analysis search: $e');
      emit(AnalysisSearchError(e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onLoadMoreAnalysisSearch(
    LoadMoreAnalysisSearch event,
    Emitter<AnalysisState> emit,
  ) async {
    final current = state;
    if (current is! AnalysisSearchLoaded || !current.hasMore) return;

    try {
      emit(AnalysisSearchLoadingMore(
        items: current.items,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
        mode: current.mode,
      ));

      final page = await _fetchSearchPage(
        mode: current.mode,
        targetUserId: _lastSearchTargetUserId,
        term: _lastSearchTerm,
        type: _lastSearchType,
        page: current.currentPage + 1,
      );

      emit(AnalysisSearchLoaded(
        items: [...current.items, ...page.items],
        hasMore: page.hasNextPage,
        currentPage: page.pageNumber,
        mode: current.mode,
      ));
    } catch (e) {
      log('Error loading more search results: $e');
      emit(AnalysisSearchLoaded(
        items: current.items,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
        mode: current.mode,
      ));
    }
  }

  /// Shared fetch helper — routes to the correct repo method by mode.
  Future<AnalysisListPage> _fetchSearchPage({
    required AnalysisSearchMode mode,
    String? targetUserId,
    String? term,
    String? type,
    int page = 1,
    int size = 10,
  }) {
    switch (mode) {
      case AnalysisSearchMode.library:
        return _repo.searchLibrary(
          term: term,
          type: type,
          page: page,
          size: size,
        );
      case AnalysisSearchMode.selfAnalyses:
        return _repo.getMySelfAnalyses(
          targetUserId: targetUserId!,
          page: page,
          size: size,
        );
      case AnalysisSearchMode.public:
        return _repo.searchPublic(
          term: term,
          type: type,
          page: page,
          size: size,
        );
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
      emit(AnalysisDeleteError(e is ApiException ? e.message : e.toString()));
    }
  }
}