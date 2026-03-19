import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/presentation/fawery_mobile_screen.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/web_view_screen.dart';
import 'package:sports_in/features/payment/presentation/vodafon_cash_screen.dart';
import 'package:sports_in/features/payment/presentation/widgets/payment_methods_dailog.dart';

/// Shows the existing [PaymentMethodDialog], then navigates to the correct
/// payment screen based on the chosen method.
///
/// • **Mobile Wallet** → [VodafoneCashScreen]
/// • **Fawry Pay**     → [FawryMobileScreen] → [FawryScreen]
/// • **Credit Card**   → fires [InitiatePaymentEvent]; the calling widget's
///                       [BlocListener] must catch [PaymentRedirectReady]
///                       and open [WebViewScreen] with the redirect URL.
///
/// Returns `true` if a method was selected, `false` if the user cancelled.
Future<bool> initiatePaymentFlow({
  required BuildContext context,
  required String targetId,
  required PaymentTargetType targetType,
  double price = 0,
}) async {
  // ── Step 1: pick method ─────────────────────────────────────────────────
  final method = await showPaymentMethodDialog(context);
  if (method == null) return false;

  if (!context.mounted) return false;

  // ── Step 2: build synthetic plan with the CORRECT constructor ───────────
  // FawryMobileScreen / VodafoneCashScreen expect a SubscriptionPlanModel.
  // We build a minimal one — they only read plan.id and plan.price.
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
    // ── Mobile Wallet → VodafoneCashScreen ──────────────────────────────
    case PaymentMethod.mobileWallet:
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<PaymentBloc>(),
            child: VodafoneCashScreen(
              plan: syntheticPlan,
              targetType: targetType,
            ),
          ),
        ),
      );
      break;

    // ── Fawry → FawryMobileScreen ──────────────────────────────────────
    case PaymentMethod.fawryPay:
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<PaymentBloc>(),
            child: FawryMobileScreen(
              plan: syntheticPlan,
              targetType: targetType,
            ),
          ),
        ),
      );
      break;

    // ── Credit Card → fire event; BlocListener handles redirect URL ──────
    case PaymentMethod.creditCard:
      if (!context.mounted) return false;
      context.read<PaymentBloc>().add(InitiatePaymentEvent(
            targetId: targetId,
            targetType: targetType,
            method: PaymentMethod.creditCard,
          ));
      break;
  }

  return true;
}