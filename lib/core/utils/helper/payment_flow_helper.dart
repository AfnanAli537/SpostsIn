import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/video_analysis/data/enums/analysis_type.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/widgets/payment_methods_dailog.dart';
import 'package:sports_in/features/payment/presentation/fawery_mobile_screen.dart';
import 'package:sports_in/features/payment/presentation/vodafon_cash_screen.dart';

/// Shows [PaymentMethodDialog] then handles routing to the right payment UI.
///
/// Key design decision: Fawry and VodafoneCash are shown as FULL-SCREEN
/// DIALOGS (using [showGeneralDialog] with [barrierDismissible: false]) rather
/// than pushed routes. This avoids navigation conflicts and allows each
/// payment screen to control its own navigation after success.
///
/// Credit card fires [InitiatePaymentEvent] directly; the parent
/// [BlocListener] handles [PaymentRedirectReady] → push [WebViewScreen].
///
/// For video analysis: analysisType is passed through the chain so that
/// FawryScreen/VodafoneCashScreen can navigate to AnalysisProcessingScreen
/// after payment succeeds.
///
/// [paymentBloc] must be read by the caller BEFORE calling this:
///   final paymentBloc = context.read<PaymentBloc>();
///   await initiatePaymentFlow(paymentBloc: paymentBloc, ...);
Future<bool> initiatePaymentFlow({
  required BuildContext context,
  required PaymentBloc paymentBloc,
  required String targetId,
  required PaymentTargetType targetType,
  double price = 0,
  AnalysisType? analysisType, // Optional: for video analysis payments
}) async {
  // ── Step 1: choose method ────────────────────────────────────────────────
  final method = await showPaymentMethodDialog(context);
  if (method == null) return false;
  if (!context.mounted) return false;

  final syntheticPlan = SubscriptionPlanModel(
    id: targetId,
    name: '',
    price: price,
    monthlyAdLimit: 0,
    monthlyVideoAnalysisLimit: 0,
    hasDetailedReports: false,
    durationDays: 0,
  );

  switch (method) {
    // ── Mobile Wallet ──────────────────────────────────────────────────────
    case PaymentMethod.mobileWallet:
      await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 250),
        transitionBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        pageBuilder: (_, __, ___) => BlocProvider.value(
          value: paymentBloc,
          child: VodafoneCashScreen(
            plan: syntheticPlan,
            targetType: targetType,
            analysisType: analysisType,
          ),
        ),
      );
      break;

    // ── Fawry ──────────────────────────────────────────────────────────────
    case PaymentMethod.fawryPay:
      await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 250),
        transitionBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        pageBuilder: (_, __, ___) => BlocProvider.value(
          value: paymentBloc,
          child: FawryMobileScreen(
            plan: syntheticPlan,
            targetType: targetType,
            analysisType: analysisType,
          ),
        ),
      );
      break;

    // ── Credit Card ────────────────────────────────────────────────────────
    // Fire event directly — parent BlocListener catches PaymentRedirectReady
    // and pushes WebViewScreen. No dialog/route opened here.
    case PaymentMethod.creditCard:
      paymentBloc.add(InitiatePaymentEvent(
        targetId: targetId,
        targetType: targetType,
        method: PaymentMethod.creditCard,
      ));
      break;
  }

  return true;
}