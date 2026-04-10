import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/video_analysis/view_model/video_analysis_bloc/analysis_bloc.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_list_item_card.dart';
import 'package:sports_in/features/main/video_analysis/view/presentation/analysis_report_screen.dart';
import 'package:sports_in/generated/l10n.dart';

class TargetAnalysesScreen extends StatefulWidget {
  final String targetUserId;
  final String targetName;
  final String? targetAvatar;

  const TargetAnalysesScreen({
    super.key,
    required this.targetUserId,
    required this.targetName,
    this.targetAvatar,
  });

  @override
  State<TargetAnalysesScreen> createState() => _TargetAnalysesScreenState();
}

class _TargetAnalysesScreenState extends State<TargetAnalysesScreen> {
  final _scrollController = ScrollController();
  bool? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AnalysisBloc>().add(const LoadMoreTargetAnalyses());
    }
  }

  void _applyFilter(bool? value) {
    if (_selectedFilter == value) return;
    setState(() => _selectedFilter = value);
    context.read<AnalysisBloc>().add(FilterTargetAnalyses(isPaid: value));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          strings.analyzedVideos,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Profile Header Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundImage: widget.targetAvatar != null
                      ? NetworkImage(widget.targetAvatar!)
                      : null,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: widget.targetAvatar == null
                      ? Text(widget.targetName[0].toUpperCase())
                      : null,
                ),
                SizedBox(width: 12.w),
                Text(
                  widget.targetName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Filters Section
          _buildFilterRow(theme, strings),

          // List Section
          Expanded(
            child: BlocConsumer<AnalysisBloc, AnalysisState>(
              listener: (context, state) {
                if (state is AnalysisDeleteSuccess) {
                  context.read<AnalysisBloc>().add(
                    LoadTargetAnalyses(targetUserId: widget.targetUserId),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(strings.analysisDeleted)),
                  );
                }
              },
              builder: (context, state) {
                if (state is TargetAnalysesLoading) return _buildShimmer();
                if (state is TargetAnalysesError)
                  return _buildError(context, state.message, strings);
                if (state is TargetAnalysesLoaded) {
                  if (state.items.isEmpty) return _buildEmpty(theme, strings);
                  return _buildList(context, state, strings);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(ThemeData theme, S strings) { 
    final filterOptions = [
      (label: strings.all, value: null as bool?),
      (label: strings.analyzed, value: true as bool?),
      (label: strings.pending, value: false as bool?),
    ];
    return Container(
    height: 38.h,
    margin: EdgeInsets.only(bottom: 8.h),
    child: ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      scrollDirection: Axis.horizontal,
      itemCount: filterOptions.length,
      separatorBuilder: (_, __) => SizedBox(width: 8.w),
      itemBuilder: (context, i) {
        final opt = filterOptions[i];
        final selected = _selectedFilter == opt.value;
        return ChoiceChip(
          shadowColor: theme.colorScheme.onError.withOpacity(0.1),
          elevation: 3,
          label: Text(opt.label),
          selected: selected,
          onSelected: (_) => _applyFilter(opt.value),
          selectedColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.onError.withOpacity(0.2),
          labelStyle: TextStyle(
            fontSize: 12.sp,
            color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSecondary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          side: BorderSide.none,
          showCheckmark: false,
        );
      },
    ),
  );}

  Widget _buildList(BuildContext context, TargetAnalysesLoaded state, S strings) =>
      ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount:
            state.items.length + (state is TargetAnalysesLoadingMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i == state.items.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return AnalysisListItemCard(
            item: state.items[i],
            onTap: () => _openReport(context, state.items[i].id),
            onDelete: () => _confirmDelete(context, state.items[i].id, strings),
          );
        },
      );

  void _openReport(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<AnalysisBloc>()..add(LoadAnalysisReport(id)),
          child: AnalysisReportScreen(analysisId: id),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, S strings) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.deleteAnalysis),
        content: Text(strings.deleteAnalysisConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AnalysisBloc>().add(DeleteAnalysis(id));
            },
            child: Text(
              strings.delete,
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

  Widget _buildError(BuildContext context, String message, S strings) => Center(
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
        ElevatedButton(
          onPressed: () => context.read<AnalysisBloc>().add(
            LoadTargetAnalyses(targetUserId: widget.targetUserId),
          ),
          child: Text(strings.retry),
        ),
      ],
    ),
  );

  Widget _buildEmpty(ThemeData theme, S strings) => Center(
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
          strings.noAnalysesFound,
          style: TextStyle(
            fontSize: 15.sp,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    ),
  );
}