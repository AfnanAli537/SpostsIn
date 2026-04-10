import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/view_model/video_analysis_bloc/analysis_bloc.dart';
// import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_type_badge.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_kpis_widget.dart';

class AnalysisReportScreen extends StatelessWidget {
  final String analysisId;

  const AnalysisReportScreen({super.key, required this.analysisId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Slightly off-white background
      appBar: AppBar(
        title: Text('Analyzed Video Report', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          if (state is AnalysisReportLoading) return const Center(child: CircularProgressIndicator());
          if (state is AnalysisReportLoaded) return _buildDashboard(context, state.report);
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, AnalysisReportModel report) {
    // final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          // 1. Profile & Rating Header (Inspired by Image 3)
          _ReportProfileHeader(report: report),
          SizedBox(height: 16.h),

          // 2. The Video Card
          _AnalysisVideoCard(
            videoUrl: report.analyzedVideoUrl ?? report.originalVideoUrl,
            isAnalyzed: report.analyzedVideoUrl != null,
          ),
          SizedBox(height: 16.h),

          // 3. Dynamic KPI Sections (Inspired by Image 3 "Goal Completion")
          AnalysisKpisWidget(kpis: report.kpis, type: report.type),
          
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
class _AnalysisVideoCard extends StatelessWidget {
  final String videoUrl;
  final bool isAnalyzed;

  const _AnalysisVideoCard({
    required this.videoUrl, 
    required this.isAnalyzed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r), // More pronounced curves
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // Use ClipRRect to ensure the video follows the card's rounded corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _VideoPlayerView(
                videoUrl: videoUrl,
                isAnalyzed: isAnalyzed,
              ),
            ),
            // Bottom "Label" area inside the card for a cleaner look
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              child: Row(
                children: [
                  Icon(
                    isAnalyzed ? Icons.verified_user : Icons.video_library,
                    size: 16.sp,
                    color: isAnalyzed ? Colors.green : Colors.blue,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isAnalyzed ? 'AI Enhanced Analysis' : 'Original Footage',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Video hero
// ─────────────────────────────────────────────────────────────────────────────
class _ReportProfileHeader extends StatelessWidget {
  final AnalysisReportModel report;

  const _ReportProfileHeader({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundImage: NetworkImage(report.player.profilePicture ?? ''),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.player.fullName, 
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                Text(report.type, 
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
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
