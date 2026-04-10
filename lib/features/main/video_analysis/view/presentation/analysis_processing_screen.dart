import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_bloc.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_state.dart';
import 'package:sports_in/generated/l10n.dart';
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
  bool _isDone = false;

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

  String _getLocalizedTypeLabel(S strings) {
    switch (widget.type) {
      case AnalysisType.goalkeeper:
        return strings.goalkeeperAnalysis;
      case AnalysisType.passing:
        return strings.passingAnalysis;
      case AnalysisType.dribbling:
        return strings.dribblingAnalysis;
      case AnalysisType.match:
        return strings.matchAnalysis;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    // Only attach listener if CreateAnalysisBloc is in the tree
    // (it's passed via BlocProvider.value from the form screen).
    final hasBloc =
        context
            .findAncestorWidgetOfExactType<
                BlocProvider<CreateAnalysisBloc>
            >() !=
        null;

    Widget body = _buildBody(context, theme, strings);

    if (hasBloc) {
      body = BlocListener<CreateAnalysisBloc, CreateAnalysisState>(
        listener: (ctx, state) {
          if (state is AnalysisCompleted) {
            if (!_isDone) {
              _isDone = true;
              _pulseController.stop();
              setState(() {});
              Fluttertoast.showToast(
                msg: strings.analysisReadyToast(
                  _getLocalizedTypeLabel(strings),
                ),
                backgroundColor: Colors.green[700],
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 4,
              );
            }
          } else if (state is CreateAnalysisRequiresPayment) {
            // Edge case: payment required but we already showed processing.
            // Navigate to payment screen.
            Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: ctx.read<CreateAnalysisBloc>(),
                  child: _PaymentRedirectPlaceholder(
                    analysisId: state.analysisId,
                    price: state.price,
                    type: widget.type,
                  ),
                ),
              ),
            );
          } else if (state is CreateAnalysisError) {
            Fluttertoast.showToast(
              msg: strings.analysisFailedToast(state.message),
              backgroundColor: Colors.red,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          }
        },
        child: body,
      );
    }

    return Scaffold(body: SafeArea(child: body));
  }

  Widget _buildBody(BuildContext context, ColorScheme theme, S strings) {
    final typeLabel = _getLocalizedTypeLabel(strings);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Animated icon ────────────────────────────────────────────────
          ScaleTransition(
            scale: _isDone ? AlwaysStoppedAnimation(1.0) : _pulseAnim,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _isDone
                      ? [Colors.green, const Color(0xFF00BFA5)]
                      : [theme.primary, theme.primary.withOpacity(0.5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_isDone ? Colors.green : theme.primary).withOpacity(
                      0.35,
                    ),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                _isDone
                    ? Icons.check_circle_outline_rounded
                    : Icons.analytics_outlined,
                color: Colors.white,
                size: 52.sp,
              ),
            ),
          ),
          SizedBox(height: 40.h),

          // ── Title ────────────────────────────────────────────────────────
          Text(
            _isDone ? strings.analysisCompleteTitle : strings.analysisInProgressTitle,
            style: GoogleFonts.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: theme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            _isDone
                ? strings.analysisCompleteMessage(typeLabel)
                : strings.analysisInProgressMessage(typeLabel),
            style: TextStyle(
              fontSize: 14.sp,
              color: theme.onSurface.withOpacity(0.6),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),

          // ── Info card ────────────────────────────────────────────────────
          if (!_isDone)
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: theme.primary.withOpacity(0.15)),
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
                      strings.analysisNotificationInfo,
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

          // ── Action button ────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.mainLayout, (route) => false),

              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                _isDone ? strings.goToProfileButton : strings.backToHomeButton,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tiny placeholder — imported lazily to avoid circular import with
// AnalysisPaymentScreen. In practice, replace with real import.
class _PaymentRedirectPlaceholder extends StatelessWidget {
  final String analysisId;
  final double price;
  final AnalysisType type;
  const _PaymentRedirectPlaceholder({
    required this.analysisId,
    required this.price,
    required this.type,
  });

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}