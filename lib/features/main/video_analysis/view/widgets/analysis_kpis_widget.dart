import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared KPI tile — used by Passing, Dribbling, and Goalkeeper grids
// ─────────────────────────────────────────────────────────────────────────────

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: color),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

Widget _kpiGrid(List<_KpiTile> tiles) => GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.25,
      padding: EdgeInsets.zero,
      children: tiles,
    );

// ─────────────────────────────────────────────────────────────────────────────
// Section header — shared across all KPI sections
// ─────────────────────────────────────────────────────────────────────────────

// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color color;

//   const _SectionHeader({
//     required this.title,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12.h),
//       child: Row(children: [
//         Container(
//           padding: EdgeInsets.all(6.w),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.12),
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           child: Icon(icon, size: 16.sp, color: color),
//         ),
//         SizedBox(width: 10.w),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w700,
//             color: Colors.black87,
//           ),
//         ),
//       ]),
//     );
//   }
// }

// ─────────────────────────────────────────────────────────────────────────────
// GOALKEEPER — grid layout matching passing/dribbling + highlight banner
// ─────────────────────────────────────────────────────────────────────────────

class GoalkeeperKpisWidget extends StatelessWidget {
  final GoalkeeperKpis kpis;

  const GoalkeeperKpisWidget({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Highlight banner: reaction time (most important GK metric) ────────
        _ReactionTimeBanner(reactionTimeSec: kpis.reactionTimeSec),
        SizedBox(height: 14.h),

        // ── 2×2 KPI grid ──────────────────────────────────────────────────────
        _kpiGrid([
          _KpiTile(
            label: 'Max Extension',
            value: '${kpis.maxExtensionMeters.toStringAsFixed(2)} m',
            icon: Icons.open_with_rounded,
            color: const Color(0xFF00BFA5),
          ),
          _KpiTile(
            label: 'Max Velocity',
            value: '${kpis.maxVelocityKmh.toStringAsFixed(1)} km/h',
            icon: Icons.speed_rounded,
            color: const Color(0xFFFF6F00),
          ),
          _KpiTile(
            label: 'Knee Angle',
            value: '${kpis.deepestKneeAngleDeg.toStringAsFixed(0)}°',
            icon: Icons.rotate_90_degrees_ccw_rounded,
            color: const Color(0xFF6C63FF),
          ),
          _KpiTile(
            label: 'Reaction Time',
            value: '${kpis.reactionTimeSec.toStringAsFixed(3)} s',
            icon: Icons.timer_rounded,
            color: const Color(0xFF1565C0),
          ),
        ]),
      ],
    );
  }
}

/// Full-width gradient banner highlighting reaction time
class _ReactionTimeBanner extends StatelessWidget {
  final double reactionTimeSec;

  const _ReactionTimeBanner({required this.reactionTimeSec});

  /// Qualitative rating based on reaction time
  String get _rating {
    if (reactionTimeSec < 0.15) return 'Elite';
    if (reactionTimeSec < 0.22) return 'Good';
    if (reactionTimeSec < 0.30) return 'Average';
    return 'Needs Work';
  }

  Color get _ratingColor {
    if (reactionTimeSec < 0.15) return const Color(0xFF00BFA5);
    if (reactionTimeSec < 0.22) return const Color(0xFF66BB6A);
    if (reactionTimeSec < 0.30) return const Color(0xFFFFB74D);
    return const Color(0xFFEF5350);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF4FC3F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.timer_rounded, color: Colors.white, size: 26.sp),
        ),
        SizedBox(width: 14.w),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Reaction Time',
            style:
                TextStyle(color: Colors.white70, fontSize: 11.sp),
          ),
          SizedBox(height: 2.h),
          Text(
            '${reactionTimeSec.toStringAsFixed(3)} s',
            style: TextStyle(
                color: Colors.white,
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5),
          ),
        ]),
        const Spacer(),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: _ratingColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            _rating,
            style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PASSING
// ─────────────────────────────────────────────────────────────────────────────

class PassingKpisWidget extends StatelessWidget {
  final PassingKpis kpis;

  const PassingKpisWidget({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) => _kpiGrid([
        _KpiTile(
          label: 'Drill Duration',
          value: '${kpis.drillDurationSeconds}s',
          icon: Icons.hourglass_bottom_rounded,
          color: const Color(0xFF00BFA5),
        ),
        _KpiTile(
          label: 'Ball Touches',
          value: '${kpis.totalBallTouches}',
          icon: Icons.touch_app_rounded,
          color: const Color(0xFF6C63FF),
        ),
        _KpiTile(
          label: 'Avg Ball Speed',
          value: '${kpis.avgBallSpeedKmh.toStringAsFixed(1)} km/h',
          icon: Icons.sports_soccer,
          color: const Color(0xFFFF6F00),
        ),
        _KpiTile(
          label: 'Avg Player Speed',
          value: '${kpis.avgPlayerSpeedKmh.toStringAsFixed(1)} km/h',
          icon: Icons.directions_run_rounded,
          color: const Color(0xFF1565C0),
        ),
        _KpiTile(
          label: 'Avg Knee Angle',
          value: '${kpis.avgRKneeAngleDeg.toStringAsFixed(1)}°',
          icon: Icons.rotate_90_degrees_ccw_rounded,
          color: const Color(0xFFE53935),
        ),
        _KpiTile(
          label: '',
          value: '',
          icon: Icons.bar_chart_rounded,
          color: Colors.transparent,
        ),
      ]);
}

// ─────────────────────────────────────────────────────────────────────────────
// DRIBBLING
// ─────────────────────────────────────────────────────────────────────────────

class DribblingKpisWidget extends StatelessWidget {
  final DribblingKpis kpis;

  const DribblingKpisWidget({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _kpiGrid([
            _KpiTile(
              label: 'Drill Duration',
              value: '${kpis.drillDurationSeconds}s',
              icon: Icons.hourglass_bottom_rounded,
              color: const Color(0xFF00BFA5),
            ),
            _KpiTile(
              label: 'Total Touches',
              value: '${kpis.totalTouches}',
              icon: Icons.touch_app_rounded,
              color: const Color(0xFF6C63FF),
            ),
            _KpiTile(
              label: 'Touches / sec',
              value: kpis.touchesPerSecond.toStringAsFixed(2),
              icon: Icons.repeat_rounded,
              color: const Color(0xFFFF6F00),
            ),
            _KpiTile(
              label: 'Avg Player Speed',
              value: '${kpis.avgPlayerSpeedKmh.toStringAsFixed(1)} km/h',
              icon: Icons.directions_run_rounded,
              color: const Color(0xFF1565C0),
            ),
            _KpiTile(
              label: 'Avg Ball Distance',
              value: '${kpis.avgBallDistanceMeters.toStringAsFixed(2)} m',
              icon: Icons.sports_soccer,
              color: const Color(0xFFE53935),
            ),
            _KpiTile(
              label: 'Head Up %',
              value: '${kpis.headUpPercentage.toStringAsFixed(0)}%',
              icon: Icons.visibility_rounded,
              color: const Color(0xFF558B2F),
            ),
          ]),
          SizedBox(height: 12.h),
          _ConeStatsRow(kpis: kpis),
        ],
      );
}

class _ConeStatsRow extends StatelessWidget {
  final DribblingKpis kpis;

  const _ConeStatsRow({required this.kpis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(children: [
        _item(context, 'Forward\nPasses', '${kpis.conePassesForward}',
            Colors.green),
        _div(),
        _item(context, 'Backward\nPasses', '${kpis.conePassesBackward}',
            Colors.orange),
        _div(),
        _item(context, 'Cone Hits', '${kpis.coneHits}', Colors.red),
        _div(),
        _item(
          context,
          'Hip Variance',
          '${kpis.hipBounceVarianceMeters.toStringAsFixed(3)} m',
          const Color(0xFF6C63FF),
        ),
      ]),
    );
  }

  Widget _item(BuildContext ctx, String label, String value, Color color) =>
      Expanded(
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: color)),
          SizedBox(height: 2.h),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.sp,
                  color: Theme.of(ctx)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.55))),
        ]),
      );

  Widget _div() =>
      Container(width: 1, height: 36, color: Colors.grey.withOpacity(0.2));
}

// ─────────────────────────────────────────────────────────────────────────────
// MATCH — Team 1 vs Team 2 arena layout
// ─────────────────────────────────────────────────────────────────────────────

class MatchKpisWidget extends StatelessWidget {
  final MatchKpis kpis;

  const MatchKpisWidget({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Column(children: [
      // ── VS Header ──────────────────────────────────────────────────────────
      _MatchVsHeader(),
      SizedBox(height: 14.h),

      // ── Possession bar ─────────────────────────────────────────────────────
      _PossessionBar(
        team1: kpis.team1Possession,
        team2: kpis.team2Possession,
      ),
      SizedBox(height: 14.h),

      // ── Stat rows ──────────────────────────────────────────────────────────
      _StatRow(
        icon: Icons.route_rounded,
        label: 'Distance Covered',
        v1: '${kpis.team1DistanceCoveredKm.toStringAsFixed(2)} km',
        v2: '${kpis.team2DistanceCoveredKm.toStringAsFixed(2)} km',
        v1Wins: kpis.team1DistanceCoveredKm >= kpis.team2DistanceCoveredKm,
      ),
      SizedBox(height: 8.h),
      _StatRow(
        icon: Icons.speed_rounded,
        label: 'Top Speed',
        v1: '${kpis.team1TopSpeedKmh.toStringAsFixed(1)} km/h',
        v2: '${kpis.team2TopSpeedKmh.toStringAsFixed(1)} km/h',
        v1Wins: kpis.team1TopSpeedKmh >= kpis.team2TopSpeedKmh,
      ),
      SizedBox(height: 14.h),

      // ── Top sprint speed banner ────────────────────────────────────────────
      _TopSprintBanner(kpis: kpis),
    ]);
  }
}

// ── VS header card ────────────────────────────────────────────────────────────

class _MatchVsHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        // gradient: LinearGradient(
        //   colors: [
        //     primary.withOpacity(0.08),
        //     secondary.withOpacity(0.08),
        //   ],
        // ),
        border: Border.all(
          color: theme.onError.withOpacity(0.2),
        ),
      ),
      child: Row(children: [
        // Team 1
        Expanded(
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.shield_rounded, color: theme.primary, size: 28.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Team 1',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.primary),
            ),
          ]),
        ),

        // VS badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'VS',
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: Colors.grey[600],
                letterSpacing: 2),
          ),
        ),

        // Team 2
        Expanded(
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: theme.onTertiaryContainer.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shield_rounded,
                  color: theme.onTertiaryContainer, size: 28.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Team 2',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.onTertiaryContainer),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Possession bar ────────────────────────────────────────────────────────────

class _PossessionBar extends StatelessWidget {
  final double team1;
  final double team2;


  const _PossessionBar({
    required this.team1,
    required this.team2,

  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final total = team1 + team2;
    final t1Ratio = total == 0 ? 0.5 : team1 / total;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            '${team1.toStringAsFixed(0)}%',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: theme.primary),
          ),
          Column(children: [
            Icon(Icons.sports_soccer,
                size: 16.sp, color: Colors.grey[400]),
            SizedBox(height: 2.h),
            Text('Possession',
                style:
                    TextStyle(fontSize: 11.sp, color: Colors.grey[500])),
          ]),
          Text(
            '${team2.toStringAsFixed(0)}%',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: theme.onTertiaryContainer),
          ),
        ]),
        SizedBox(height: 10.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Stack(children: [
            // Background (team 2)
            Container(height: 10.h, color: theme.onTertiaryContainer),
            // Foreground (team 1)
            FractionallySizedBox(
              widthFactor: t1Ratio,
              child: Container(
                height: 10.h,
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Stat comparison row ───────────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String v1;
  final String v2;
  final bool v1Wins;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.v1,
    required this.v2,
    required this.v1Wins,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(children: [
        // Team 1 value
        SizedBox(
          width: 90.w,
          child: Row(children: [
            if (v1Wins)
              Icon(Icons.arrow_drop_up_rounded,
                  color: theme.primary, size: 20.sp),
            Flexible(
              child: Text(
                v1,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight:
                      v1Wins ? FontWeight.w800 : FontWeight.w500,
                  color: v1Wins ? theme.primary : Colors.grey[500],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ),

        // Center label
        Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 14.sp,
                    color: Colors.grey[400]),
                SizedBox(width: 4.w),
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 11.sp, color: Colors.grey[500]),
                ),
              ]),
        ),

        // Team 2 value
        SizedBox(
          width: 90.w,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    v2,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight:
                          !v1Wins ? FontWeight.w800 : FontWeight.w500,
                      color: !v1Wins ? theme.onTertiaryContainer : Colors.grey[500],
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
                if (!v1Wins)
                  Icon(Icons.arrow_drop_up_rounded,
                      color: theme.onTertiaryContainer, size: 20.sp),
              ]),
        ),
      ]),
    );
  }
}

// ── Top sprint speed banner ───────────────────────────────────────────────────

class _TopSprintBanner extends StatelessWidget {
  final MatchKpis kpis;

  const _TopSprintBanner({
    required this.kpis,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [primary, secondary],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        color: theme.primary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.bolt_rounded,
              color: Colors.white, size: 26.sp),
        ),
        SizedBox(width: 14.w),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Top Sprint Speed',
              style: TextStyle(color: Colors.white70, fontSize: 11.sp)),
          SizedBox(height: 2.h),
          Text(
            '${kpis.topSprintSpeed.toStringAsFixed(1)} km/h',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5),
          ),
        ]),
        const Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('Frames',
              style: TextStyle(color: Colors.white60, fontSize: 10.sp)),
          Text('${kpis.totalFrames}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700)),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Factory — auto-picks correct widget by type string
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisKpisWidget extends StatelessWidget {
  final AnalysisKpis kpis;
  final String type;

  const AnalysisKpisWidget(
      {super.key, required this.kpis, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'Goalkeeper':
        return GoalkeeperKpisWidget(kpis: kpis as GoalkeeperKpis);
      case 'Passing':
        return PassingKpisWidget(kpis: kpis as PassingKpis);
      case 'Dribbling':
        return DribblingKpisWidget(kpis: kpis as DribblingKpis);
      case 'Match':
        return MatchKpisWidget(kpis: kpis as MatchKpis);
      default:
        return const SizedBox.shrink();
    }
  }
}