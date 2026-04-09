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

// ── Library / Public search (from profile "show all") ─────────────────────────

class LoadAnalysisSearch extends AnalysisEvent {
  /// true → /search/library   false → /search/public
  final bool isLibrary;
  final String? term;
  final String? type;
  final int page;
  final int size;

  const LoadAnalysisSearch({
    required this.isLibrary,
    this.term,
    this.type,
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object?> get props => [isLibrary, term, type, page, size];
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