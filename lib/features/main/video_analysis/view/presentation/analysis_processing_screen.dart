import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/enums/analysis_type.dart';

class AnalysisProcessingScreen extends StatefulWidget {
  final AnalysisType type;

  const AnalysisProcessingScreen({super.key, required this.type});

  @override
  State<AnalysisProcessingScreen> createState() =>
      _AnalysisProcessingScreenState();
}

class _AnalysisProcessingScreenState extends State<AnalysisProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnim,
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme.primary,
                        theme.primary.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withOpacity(0.35),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                    size: 52.sp,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                'Analysis in Progress',
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'Your ${widget.type.label} video is being processed by our AI engine. This may take a few minutes.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.onSurface.withOpacity(0.6),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: theme.primary.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      color: theme.primary,
                      size: 22.sp,
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        'You\'ll receive a notification and see the report in your profile once the analysis is complete.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: theme.onSurface.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // Pop all the way back to main nav
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}