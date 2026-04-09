import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/video_analysis/view_model/analysis_bloc.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_list_item_card.dart';
import 'package:sports_in/features/main/video_analysis/view/presentation/analysis_report_screen.dart';

/// Shown when user taps "Show All" on the Analyzed Videos section in a profile.
///
/// [isLibrary] true  → /search/library  (own profile, all I created)
/// [isLibrary] false → /search/public   (other profile, public self-analyses)
class AnalysisLibraryScreen extends StatefulWidget {
  final bool isLibrary;
  final String title;

  const AnalysisLibraryScreen({
    super.key,
    required this.isLibrary,
    required this.title,
  });

  @override
  State<AnalysisLibraryScreen> createState() => _AnalysisLibraryScreenState();
}

class _AnalysisLibraryScreenState extends State<AnalysisLibraryScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String? _selectedType; // null = all types

  static const _types = ['Goalkeeper', 'Passing', 'Dribbling', 'Match'];

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
            isLibrary: widget.isLibrary,
            term: _searchController.text.trim().isEmpty
                ? null
                : _searchController.text.trim(),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(54.h),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
            child: _SearchBar(
              controller: _searchController,
              onSubmitted: (_) => _search(),
              theme: theme,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _TypeFilterRow(
            selected: _selectedType,
            types: _types,
            onSelect: _selectType,
            theme: theme,
          ),
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
                if (state is AnalysisSearchLoading) {
                  return _buildShimmer();
                }
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
        itemCount: state.items.length +
            (state is AnalysisSearchLoadingMore ? 1 : 0),
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
                  create: (_) => getIt<AnalysisBloc>()
                    ..add(LoadAnalysisReport(item.id)),
                  child: AnalysisReportScreen(analysisId: item.id),
                ),
              ),
            ),
            // Only allow delete on own library
            onDelete: widget.isLibrary
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
        content:
            const Text('Are you sure you want to delete this analysis?'),
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
            child: Text('Delete',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error)),
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
            Icon(Icons.error_outline,
                size: 52.sp,
                color: Theme.of(context).colorScheme.error),
            SizedBox(height: 12.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _search,
              child: const Text('Retry'),
            ),
          ],
        ),
      );

  Widget _buildEmpty(ThemeData theme) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off_outlined,
                size: 64.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.25)),
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
          hintStyle:
              TextStyle(fontSize: 13.sp, color: Colors.grey.withOpacity(0.7)),
          prefixIcon: Icon(Icons.search_rounded, size: 20.sp),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, size: 18.sp),
                  onPressed: () {
                    controller.clear();
                    onSubmitted('');
                  },
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Type filter row
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
  Widget build(BuildContext context) => Container(
        height: 44.h,
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // "All" chip
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: FilterChip(
                label: const Text('All'),
                selected: selected == null,
                onSelected: (_) => onSelect(null),
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                checkmarkColor: theme.colorScheme.primary,
                labelStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: selected == null
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: selected == null
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            ...types.map(
              (t) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: FilterChip(
                  label: Text(t),
                  selected: selected == t,
                  onSelected: (_) => onSelect(t),
                  selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  checkmarkColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: selected == t
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: selected == t
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}