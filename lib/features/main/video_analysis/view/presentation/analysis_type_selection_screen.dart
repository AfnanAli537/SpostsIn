import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../data/enums/analysis_type.dart';
import 'create_analysis_form_screen.dart';

class AnalysisTypeSelectionScreen extends StatelessWidget {
  /// The userId of the player being analyzed. Pass the current user's id
  /// when analysing oneself.
  final String targetUserId;

  const AnalysisTypeSelectionScreen({super.key, required this.targetUserId});

  static const _typeData = [
    (
      type: AnalysisType.goalkeeper,
      icon: Icons.sports_handball_outlined,
      color: Color(0xFF4FC3F7),
      gradient: [Color(0xFF0288D1), Color(0xFF4FC3F7)],
    ),
    (
      type: AnalysisType.passing,
      icon: Icons.compare_arrows_rounded,
      color: Color(0xFF81C784),
      gradient: [Color(0xFF388E3C), Color(0xFF81C784)],
    ),
    (
      type: AnalysisType.dribbling,
      icon: Icons.sports_soccer,
      color: Color(0xFFFFB74D),
      gradient: [Color(0xFFF57C00), Color(0xFFFFB74D)],
    ),
    (
      type: AnalysisType.match,
      icon: Icons.stadium_outlined,
      color: Color(0xFFBA68C8),
      gradient: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          strings.videoAnalysis,
          style: TextStyle(
            color: theme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.chooseAnalysisType,
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: theme.onSurface,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              strings.analysisTypeSubtitle,
              style: TextStyle(
                fontSize: 13.sp,
                color: theme.onSurface.withOpacity(0.55),
              ),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.88,
                children: _typeData.map((d) {
                  return _TypeCard(
                    type: d.type,
                    icon: d.icon,
                    color: d.color,
                    gradient: d.gradient,
                    label: _getLocalizedLabel(d.type, strings),
                    description: _getLocalizedDescription(d.type, strings),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateAnalysisFormScreen(
                          targetUserId: targetUserId,
                          analysisType: d.type,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedLabel(AnalysisType type, S strings) {
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

  String _getLocalizedDescription(AnalysisType type, S strings) {
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
}

class _TypeCard extends StatelessWidget {
  final AnalysisType type;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _TypeCard({
    required this.type,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: theme.surface,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: Colors.white, size: 26.sp),
              ),
              const Spacer(),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.onSurface,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: theme.onSurface.withOpacity(0.5),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}