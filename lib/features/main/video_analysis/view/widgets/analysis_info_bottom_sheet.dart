import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/enums/analysis_type.dart';

class AnalysisInfoBottomSheet extends StatelessWidget {
  final AnalysisType type;

  const AnalysisInfoBottomSheet({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

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
              '${type.label} Analysis',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: theme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              type.description,
              style: TextStyle(
                fontSize: 13.sp,
                color: theme.onSurface.withOpacity(0.65),
                height: 1.6,
              ),
            ),

            SizedBox(height: 24.h),
            _SectionHeader(title: 'What will be analyzed'),
            SizedBox(height: 10.h),
            _kpiList(type),

            SizedBox(height: 24.h),
            _SectionHeader(title: 'Video Recording Tips'),
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
                type.videoInstructions,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: theme.onSurface.withOpacity(0.75),
                  height: 1.8,
                ),
              ),
            ),

            SizedBox(height: 24.h),
            _SectionHeader(title: 'Example Frame'),
            SizedBox(height: 10.h),
            // Example illustration placeholder
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
                    // Try to load asset image; show placeholder if missing
                    Image.asset(
                      type.exampleImageAsset,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => _ExamplePlaceholder(type),
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
                  'Got it',
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

  Widget _kpiList(AnalysisType type) {
    final kpis = _kpisFor(type);
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

  List<String> _kpisFor(AnalysisType type) {
    switch (type) {
      case AnalysisType.goalkeeper:
        return [
          'Reaction Time (seconds)',
          'Maximum Extension (meters)',
          'Maximum Velocity (km/h)',
          'Deepest Knee Angle (degrees)',
        ];
      case AnalysisType.passing:
        return [
          'Drill Duration (seconds)',
          'Total Ball Touches',
          'Average Ball Speed (km/h)',
          'Average Player Speed (km/h)',
          'Right Knee Angle (degrees)',
        ];
      case AnalysisType.dribbling:
        return [
          'Total Ball Touches & Touches/sec',
          'Average Player Speed (km/h)',
          'Average Ball Distance (meters)',
          'Head-Up Percentage',
          'Hip Bounce Variance',
          'Cone Passes Forward/Backward & Hits',
        ];
      case AnalysisType.match:
        return [
          'Team Possession (%)',
          'Distance Covered per Team (km)',
          'Top Speed per Team (km/h)',
          'Top Sprint Speed overall (km/h)',
          'Total Frames Processed',
        ];
    }
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
  const _ExamplePlaceholder(this.type);

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(_icon, size: 48.sp, color: theme.onSurface.withOpacity(0.3)),
        SizedBox(height: 10.h),
        Text(
          'Example: ${type.label} drill',
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