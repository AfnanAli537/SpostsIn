part of 'analysis_bloc.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object?> get props => [];
}

class AnalysisInitial extends AnalysisState {
  const AnalysisInitial();
}

// ── Screen 1 ─────────────────────────────────────────────────────────────────

class AnalyzedUsersLoading extends AnalysisState {
  const AnalyzedUsersLoading();
}

class AnalyzedUsersLoaded extends AnalysisState {
  final List<AnalyzedUserModel> users;
  final bool hasMore;
  final int currentPage;

  const AnalyzedUsersLoaded({
    required this.users,
    required this.hasMore,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [users, hasMore, currentPage];
}

class AnalyzedUsersLoadingMore extends AnalyzedUsersLoaded {
  const AnalyzedUsersLoadingMore({
    required super.users,
    required super.hasMore,
    required super.currentPage,
  });
}

class AnalyzedUsersError extends AnalysisState {
  final String message;

  const AnalyzedUsersError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Screen 2 ─────────────────────────────────────────────────────────────────

class TargetAnalysesLoading extends AnalysisState {
  const TargetAnalysesLoading();
}

class TargetAnalysesLoaded extends AnalysisState {
  final List<AnalysisListItemModel> items;
  final bool hasMore;
  final int currentPage;
  final bool? isPaidFilter;

  const TargetAnalysesLoaded({
    required this.items,
    required this.hasMore,
    required this.currentPage,
    this.isPaidFilter,
  });

  @override
  List<Object?> get props => [items, hasMore, currentPage, isPaidFilter];
}

class TargetAnalysesLoadingMore extends TargetAnalysesLoaded {
  const TargetAnalysesLoadingMore({
    required super.items,
    required super.hasMore,
    required super.currentPage,
    super.isPaidFilter,
  });
}

class TargetAnalysesError extends AnalysisState {
  final String message;

  const TargetAnalysesError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Screen 3 ─────────────────────────────────────────────────────────────────

class AnalysisReportLoading extends AnalysisState {
  const AnalysisReportLoading();
}

class AnalysisReportLoaded extends AnalysisState {
  final AnalysisReportModel report;

  const AnalysisReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class AnalysisReportError extends AnalysisState {
  final String message;

  const AnalysisReportError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Search (library / selfAnalyses / public) ──────────────────────────────────

class AnalysisSearchLoading extends AnalysisState {
  const AnalysisSearchLoading();
}

class AnalysisSearchLoaded extends AnalysisState {
  final List<AnalysisListItemModel> items;
  final bool hasMore;
  final int currentPage;
  final AnalysisSearchMode mode;

  const AnalysisSearchLoaded({
    required this.items,
    required this.hasMore,
    required this.currentPage,
    required this.mode,
  });

  @override
  List<Object?> get props => [items, hasMore, currentPage, mode];
}

class AnalysisSearchLoadingMore extends AnalysisSearchLoaded {
  const AnalysisSearchLoadingMore({
    required super.items,
    required super.hasMore,
    required super.currentPage,
    required super.mode,
  });
}

class AnalysisSearchError extends AnalysisState {
  final String message;

  const AnalysisSearchError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Delete ────────────────────────────────────────────────────────────────────

class AnalysisDeleteSuccess extends AnalysisState {
  final String deletedId;

  const AnalysisDeleteSuccess(this.deletedId);

  @override
  List<Object?> get props => [deletedId];
}

class AnalysisDeleteError extends AnalysisState {
  final String message;

  const AnalysisDeleteError(this.message);

  @override
  List<Object?> get props => [message];
}