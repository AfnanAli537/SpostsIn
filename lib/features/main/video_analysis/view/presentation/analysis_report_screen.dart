import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/video_analysis/data/enums/analysis_type.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/view/presentation/analysis_payment_screen.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_kpis_widget.dart';
import 'package:sports_in/features/main/video_analysis/view_model/video_analysis_bloc/analysis_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class AnalysisReportScreen extends StatelessWidget {
  final String analysisId;

  const AnalysisReportScreen({super.key, required this.analysisId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          strings.analyzedVideoReport,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          if (state is AnalysisReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AnalysisReportLoaded) {
            return _buildDashboard(context, state.report, strings);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, AnalysisReportModel report, S strings) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(children: [
        // Profile header
        _ReportProfileHeader(report: report, strings: strings),
        SizedBox(height: 16.h),

        // Unpaid banner — shown prominently before the video
        if (!report.isPaid) ...[
          _UnpaidBanner(report: report, strings: strings),
          SizedBox(height: 16.h),
        ],

        // Video card
        _AnalysisVideoCard(
          videoUrl: report.analyzedVideoUrl ?? report.originalVideoUrl,
          isAnalyzed: report.analyzedVideoUrl != null,
          isLocked: !report.isPaid,
          strings: strings,
        ),
        SizedBox(height: 16.h),

        // KPIs — shown even when unpaid so the user sees a preview
        // (all values will be zero from the backend, acting as a teaser)
        AnalysisKpisWidget(kpis: report.kpis, type: report.type, strings: strings),

        SizedBox(height: 32.h),
      ]),
    );
  }
}

// ── Unpaid banner ─────────────────────────────────────────────────────────────

class _UnpaidBanner extends StatelessWidget {
  final AnalysisReportModel report;
  final S strings;
  const _UnpaidBanner({required this.report, required this.strings});

  AnalysisType _typeFromString(String t) {
    switch (t) {
      case 'Goalkeeper':
        return AnalysisType.goalkeeper;
      case 'Passing':
        return AnalysisType.passing;
      case 'Dribbling':
        return AnalysisType.dribbling;
      default:
        return AnalysisType.match;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primary.withOpacity(0.9),
            theme.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_outline,
                  color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.analysisPendingPayment,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      strings.completePaymentToUnlock,
                      style: TextStyle(
                          color: Colors.white70, fontSize: 11.sp, height: 1.4),
                    ),
                  ]),
            ),
          ]),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnalysisPaymentScreen(
                      analysisId: report.id,
                      price: 10.0,
                      analysisType: _typeFromString(report.type),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.payment_rounded,
                  size: 16.sp, color: theme.primary),
              label: Text(
                strings.payNowToUnlock,
                style: TextStyle(
                  color: theme.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Video card ────────────────────────────────────────────────────────────────

class _AnalysisVideoCard extends StatelessWidget {
  final String videoUrl;
  final bool isAnalyzed;
  final bool isLocked;
  final S strings;

  const _AnalysisVideoCard({
    required this.videoUrl,
    required this.isAnalyzed,
    required this.isLocked,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: isLocked
                ? _LockedVideoPlaceholder(strings: strings)
                : _VideoPlayerView(
                    videoUrl: videoUrl, isAnalyzed: isAnalyzed, strings: strings),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(children: [
              Icon(
                isLocked
                    ? Icons.lock_outline
                    : isAnalyzed
                        ? Icons.verified_user
                        : Icons.video_library,
                size: 16.sp,
                color: isLocked
                    ? theme.onError
                    : isAnalyzed
                        ? theme.onTertiaryContainer
                        : theme.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                isLocked
                    ? strings.analyzedVideoLocked
                    : isAnalyzed
                        ? strings.aiEnhancedAnalysis
                        : strings.originalFootage,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isLocked ? theme.onError
                    : isAnalyzed
                        ? theme.onTertiaryContainer
                        : theme.primary,
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _LockedVideoPlaceholder extends StatelessWidget {
  final S strings;
  const _LockedVideoPlaceholder({required this.strings});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lock_rounded, color: Colors.white54, size: 40.sp),
          SizedBox(height: 8.h),
          Text(
            strings.completePaymentToViewAnalyzedVideo,
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.white54, fontSize: 12.sp, height: 1.5),
          ),
        ]),
      ),
    );
  }
}

// ── Profile header ────────────────────────────────────────────────────────────

class _ReportProfileHeader extends StatelessWidget {
  final AnalysisReportModel report;
  final S strings;
  const _ReportProfileHeader({required this.report, required this.strings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 28.r,
          backgroundImage:
              report.player.profilePicture != null
                  ? NetworkImage(report.player.profilePicture!)
                  : null,
          child: report.player.profilePicture == null
              ? Icon(Icons.person, size: 28.sp)
              : null,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(report.player.fullName,
                  style: TextStyle(
                      fontSize: 18.sp, fontWeight: FontWeight.bold)),
              Row(children: [
                Text(report.type,
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.grey)),
                SizedBox(width: 8.w),
                if (!report.isPaid)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: Colors.orange.withOpacity(0.4)),
                    ),
                    child: Text(
                      strings.unpaid,
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.orange[800],
                          fontWeight: FontWeight.w600),
                    ),
                  ),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}

// ── Video player ──────────────────────────────────────────────────────────────

class _VideoPlayerView extends StatefulWidget {
  final String videoUrl;
  final bool isAnalyzed;
  final S strings;
  const _VideoPlayerView({
    required this.videoUrl,
    required this.isAnalyzed,
    required this.strings,
  });

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
        cacheConfiguration:
            const BetterPlayerCacheConfiguration(useCache: true),
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
      if (mounted) setState(() {
        _controller = controller;
        _isInitializing = false;
      });
    } catch (e) {
      if (mounted) setState(() {
        _isInitializing = false;
        _error = widget.strings.failedToLoadVideo;
      });
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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.error_outline, color: Colors.white, size: 40.sp),
            SizedBox(height: 8.h),
            Text(_error!, style: const TextStyle(color: Colors.white)),
          ]),
        ),
      );
    }
    if (_isInitializing || _controller == null) {
      return Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()));
    }
    return Stack(children: [
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
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(
              widget.isAnalyzed
                  ? Icons.auto_fix_high_rounded
                  : Icons.videocam_outlined,
              color: Colors.white70,
              size: 14.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              widget.isAnalyzed ? widget.strings.analyzedVideo : widget.strings.originalVideo,
              style:
                  TextStyle(color: Colors.white70, fontSize: 10.sp),
            ),
          ]),
        ),
      ),
    ]);
  }
}