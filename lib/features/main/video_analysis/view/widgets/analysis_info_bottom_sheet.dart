import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../data/enums/analysis_type.dart';

class AnalysisInfoBottomSheet extends StatelessWidget {
  final AnalysisType type;

  const AnalysisInfoBottomSheet({super.key, required this.type});

  String _getLocalizedTypeLabel(S strings) {
    switch (type) {
      case AnalysisType.goalkeeper:
        return strings.goalkeeperAnalysisLabel;
      case AnalysisType.passing:
        return strings.passingAnalysisLabel;
      case AnalysisType.dribbling:
        return strings.dribblingAnalysisLabel;
      case AnalysisType.match:
        return strings.matchAnalysisLabel;
    }
  }

  String _getLocalizedDescription(S strings) {
    switch (type) {
      case AnalysisType.goalkeeper:
        return strings.goalkeeperAnalysisDescription;
      case AnalysisType.passing:
        return strings.passingAnalysisDescription;
      case AnalysisType.dribbling:
        return strings.dribblingAnalysisDescription;
      case AnalysisType.match:
        return strings.matchAnalysisDescription;
    }
  }

  String _getLocalizedVideoInstructions(S strings) {
    switch (type) {
      case AnalysisType.goalkeeper:
        return strings.goalkeeperVideoInstructions;
      case AnalysisType.passing:
        return strings.passingVideoInstructions;
      case AnalysisType.dribbling:
        return strings.dribblingVideoInstructions;
      case AnalysisType.match:
        return strings.matchVideoInstructions;
    }
  }

  List<String> _getLocalizedKpis(S strings) {
    switch (type) {
      case AnalysisType.goalkeeper:
        return [
          strings.kpiReactionTime,
          strings.kpiMaxExtension,
          strings.kpiMaxVelocity,
          strings.kpiDeepestKneeAngle,
        ];
      case AnalysisType.passing:
        return [
          strings.kpiDrillDuration,
          strings.kpiTotalBallTouches,
          strings.kpiAverageBallSpeed,
          strings.kpiAveragePlayerSpeed,
          strings.kpiRightKneeAngle,
        ];
      case AnalysisType.dribbling:
        return [
          strings.kpiTouchesPerSec,
          strings.kpiAvgPlayerSpeedDribbling,
          strings.kpiAvgBallDistance,
          strings.kpiHeadUpPercentage,
          strings.kpiHipBounceVariance,
          strings.kpiConePasses,
        ];
      case AnalysisType.match:
        return [
          strings.kpiTeamPossession,
          strings.kpiDistanceCovered,
          strings.kpiTopSpeedPerTeam,
          strings.kpiTopSprintSpeedOverall,
          strings.kpiTotalFramesProcessed,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: ListView(
          controller: controller,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          children: [
            // drag handle
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: theme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),

            Text(
              strings.analysisTypeTitle(_getLocalizedTypeLabel(strings)),
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: theme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _getLocalizedDescription(strings),
              style: TextStyle(
                fontSize: 13.sp,
                color: theme.onSurface.withOpacity(0.65),
                height: 1.6,
              ),
            ),

            SizedBox(height: 24.h),
            _SectionHeader(title: strings.whatWillBeAnalyzed),
            SizedBox(height: 10.h),
            _kpiList(_getLocalizedKpis(strings)),

            SizedBox(height: 24.h),
            _SectionHeader(title: strings.videoRecordingTips),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: theme.primary.withOpacity(0.15),
                ),
              ),
              child: Text(
                _getLocalizedVideoInstructions(strings),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: theme.onSurface.withOpacity(0.75),
                  height: 1.8,
                ),
              ),
            ),

            SizedBox(height: 24.h),
            _SectionHeader(title: strings.exampleFrame),
            SizedBox(height: 10.h),
            Container(
              height: 180.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: theme.onSurface.withOpacity(0.06),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      type.exampleImageAsset,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) =>
                          _ExamplePlaceholder(type, strings),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: theme.outline.withOpacity(0.3)),
                  ),
                ),
                child: Text(
                  strings.gotIt,
                  style: TextStyle(fontSize: 15.sp),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _kpiList(List<String> kpis) {
    return Column(
      children: kpis
          .map(
            (kpi) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 16.sp, color: const Color(0xFF66BB6A)),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      kpi,
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class _ExamplePlaceholder extends StatelessWidget {
  final AnalysisType type;
  final S strings;
  const _ExamplePlaceholder(this.type, this.strings);

  IconData get _icon {
    switch (type) {
      case AnalysisType.goalkeeper:
        return Icons.sports_handball_outlined;
      case AnalysisType.passing:
        return Icons.compare_arrows_rounded;
      case AnalysisType.dribbling:
        return Icons.sports_soccer;
      case AnalysisType.match:
        return Icons.stadium_outlined;
    }
  }

  String _getLocalizedTypeLabel() {
    switch (type) {
      case AnalysisType.goalkeeper:
        return strings.goalkeeperAnalysisLabel;
      case AnalysisType.passing:
        return strings.passingAnalysisLabel;
      case AnalysisType.dribbling:
        return strings.dribblingAnalysisLabel;
      case AnalysisType.match:
        return strings.matchAnalysisLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(_icon, size: 48.sp, color: theme.onSurface.withOpacity(0.3)),
        SizedBox(height: 10.h),
        Text(
          strings.exampleDrill(_getLocalizedTypeLabel()),
          style: TextStyle(
            fontSize: 12.sp,
            color: theme.onSurface.withOpacity(0.35),
          ),
        ),
      ],
    );
  }
}

void showAnalysisInfoSheet(BuildContext context, AnalysisType type) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AnalysisInfoBottomSheet(type: type),
  );
}