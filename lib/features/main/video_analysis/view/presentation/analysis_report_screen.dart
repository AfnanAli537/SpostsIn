import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/view_model/analysis_bloc.dart';
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
          // // Hexagonal Rating Badge (Inspired by Image 3)
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFE8F5E9),
          //     borderRadius: BorderRadius.circular(12.r),
          //     border: Border.all(color: Colors.green.shade200),
          //   ),
          //   child: Column(
          //     children: [
          //       Text('SCORE', style: TextStyle(fontSize: 8.sp, color: Colors.green.shade700)),
          //       Text('84', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
          //     ],
          //   ),
          // )
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
// ─────────────────────────────────────────────────────────────────────────────
// Person row
// ─────────────────────────────────────────────────────────────────────────────

// class _PersonRow extends StatelessWidget {
//   final AnalysisReportModel report;
//   final ThemeData theme;

//   const _PersonRow({required this.report, required this.theme});

//   @override
//   Widget build(BuildContext context) {
//     final isSelf = report.player.fullName == report.analyst.fullName;

//     return Row(
//       children: [
//         _PersonChip(
//           label: 'Player',
//           name: report.player.fullName,
//           avatar: report.player.profilePicture,
//           theme: theme,
//           color: const Color(0xFF1565C0),
//         ),
//         if (!isSelf) ...[
//           SizedBox(width: 10.w),
//           Icon(
//             Icons.arrow_forward_rounded,
//             size: 16.sp,
//             color: theme.colorScheme.onSurface.withOpacity(0.3),
//           ),
//           SizedBox(width: 10.w),
//           _PersonChip(
//             label: 'Analyst',
//             name: report.analyst.fullName,
//             avatar: report.analyst.profilePicture,
//             theme: theme,
//             color: const Color(0xFF6C63FF),
//           ),
//         ] else ...[
//           SizedBox(width: 8.w),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//             decoration: BoxDecoration(
//               color: Colors.teal.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20.r),
//               border: Border.all(color: Colors.teal.withOpacity(0.3)),
//             ),
//             child: Text(
//               'Self-analysis',
//               style: TextStyle(
//                 fontSize: 11.sp,
//                 color: Colors.teal,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }

// class _PersonChip extends StatelessWidget {
//   final String label;
//   final String name;
//   final String? avatar;
//   final ThemeData theme;
//   final Color color;

//   const _PersonChip({
//     required this.label,
//     required this.name,
//     required this.avatar,
//     required this.theme,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) => Container(
//     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
//     decoration: BoxDecoration(
//       color: color.withOpacity(0.07),
//       borderRadius: BorderRadius.circular(12.r),
//       border: Border.all(color: color.withOpacity(0.2)),
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         CircleAvatar(
//           radius: 14.r,
//           backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
//           backgroundColor: color.withOpacity(0.2),
//           child: avatar == null
//               ? Text(
//                   name.isNotEmpty ? name[0].toUpperCase() : '?',
//                   style: TextStyle(fontSize: 11.sp, color: color),
//                 )
//               : null,
//         ),
//         SizedBox(width: 8.w),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 10.sp,
//                 color: color,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Text(
//               name,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 fontWeight: FontWeight.w500,
//                 color: theme.colorScheme.onSurface,
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
