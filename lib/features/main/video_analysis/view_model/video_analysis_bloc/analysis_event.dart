part of 'analysis_bloc.dart';

abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();

  @override
  List<Object?> get props => [];
}

// ── Screen 1 — my-analyzed-users ─────────────────────────────────────────────

class LoadAnalyzedUsers extends AnalysisEvent {
  final int page;
  final int size;

  const LoadAnalyzedUsers({this.page = 1, this.size = 10});

  @override
  List<Object?> get props => [page, size];
}

class LoadMoreAnalyzedUsers extends AnalysisEvent {
  const LoadMoreAnalyzedUsers();
}

// ── Screen 2 — target-analyses ───────────────────────────────────────────────

class LoadTargetAnalyses extends AnalysisEvent {
  final String targetUserId;
  final bool? isPaid;
  final int page;
  final int size;

  const LoadTargetAnalyses({
    required this.targetUserId,
    this.isPaid,
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object?> get props => [targetUserId, isPaid, page, size];
}

class LoadMoreTargetAnalyses extends AnalysisEvent {
  const LoadMoreTargetAnalyses();
}

class FilterTargetAnalyses extends AnalysisEvent {
  final bool? isPaid;

  const FilterTargetAnalyses({this.isPaid});

  @override
  List<Object?> get props => [isPaid];
}

// ── Screen 3 — report ────────────────────────────────────────────────────────

class LoadAnalysisReport extends AnalysisEvent {
  final String id;

  const LoadAnalysisReport(this.id);

  @override
  List<Object?> get props => [id];
}

// ── Library / SelfAnalyses / Public search ────────────────────────────────────
//
// mode = AnalysisSearchMode.library     → /search/library       (own profile show-all)
// mode = AnalysisSearchMode.selfAnalyses → /my-self-analyses    (other profile show-all)
// mode = AnalysisSearchMode.public      → /search/public        (search screen tab)

enum AnalysisSearchMode { library, selfAnalyses, public }

class LoadAnalysisSearch extends AnalysisEvent {
  final AnalysisSearchMode mode;

  /// Required when mode == selfAnalyses
  final String? targetUserId;

  /// Optional search/filter params (used for library + public)
  final String? term;
  final String? type;
  final int page;
  final int size;

  const LoadAnalysisSearch({
    required this.mode,
    this.targetUserId,
    this.term,
    this.type,
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object?> get props => [mode, targetUserId, term, type, page, size];
}

class LoadMoreAnalysisSearch extends AnalysisEvent {
  const LoadMoreAnalysisSearch();
}

// ── Delete ────────────────────────────────────────────────────────────────────

class DeleteAnalysis extends AnalysisEvent {
  final String id;

  const DeleteAnalysis(this.id);

  @override
  List<Object?> get props => [id];
}