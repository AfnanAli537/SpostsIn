// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/web_view_screen.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/presentation/fawery_mobile_screen.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/vodafon_cash_screen.dart';
import 'package:sports_in/features/payment/presentation/widgets/payment_methods_dailog.dart';
import 'package:sports_in/features/payment/presentation/widgets/processing_dailog.dart';
import 'package:sports_in/features/payment/presentation/widgets/sucess_dailog.dart';
import 'package:sports_in/generated/l10n.dart';

class SubscriptionScreen extends StatefulWidget {
  /// When [showCloseButton] is `true`, an X button is shown in the top-right
  /// corner so the user can dismiss the screen (e.g. from an onboarding
  /// paywall). Defaults to `false` (X hidden — back arrow is enough when
  /// opened from Settings).
  final bool showCloseButton;

  const SubscriptionScreen({super.key, this.showCloseButton = true});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  SubscriptionPlanModel? _selectedPlan;
  late AnimationController _btnController;

  /// Tracks whether we're showing the processing overlay so we never
  /// open it twice and always close it correctly.
  bool _isProcessingDialogOpen = false;

  String? _transId;
  String? _currentPlanId;

  // Cache plans locally so they survive payment-state churn.
  List<SubscriptionPlanModel> _cachedPlans = [];
  bool _isLoadingPlans = true;
  bool _isLoadingSubscription = true;

  /// Guards the BlocListener against re-firing the same terminal state
  /// (e.g. after the WebView pops back and the bloc still holds the old state).
  String? _handledPaymentStateType;

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    context.read<PaymentBloc>().add(const FetchPlansEvent());
    final userId = getIt<SharedPref>().getUserId();
    if (userId != null) {
      context
          .read<PaymentBloc>()
          .add(FetchMySubscriptionEvent(userId: userId));
    } else {
      setState(() => _isLoadingSubscription = false);
    }
  }

  @override
  void dispose() {
    _btnController.dispose();
    super.dispose();
  }

  // ── Processing dialog helpers ─────────────────────────────────────────────

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

  // ── Subscribe tap ─────────────────────────────────────────────────────────

  Future<void> _onSubscribeTap(List<SubscriptionPlanModel> plans) async {
    if (_selectedPlan == null) return;

    // Always select the plan in the bloc before any payment action.
    context.read<PaymentBloc>().add(SelectPlanEvent(_selectedPlan!));

    // Reset the guard so the listener reacts to a fresh payment attempt.
    setState(() => _handledPaymentStateType = null);

    if (_selectedPlan!.isFree) {
      // Free plan: initiate directly with credit card as a dummy method.
      context.read<PaymentBloc>().add(
            InitiatePaymentEvent(
              targetId: _selectedPlan!.id,
              targetType: PaymentTargetType.supscription,
              method: PaymentMethod.creditCard,
            ),
          );
      return;
    }

    // Paid plan: ask the user which payment method they want.
    final method = await showPaymentMethodDialog(context);
    if (method == null || !mounted) return;

    switch (method) {
      case PaymentMethod.mobileWallet:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<PaymentBloc>(),
              child: VodafoneCashScreen(plan: _selectedPlan!),
            ),
          ),
        );

      case PaymentMethod.fawryPay:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<PaymentBloc>(),
              child: FawryMobileScreen(plan: _selectedPlan!),
            ),
          ),
        );

      case PaymentMethod.creditCard:
        // Dispatch the payment event — the BlocListener below will catch
        // PaymentRedirectReady and push the WebViewScreen.
        context.read<PaymentBloc>().add(
              InitiatePaymentEvent(
                targetId: _selectedPlan!.id,
                targetType: PaymentTargetType.supscription,
                method: PaymentMethod.creditCard,
              ),
            );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) async {
        // ── Plan fetching ──────────────────────────────────────────────────
        if (state is PlansLoaded) {
          setState(() {
            _cachedPlans = state.plans;
            _isLoadingPlans = false;
            if (_selectedPlan == null && state.plans.isNotEmpty) {
              _selectedPlan = state.plans.length >= 2
                  ? state.plans[1]
                  : state.plans[0];
            }
          });
        }
        if (state is PlansLoading) setState(() => _isLoadingPlans = true);
        if (state is PlansError) setState(() => _isLoadingPlans = false);

        // ── Current subscription ───────────────────────────────────────────
        if (state is MySubscriptionLoaded) {
          setState(() {
            _currentPlanId = state.subscription.isValid
                ? state.subscription.planId
                : null;
            _isLoadingSubscription = false;
          });
        }
        if (state is MySubscriptionLoading) {
          setState(() => _isLoadingSubscription = true);
        }
        if (state is NoActiveSubscription) {
          setState(() {
            _currentPlanId = null;
            _isLoadingSubscription = false;
          });
        }

        // ── Processing overlay ─────────────────────────────────────────────
        // Show for credit card initiation only (Fawry/Vodafone handle their
        // own overlays on their own screens).
        if (state is PaymentInitiating) {
          _showProcessingDialog();
        }

        // ── CREDIT CARD: redirect to WebView ──────────────────────────────
        if (state is PaymentRedirectReady) {
          final stateKey = state.runtimeType.toString() + state.redirectUrl;
          if (stateKey == _handledPaymentStateType) return;
          _handledPaymentStateType = stateKey;

          _dismissProcessingDialog();
          _transId = state.transactionId;

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WebViewScreen(
                url: state.redirectUrl,
                title: s.completePayment,
              ),
            ),
          );

          // After the user closes the WebView, refresh plans/subscription
          // in case the payment completed.
          if (mounted) {
            context.read<PaymentBloc>().add(const FetchPlansEvent());
            final userId = getIt<SharedPref>().getUserId();
            if (userId != null) {
              context
                  .read<PaymentBloc>()
                  .add(FetchMySubscriptionEvent(userId: userId));
            }
          }
        }

        // ── FREE PLAN success (ProcessSuccessful) ─────────────────────────
        // Show success dialog then navigate to main layout.
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
              transactionId: _transId ?? s.unKnown,
              onDismissed: () {
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.mainLayout,
                    (route) => false,
                  );
                }
              },
            ),
          );
        }

        // ── FAWRY / VODAFONE success (ManualActivateSuccess) ──────────────
        // Do NOT show a dialog here — Fawry shows it on its own screen and
        // Vodafone shows it on its own screen then navigates away.
        // We just dismiss the processing overlay (safety) and reset state.
        if (state is ManualActivateSuccess) {
          _dismissProcessingDialog();
          // Reset guard so the next payment attempt is fresh.
          setState(() => _handledPaymentStateType = null);
        }

        // ── Errors ─────────────────────────────────────────────────────────
        if (state is PaymentInitiateError ||
            state is ManualActivateError ||
            state is PlansError) {
          _dismissProcessingDialog();
          final message = state is PaymentInitiateError
              ? (state as PaymentInitiateError).message
              : state is ManualActivateError
                  ? (state as ManualActivateError).message
                  : (state as PlansError).message;
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(children: [
                const Icon(Icons.error_outline,
                    color: Colors.white, size: 18),
                SizedBox(width: 8.w),
                Expanded(child: Text(message)),
              ]),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              margin: EdgeInsets.all(12.w),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1B2A),
        body: Stack(
          children: [
            // ── Hero ────────────────────────────────────────────────────
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              width: double.infinity,
              child: const _HeroImage(),
            ),

            // ── Scrollable content ───────────────────────────────────────
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                      height:
                          MediaQuery.of(context).size.height * 0.30),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D1B2A),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28)),
                    ),
                    padding:
                        const EdgeInsets.fromLTRB(20, 28, 20, 32),
                    child: _buildBody(s),
                  ),
                ],
              ),
            ),

            // ── Back arrow (shown when opened from Settings) ─────────────
            if (!widget.showCloseButton)
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16.w,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_back,
                        color: Colors.white, size: 18.sp),
                  ),
                ),
              ),

            // ── X close button (shown from onboarding / paywall) ──────────
            if (widget.showCloseButton)
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                right: 16.w,
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.mainLayout,
                    (route) => false,
                  ),
                  child: Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close,
                        color: Colors.white, size: 18.sp),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody(S s) {
    final isLoading = _isLoadingPlans || _isLoadingSubscription;

    if (isLoading && _cachedPlans.isEmpty) {
      return SizedBox(
        height: 300.h,
        child: const Center(
            child: CircularProgressIndicator(color: Color(0xFF4CAF50))),
      );
    }

    final plans = _cachedPlans;

    return Column(
      children: [
        Text(
          s.subscription_title,
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          s.subscription_subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFFB8C8D8),
            height: 1.55,
          ),
        ),
        SizedBox(height: 28.h),
        plans.isEmpty
            ? SizedBox(
                height: 180.h,
                child: const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF4CAF50))),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: plans.asMap().entries.map((entry) {
                  final plan = entry.value;
                  final isMiddle =
                      entry.key == 1 && plans.length >= 3;
                  final isSelected = _selectedPlan?.id == plan.id;
                  return Expanded(
                    flex: isMiddle ? 12 : 10,
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedPlan = plan),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: entry.key == 0 ? 0 : 5.w,
                          right: entry.key == plans.length - 1
                              ? 0
                              : 5.w,
                        ),
                        child: _PlanCard(
                          plan: plan,
                          isSelected: isSelected,
                          index: entry.key,
                          total: plans.length,
                          currentPlanId: _currentPlanId,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
        SizedBox(height: 28.h),
        ScaleTransition(
          scale: _btnController,
          child: GestureDetector(
            onTap: () => _onSubscribeTap(plans),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _selectedPlan != null ? 1.0 : 0.5,
              child: Container(
                width: double.infinity,
                height: 58.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8BC34A), Color(0xFF4CAF50)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    s.subscription_btn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          s.subscription_renewal_note,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5.sp,
            color: const Color(0xFF607080),
            height: 1.6,
          ),
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PLAN CARD
// ─────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final bool isSelected;
  final int index;
  final int total;
  final String? currentPlanId;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.index,
    required this.total,
    this.currentPlanId,
  });

  Color get _accent {
    if (plan.isFree) return const Color(0xFF607D8B);
    if (index == 1) return const Color(0xFF1A6EE8);
    return const Color(0xFFFFC107);
  }

  Color get _cardBg {
    if (index == 1 && total >= 3) return const Color(0xFF1565C0);
    return const Color(0xFF1A2A3A);
  }

  String? _badge(BuildContext context) {
    if (index == 1 && total >= 3)
      return S.of(context).subscription_plan_popular;
    if (index == total - 1 && total >= 3)
      return S.of(context).subscription_plan_best_value;
    return null;
  }

  List<Map<String, dynamic>> _features(BuildContext context) {
    return [
      {
        'icon': Icons.videocam_rounded,
        'label': plan.monthlyVideoAnalysisLimit == -1
            ? S.of(context).subscription_plan_unlimited_videos
            : plan.monthlyVideoAnalysisLimit == 0
                ? S.of(context).subscription_plan_no_videos
                : S.of(context).subscription_plan_videos_month(
                    plan.monthlyVideoAnalysisLimit),
      },
      {
        'icon': Icons.campaign_rounded,
        'label': plan.monthlyAdLimit == 0
            ? S.of(context).subscription_plan_no_ads
            : S.of(context)
                .subscription_plan_ads_month(plan.monthlyAdLimit),
      },
      {
        'icon': plan.hasDetailedReports
            ? Icons.analytics_rounded
            : Icons.bar_chart_rounded,
        'label': plan.hasDetailedReports
            ? S.of(context).subscription_plan_detailed_reports
            : S.of(context).subscription_plan_basic_stats,
      },
      if (!plan.isFree)
        {
          'icon': Icons.calendar_today_rounded,
          'label': plan.durationDays <= 31
              ? S.of(context)
                  .subscription_plan_duration_month(plan.durationDays)
              : S.of(context).subscription_plan_duration_year(
                  (plan.durationDays / 30).round()),
        },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final badge = _badge(context);
    final features = _features(context);
    final isCurrentPlan = currentPlanId == plan.id;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (badge != null)
          Container(
            margin: EdgeInsets.only(bottom: 6.h),
            padding:
                EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          )
        else
          SizedBox(height: 26.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? _accent : Colors.transparent,
              width: 2.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: _accent.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          padding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  plan.name,
                  style: TextStyle(
                    color: _accent,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Center(
                child: Text(
                  plan.price == 0
                      ? '0'
                      : plan.price.toStringAsFixed(0),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Center(
                child: Text(
                  plan.isFree
                      ? S.of(context).subscription_plan_forever
                      : plan.durationDays <= 31
                          ? S.of(context).subscription_plan_per_month
                          : S.of(context).subscription_plan_per_year,
                  style: TextStyle(
                    color: const Color(0xFF8099B0),
                    fontSize: 10.sp,
                  ),
                ),
              ),
              if (plan.description != null &&
                  plan.description!.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Center(
                  child: Text(
                    plan.description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 9.5.sp,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 10.h),
              Divider(color: Colors.white.withOpacity(0.1), height: 1),
              SizedBox(height: 10.h),
              ...features.map(
                (f) => Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(f['icon'] as IconData,
                          size: 13.sp, color: _accent),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          f['label'] as String,
                          style: TextStyle(
                            color: const Color(0xFFCCDDEE),
                            fontSize: 10.5.sp,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                width: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isCurrentPlan
                        ? _accent
                        : isSelected
                            ? _accent
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    border: (isSelected || isCurrentPlan)
                        ? null
                        : Border.all(
                            color: _accent.withOpacity(0.5)),
                  ),
                  child: Center(
                    child: Text(
                      isCurrentPlan
                          ? S.of(context).subscription_plan_current
                          : S.of(context).subscription_plan_select,
                      style: TextStyle(
                        color: (isSelected || isCurrentPlan)
                            ? Colors.white
                            : _accent,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// HERO IMAGE
// ─────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B3A2D), Color(0xFF0D1B2A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 120.w,
            height: 120.w,
            color: Colors.white.withOpacity(0.06),
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80.h,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xFF0D1B2A)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}