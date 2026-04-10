import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/video_analysis/view_model/video_analysis_bloc/analysis_bloc.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_list_item_card.dart';
import 'package:sports_in/features/main/video_analysis/view/presentation/analysis_report_screen.dart';

/// Shown from the profile "Show All" button on the Analyzed Videos section.
///
/// mode = AnalysisSearchMode.library      → own profile  → /search/library
/// mode = AnalysisSearchMode.selfAnalyses → other profile → /my-self-analyses
class AnalysisLibraryScreen extends StatefulWidget {
  final AnalysisSearchMode mode;
  final String title;

  /// Required when mode == selfAnalyses
  final String? targetUserId;

  const AnalysisLibraryScreen({
    super.key,
    required this.mode,
    required this.title,
    this.targetUserId,
  });

  @override
  State<AnalysisLibraryScreen> createState() => _AnalysisLibraryScreenState();
}

class _AnalysisLibraryScreenState extends State<AnalysisLibraryScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String? _selectedType;

  static const _types = ['Goalkeeper', 'Passing', 'Dribbling', 'Match'];

  // Search bar is only meaningful in library mode
  bool get _isLibrary => widget.mode == AnalysisSearchMode.library;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AnalysisBloc>().add(const LoadMoreAnalysisSearch());
    }
  }

  void _search() {
    context.read<AnalysisBloc>().add(
      LoadAnalysisSearch(
        mode: widget.mode,
        targetUserId: widget.targetUserId,
        term: _isLibrary && _searchController.text.trim().isNotEmpty
            ? _searchController.text.trim()
            : null,
        type: _selectedType,
      ),
    );
  }

  void _selectType(String? type) {
    if (_selectedType == type) return;
    setState(() => _selectedType = type);
    _search();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
        bottom: _isLibrary
            ? PreferredSize(
                preferredSize: Size.fromHeight(54.h),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                  child: _SearchBar(
                    controller: _searchController,
                    onSubmitted: (_) => _search(),
                    theme: theme,
                  ),
                ),
              )
            : null,
      ),
      body: Column(
        children: [
          _isLibrary
              ? _TypeFilterRow(
                  selected: _selectedType,
                  types: _types,
                  onSelect: _selectType,
                  theme: theme,
                )
              : const SizedBox.shrink(),
          Expanded(
            child: BlocConsumer<AnalysisBloc, AnalysisState>(
              listener: (context, state) {
                if (state is AnalysisDeleteSuccess) {
                  _search();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Analysis deleted')),
                  );
                }
              },
              builder: (context, state) {
                if (state is AnalysisSearchLoading) return _buildShimmer();
                if (state is AnalysisSearchError) {
                  return _buildError(context, state.message);
                }
                if (state is AnalysisSearchLoaded) {
                  if (state.items.isEmpty) return _buildEmpty(theme);
                  return _buildList(context, state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, AnalysisSearchLoaded state) =>
      ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(top: 4.h, bottom: 24.h),
        itemCount:
            state.items.length + (state is AnalysisSearchLoadingMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i == state.items.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: const CircularProgressIndicator(),
              ),
            );
          }
          final item = state.items[i];
          return AnalysisListItemCard(
            item: item,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) =>
                      getIt<AnalysisBloc>()..add(LoadAnalysisReport(item.id)),
                  child: AnalysisReportScreen(analysisId: item.id),
                ),
              ),
            ),
            // Delete only available in own library
            onDelete: widget.mode == AnalysisSearchMode.library
                ? () => _confirmDelete(context, item.id)
                : null,
          );
        },
      );

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Analysis'),
        content: const Text('Are you sure you want to delete this analysis?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AnalysisBloc>().add(DeleteAnalysis(id));
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() => Skeletonizer(
    enabled: true,
    child: ListView.builder(
      padding: EdgeInsets.only(top: 4.h),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    ),
  );

  Widget _buildError(BuildContext context, String message) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 52.sp,
          color: Theme.of(context).colorScheme.error,
        ),
        SizedBox(height: 12.h),
        Text(message, textAlign: TextAlign.center),
        SizedBox(height: 16.h),
        ElevatedButton(onPressed: _search, child: const Text('Retry')),
      ],
    ),
  );

  Widget _buildEmpty(ThemeData theme) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.videocam_off_outlined,
          size: 64.sp,
          color: theme.colorScheme.onSurface.withOpacity(0.25),
        ),
        SizedBox(height: 16.h),
        Text(
          'No analyses found',
          style: TextStyle(
            fontSize: 15.sp,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Search bar
// ─────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final ThemeData theme;

  const _SearchBar({
    required this.controller,
    required this.onSubmitted,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onSubmitted: onSubmitted,
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: 'Search by player name…',
      hintStyle: TextStyle(
        fontSize: 13.sp,
        color: Colors.grey.withOpacity(0.7),
      ),
      prefixIcon: Icon(Icons.search_rounded, size: 20.sp),
      filled: true,
      fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Type filter chips
// ─────────────────────────────────────────────────────────────────────────────

class _TypeFilterRow extends StatelessWidget {
  final String? selected;
  final List<String> types;
  final ValueChanged<String?> onSelect;
  final ThemeData theme;

  const _TypeFilterRow({
    required this.selected,
    required this.types,
    required this.onSelect,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final allOptions = [null, ...types];
    return Container(
      height: 38.h,
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: allOptions.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final option = allOptions[i];
          final isSelected = selected == option;
          return ChoiceChip(
            label: Text(option ?? 'All'),
            selected: isSelected,
            onSelected: (_) => onSelect(option),
            selectedColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.onError.withOpacity(0.2),
            labelStyle: TextStyle(
              fontSize: 12.sp,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            side: BorderSide.none,
            showCheckmark: false,
          );
        },
      ),
    );
  }
}
