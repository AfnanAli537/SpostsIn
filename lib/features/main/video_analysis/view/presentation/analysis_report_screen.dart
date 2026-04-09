import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/view_model/analysis_bloc.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_type_badge.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_kpis_widget.dart';

class AnalysisReportScreen extends StatelessWidget {
  final String analysisId;

  const AnalysisReportScreen({super.key, required this.analysisId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          if (state is AnalysisReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AnalysisReportError) {
            return _buildError(context, state.message);
          }
          if (state is AnalysisReportLoaded) {
            return _buildContent(context, state.report);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AnalysisReportModel report) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // ── Video hero app bar ─────────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 260.h,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _VideoPlayerView(
              videoUrl: report.analyzedVideoUrl ?? report.originalVideoUrl,
              isAnalyzed: report.analyzedVideoUrl != null,
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────────
                Row(
                  children: [
                    AnalysisTypeBadge(type: report.type),
                    const Spacer(),
                    Text(
                      _formatDate(report.createdAt),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ── Player / Analyst ─────────────────────────────────────────
                _PersonRow(report: report, theme: theme),
                SizedBox(height: 20.h),

                // ── KPI title ────────────────────────────────────────────────
                Text(
                  'Performance Metrics',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),

                // ── Type-aware KPIs ──────────────────────────────────────────
                AnalysisKpisWidget(kpis: report.kpis, type: report.type),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

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
        ElevatedButton(
          onPressed: () =>
              context.read<AnalysisBloc>().add(LoadAnalysisReport(analysisId)),
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Video hero
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// Video player with BetterPlayer
// ─────────────────────────────────────────────────────────────────────────────

class _VideoPlayerView extends StatefulWidget {
  final String videoUrl;
  final bool isAnalyzed;

  const _VideoPlayerView({required this.videoUrl, required this.isAnalyzed});

  @override
  State<_VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<_VideoPlayerView> {
  BetterPlayerController? _controller;
  bool _isInitializing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.videoUrl,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
        ),
      );

      final controller = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: false,
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enablePlayPause: true,
            enableProgressBar: true,
            enableFullscreen: true,
          ),
        ),
        betterPlayerDataSource: dataSource,
      );

      if (mounted) {
        setState(() {
          _controller = controller;
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _error = 'Failed to load video';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 40.sp),
              SizedBox(height: 8.h),
              Text(_error!, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    if (_isInitializing || _controller == null) {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Optional: Add a small label overlay for "Analyzed" / "Original"
    return Stack(
      children: [
        BetterPlayer(controller: _controller!),
        Positioned(
          bottom: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isAnalyzed
                      ? Icons.auto_fix_high_rounded
                      : Icons.videocam_outlined,
                  color: Colors.white70,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  widget.isAnalyzed ? 'Analyzed Video' : 'Original Video',
                  style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Person row
// ─────────────────────────────────────────────────────────────────────────────

class _PersonRow extends StatelessWidget {
  final AnalysisReportModel report;
  final ThemeData theme;

  const _PersonRow({required this.report, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isSelf = report.player.fullName == report.analyst.fullName;

    return Row(
      children: [
        _PersonChip(
          label: 'Player',
          name: report.player.fullName,
          avatar: report.player.profilePicture,
          theme: theme,
          color: const Color(0xFF1565C0),
        ),
        if (!isSelf) ...[
          SizedBox(width: 10.w),
          Icon(
            Icons.arrow_forward_rounded,
            size: 16.sp,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          SizedBox(width: 10.w),
          _PersonChip(
            label: 'Analyst',
            name: report.analyst.fullName,
            avatar: report.analyst.profilePicture,
            theme: theme,
            color: const Color(0xFF6C63FF),
          ),
        ] else ...[
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Text(
              'Self-analysis',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PersonChip extends StatelessWidget {
  final String label;
  final String name;
  final String? avatar;
  final ThemeData theme;
  final Color color;

  const _PersonChip({
    required this.label,
    required this.name,
    required this.avatar,
    required this.theme,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: color.withOpacity(0.07),
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 14.r,
          backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
          backgroundColor: color.withOpacity(0.2),
          child: avatar == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(fontSize: 11.sp, color: color),
                )
              : null,
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
