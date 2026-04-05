// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
// import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/helper/payment_flow_helper.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/web_view_screen.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/widgets/processing_dailog.dart';
import 'package:sports_in/features/payment/presentation/widgets/sucess_dailog.dart';
import 'package:sports_in/generated/l10n.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final S string;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    required this.string,
  });

  // ── Enroll logic ──────────────────────────────────────────────────────────

  Future<void> _handleEnroll(BuildContext context) async {
    if (course.isFree) {
      context.read<CoursesBloc>().add(EnrollInCourse(courseId: course.id));
      return;
    }

    final coursesBloc = context.read<CoursesBloc>();
    final paymentBloc = getIt<PaymentBloc>();

    // Show the orchestrator as a transparent dialog
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, __) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: paymentBloc),
          BlocProvider.value(value: coursesBloc),
        ],
        child: _PaymentOrchestrator(
          courseId: course.id,
          price: course.price,
          courseTitle: course.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useHorizontalLayout = constraints.maxWidth > 400.w;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            constraints: BoxConstraints(
              maxHeight: useHorizontalLayout ? 200.h : double.infinity,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: useHorizontalLayout
                ? _buildHorizontalLayout(theme)
                : _buildVerticalLayout(theme),
          ),
        );
      },
    );
  }

  Widget _buildVerticalLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          child: _buildThumbnailImage(height: 120.h, width: double.infinity),
        ),
        Padding(
          padding: EdgeInsets.all(12.r),
          child: _buildCardContent(theme, isHorizontal: false),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(ThemeData theme) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
          child: _buildThumbnailImage(width: 120.w, height: double.infinity),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: _buildCardContent(theme, isHorizontal: true),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailImage({
    required double? width,
    required double? height,
  }) {
    if (course.thumbnailUrl == null || course.thumbnailUrl!.isEmpty) {
      return _buildPlaceholder(width: width, height: height);
    }
    return Image.network(
      course.thumbnailUrl!,
      width: width,
      height: height,
      fit: BoxFit.cover,
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey[300],
          width: width,
          height: height,
          child: Center(
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) =>
          _buildPlaceholder(width: width, height: height),
    );
  }

  Widget _buildPlaceholder({required double? width, required double? height}) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: 40.sp,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildCardContent(ThemeData theme, {required bool isHorizontal}) {
    final topContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          course.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        if (course.description?.isNotEmpty == true)
          SizedBox(
            height: 12.sp * 1.6 * 2,
            child: Text(
              course.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        SizedBox(height: 8.h),
        _buildAuthorInfo(theme),
        SizedBox(height: 8.h),
        if (course.isEnrolled) ...[
          LinearProgressIndicator(
            value: course.progress / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(ColorManager.warning),
          ),
          SizedBox(height: 4.h),
          Text(
            string.completePercentage(_formatProgress(course.progress)),
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 8.h),
        ],
        _buildStatsRow(theme),
      ],
    );

    final bottomRow = Builder(
      builder: (context) => _buildBottomRow(context, theme),
    );

    if (isHorizontal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [topContent, bottomRow],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          topContent,
          SizedBox(height: 8.h),
          bottomRow,
        ],
      );
    }
  }

  Widget _buildAuthorInfo(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14.r,
          backgroundImage: course.owner.profilePictureUrl != null
              ? NetworkImage(course.owner.profilePictureUrl!)
              : null,
          child: course.owner.profilePictureUrl == null
              ? Icon(Icons.person, size: 14.sp)
              : null,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            course.owner.fullName,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Wrap(
      spacing: 14.w,
      runSpacing: 4.h,
      children: [
        _buildStatItem(
          Icons.play_circle_outline,
          string.lessonsCount(course.lessonsCount),
          theme,
        ),
        _buildStatItem(Icons.access_time, course.formattedDuration, theme),
        _buildStatItem(
          Icons.person,
          string.enrolledCount(course.enrolledUsersCount),
          theme,
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: theme.colorScheme.primary),
        SizedBox(width: 2.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp),
        ),
      ],
    );
  }

  Widget _buildBottomRow(BuildContext context, ThemeData theme) {
    if (course.isEnrolled) return const SizedBox.shrink();

    if (course.isOwner) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              iconSize: 20.sp,
              onPressed: onEdit,
              padding: EdgeInsets.all(4.w),
              constraints: const BoxConstraints(),
              tooltip: string.edit,
            ),
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[700]),
              iconSize: 20.sp,
              onPressed: onDelete,
              padding: EdgeInsets.all(4.w),
              constraints: const BoxConstraints(),
              tooltip: string.delete,
            ),
        ],
      );
    }

    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        final isLoading =
            state is EnrollmentLoading && state.courseId == course.id;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                course.isFree ? string.free : '${course.price} ${string.egp}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: course.isFree ? Colors.green : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 30.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : () => _handleEnroll(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size(70.w, 28.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        string.enroll,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatProgress(num value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}

// ── Payment orchestrator ──────────────────────────────────────────────────────
// Shown as a transparent, invisible dialog. Kicks off the payment flow and
// closes itself only when payment flow completes or user cancels.

class _PaymentOrchestrator extends StatefulWidget {
  final String courseId;
  final double price;
  final String courseTitle;

  const _PaymentOrchestrator({
    required this.courseId,
    required this.price,
    required this.courseTitle,
  });

  @override
  State<_PaymentOrchestrator> createState() => _PaymentOrchestratorState();
}

class _PaymentOrchestratorState extends State<_PaymentOrchestrator> {
  bool _isProcessingDialogOpen = false;
  String? _handledPaymentStateType;
  String? _transId;
  bool _isManualActivationHandled = false; 

  void _showProcessingDialog() {
    if (_isProcessingDialogOpen) return;
    _isProcessingDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ProcessingPaymentDialog(),
    ).then((_) => _isProcessingDialogOpen = false);
  }

  void _dismissProcessingDialog() {
    if (_isProcessingDialogOpen && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      _isProcessingDialogOpen = false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    final paymentBloc = context.read<PaymentBloc>();

    // Reset guard for fresh payment attempt
    setState(() => _handledPaymentStateType = null);

    // initiatePaymentFlow returns false only if the user dismissed the
    // payment-method dialog without choosing anything.
    final initiated = await initiatePaymentFlow(
      context: context,
      paymentBloc: paymentBloc,
      targetId: widget.courseId,
      targetType: PaymentTargetType.course,
      price: widget.price,
    );

    if (!initiated && mounted) {
      // User cancelled — close this orchestrator so the course card is usable.
      Navigator.of(context).pop();
    }
    // If initiated:
    // - Fawry / Vodafone: showGeneralDialog awaits their full screen,
    //   they handle success dialogs + navigate to mainLayout themselves,
    //   initiatePaymentFlow returns true AFTER they are done.
    //   We close this orchestrator here too so nothing is left dangling.
    // - Credit card: the BlocListener below catches PaymentRedirectReady.
    if (initiated && mounted) {
      // Only close orchestrator for Fawry/Vodafone paths (credit card is
      // handled by the listener). We can safely pop here because if credit
      // card is in flight the listener below will still fire before this
      // context is gone.
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        // ── Processing overlay for credit card initiation ────────────────
        if (state is PaymentInitiating) {
          _showProcessingDialog();
        }

        // ── Credit card: redirect to WebView ─────────────────────────────
        if (state is PaymentRedirectReady) {
          final stateKey = state.runtimeType.toString() + state.redirectUrl;
          if (stateKey == _handledPaymentStateType) return;
          _handledPaymentStateType = stateKey;

          _dismissProcessingDialog();
          _transId = state.transactionId;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WebViewScreen(
                prevScreen: AppRoutes.mainLayout,
                url: state.redirectUrl,
                title: strings.completePayment,
              ),
            ),
          );
        }

        // ── Free course success (ProcessSuccessful) ──────────────────────
        if (state is ProcessSuccessful) {
          final stateKey = state.runtimeType.toString();
          if (stateKey == _handledPaymentStateType) return;
          _handledPaymentStateType = stateKey;

          _dismissProcessingDialog();
          if (!mounted) return;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => PaymentSuccessDialog(
              transactionId: _transId ?? strings.unKnown,
              onDismissed: () {
                if (mounted) {
                  context.read<CoursesBloc>().add(
                    EnrollInCourse(courseId: widget.courseId),
                  );
                  Navigator.of(context).pop(); // Close orchestrator after success
                }
              },
            ),
          );
        }

        // ── FAWRY / VODAFONE success (ManualActivateSuccess) ─────────────
        // Do NOT show a dialog here — Fawry shows it on its own screen and
        // Vodafone shows it on its own screen then navigates away.
        // We just dismiss the processing overlay (safety) and trigger enrollment.
        if (state is ManualActivateSuccess && !_isManualActivationHandled) {
                _isManualActivationHandled = true;

          _dismissProcessingDialog();
          // Reset guard so the next payment attempt is fresh.
          setState(() => _handledPaymentStateType = null);
          // Trigger enrollment after successful payment
          if (mounted) {
            context.read<CoursesBloc>().add(
              EnrollInCourse(courseId: widget.courseId),
            );
          }
        }

        // ── Errors ───────────────────────────────────────────────────────
        if (state is PaymentInitiateError) {
          _dismissProcessingDialog();
          if (mounted) Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
          );
        }
        if (state is ManualActivateError) {
          _dismissProcessingDialog();
          if (mounted) Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
          );
        }
      },
      // Completely invisible — no UI
      child: const SizedBox.shrink(),
    );
  }
}