import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/presentation/fawery_mobile_screen.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/vodafon_cash_screen.dart';
import 'package:sports_in/features/payment/presentation/widgets/payment_methods_dailog.dart';

/// Shows the [PaymentMethodDialog], then navigates to the correct screen.
///
/// The caller must read [PaymentBloc] synchronously before calling this
/// and pass it in — never call context.read inside an async gap.
///
/// Credit card: fires [InitiatePaymentEvent] then returns immediately.
/// The parent [BlocListener] must handle [PaymentRedirectReady] and open
/// [WebViewScreen] with state.redirectUrl.
///
/// Mobile Wallet / Fawry: navigates to the respective screen and awaits.
/// The parent [BlocListener] handles [ManualActivateSuccess].
Future<bool> initiatePaymentFlow({
  required BuildContext context,
  required PaymentBloc paymentBloc,
  required String targetId,
  required PaymentTargetType targetType,
  double price = 0,
}) async {
  // ── Step 1: method selection ────────────────────────────────────────────
  final method = await showPaymentMethodDialog(context);
  if (method == null) return false;
  if (!context.mounted) return false;

  // ── Step 2: synthetic plan (FawryMobileScreen / VodafoneCashScreen need it)
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
    // ── Mobile Wallet ────────────────────────────────────────────────────
    case PaymentMethod.mobileWallet:
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: paymentBloc,
            child: VodafoneCashScreen(
              plan: syntheticPlan,
              targetType: targetType,
            ),
          ),
        ),
      );
      break;

    // ── Fawry ────────────────────────────────────────────────────────────
    case PaymentMethod.fawryPay:
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: paymentBloc,
            child: FawryMobileScreen(
              plan: syntheticPlan,
              targetType: targetType,
            ),
          ),
        ),
      );
      break;

    // ── Credit Card ──────────────────────────────────────────────────────
    // Fire the event directly. The parent BlocListener catches
    // PaymentRedirectReady and opens WebViewScreen.
    // No dialog here — the redirect happens almost immediately.
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