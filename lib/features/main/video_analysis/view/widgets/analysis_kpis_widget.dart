import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared KPI tile
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
// Goalkeeper
// ─────────────────────────────────────────────────────────────────────────────

class GoalkeeperKpisWidget extends StatelessWidget {
  final GoalkeeperKpis kpis;

  const GoalkeeperKpisWidget({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) => _kpiGrid([
        _KpiTile(
          label: 'Reaction Time',
          value: '${kpis.reactionTimeSec.toStringAsFixed(2)}s',
          icon: Icons.timer_outlined,
          color: const Color(0xFF6C63FF),
        ),
        _KpiTile(
          label: 'Max Extension',
          value: '${kpis.maxExtensionMeters.toStringAsFixed(2)}m',
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
          label: 'Deepest Knee Angle',
          value: '${kpis.deepestKneeAngleDeg.toStringAsFixed(0)}°',
          icon: Icons.rotate_90_degrees_ccw_rounded,
          color: const Color(0xFFE53935),
        ),
      ]);
}

// ─────────────────────────────────────────────────────────────────────────────
// Passing
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
        // Filler to keep even grid
        _KpiTile(label: '', value: '', icon: Icons.bar_chart_rounded,
            color: Colors.transparent),
      ]);
}

// ─────────────────────────────────────────────────────────────────────────────
// Dribbling
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
              value: '${kpis.avgBallDistanceMeters.toStringAsFixed(2)}m',
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
      child: Row(
        children: [
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
            '${kpis.hipBounceVarianceMeters.toStringAsFixed(3)}m',
            const Color(0xFF6C63FF),
          ),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
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
                  color: theme.colorScheme.onSurface.withOpacity(0.55))),
        ],
      ),
    );
  }

  Widget _div() => Container(
      width: 1, height: 36, color: Colors.grey.withOpacity(0.2));
}

// ─────────────────────────────────────────────────────────────────────────────
// Match
// ─────────────────────────────────────────────────────────────────────────────

class MatchKpisWidget extends StatelessWidget {
  final MatchKpis kpis;

  const MatchKpisWidget({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _PossessionBar(
              team1: kpis.team1Possession, team2: kpis.team2Possession),
          SizedBox(height: 14.h),
          _TeamComparisonGrid(kpis: kpis),
          SizedBox(height: 12.h),
          _TopSpeedBanner(kpis: kpis),
        ],
      );
}

class _PossessionBar extends StatelessWidget {
  final double team1;
  final double team2;

  const _PossessionBar({required this.team1, required this.team2});

  @override
  Widget build(BuildContext context) {
    final t1Ratio = team1 / (team1 + team2);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('T1: ${team1.toStringAsFixed(0)}%', style: _posStyle(const Color(0xFF1565C0))),
              Text('Possession', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              Text('T2: ${team2.toStringAsFixed(0)}%', style: _posStyle(const Color(0xFFE53935))),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: t1Ratio,
              minHeight: 8.h,
              backgroundColor: const Color(0xFFE53935),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _posStyle(Color color) => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: color);
}
class _TeamComparisonGrid extends StatelessWidget {
  final MatchKpis kpis;

  const _TeamComparisonGrid({required this.kpis});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _row(
            context,
            'Distance Covered',
            '${kpis.team1DistanceCoveredKm.toStringAsFixed(2)} km',
            '${kpis.team2DistanceCoveredKm.toStringAsFixed(2)} km',
            Icons.route_rounded,
          ),
          SizedBox(height: 8.h),
          _row(
            context,
            'Top Speed',
            '${kpis.team1TopSpeedKmh.toStringAsFixed(1)} km/h',
            '${kpis.team2TopSpeedKmh.toStringAsFixed(1)} km/h',
            Icons.speed_rounded,
          ),
        ],
      );

  Widget _row(BuildContext context, String label, String v1, String v2,
      IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.45),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(v1,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1565C0))),
          const Spacer(),
          Row(children: [
            Icon(icon,
                size: 14.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.4)),
            SizedBox(width: 4.w),
            Text(label,
                style: TextStyle(
                    fontSize: 11.sp,
                    color: theme.colorScheme.onSurface.withOpacity(0.55))),
          ]),
          const Spacer(),
          Text(v2,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE53935))),
        ],
      ),
    );
  }
}

class _TopSpeedBanner extends StatelessWidget {
  final MatchKpis kpis;

  const _TopSpeedBanner({required this.kpis});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFFF6F00)]),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(Icons.bolt_rounded, color: Colors.white, size: 28.sp),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Top Sprint Speed',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 11.sp)),
                Text('${kpis.topSprintSpeed.toStringAsFixed(1)} km/h',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Text('${kpis.totalFrames} frames',
                style:
                    TextStyle(color: Colors.white60, fontSize: 11.sp)),
          ],
        ),
      );
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