// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sports_in/features/payment/data/enums/enums.dart';
// import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
// import 'package:sports_in/features/payment/presentation/fawery_mobile_screen.dart';
// import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
// import 'package:sports_in/features/payment/presentation/vodafon_cash_screen.dart';
// import 'package:sports_in/features/payment/presentation/widgets/sucess_dailog.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SubscriptionScreen extends StatefulWidget {
//   const SubscriptionScreen({super.key});

//   @override
//   State<SubscriptionScreen> createState() => _SubscriptionScreenState();
// }

// class _SubscriptionScreenState extends State<SubscriptionScreen>
//     with SingleTickerProviderStateMixin {
//   SubscriptionPlanModel? _selectedPlan;
//   late AnimationController _btnController;

//   @override
//   void initState() {
//     super.initState();
//     _btnController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//       lowerBound: 0.95,
//       upperBound: 1.0,
//       value: 1.0,
//     );
//     context.read<PaymentBloc>().add(const FetchPlansEvent());
//   }

//   @override
//   void dispose() {
//     _btnController.dispose();
//     super.dispose();
//   }

//   // ── Subscribe button tap ──────────────────
//   Future<void> _onSubscribeTap(List<SubscriptionPlanModel> plans) async {
//     if (_selectedPlan == null) return;

//     // Dispatch plan selection to BLoC
//     context.read<PaymentBloc>().add(SelectPlanEvent(_selectedPlan!));

//     // Free plan — no payment method needed
//     if (_selectedPlan!.isFree) {
//       context.read<PaymentBloc>().add(
//             InitiatePaymentEvent(
//               targetId: _selectedPlan!.id,
//               targetType: PaymentTargetType.supscription,
//               method: PaymentMethod.creditCard,
//             ),
//           );

//       return;
//     }

//     // Show payment method bottom sheet
//     final method = await _showPaymentMethodSheet();
//     if (method == null || !mounted) return;

//     switch (method) {
//       case PaymentMethod.mobileWallet:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => BlocProvider.value(
//               value: context.read<PaymentBloc>(),
//               child: VodafoneCashScreen(plan: _selectedPlan!),
//             ),
//           ),
//         );

//       case PaymentMethod.fawryPay:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => BlocProvider.value(
//               value: context.read<PaymentBloc>(),
//               child: FawryMobileScreen(plan: _selectedPlan!),
//             ),
//           ),
//         );

//       case PaymentMethod.creditCard:
//         // Dispatch — BLoC will emit PaymentRedirectReady with the URL
//         context.read<PaymentBloc>().add(
//               InitiatePaymentEvent(
//                 targetId: _selectedPlan!.id,
//                 targetType: PaymentTargetType.supscription,
//                 method: PaymentMethod.creditCard,
//               ),
//             );
//     }
//   }

//   Future<PaymentMethod?> _showPaymentMethodSheet() {
//     return showModalBottomSheet<PaymentMethod>(
//       context: context,
//       backgroundColor: const Color(0xFF0D1B2A),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Choose Payment Method',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 17,
//                   fontWeight: FontWeight.w700),
//             ),
//             const SizedBox(height: 16),
//             ...PaymentMethod.values.map(
//               (m) => ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: _methodIcon(m),
//                 title: Text(m.displayName,
//                     style:
//                         const TextStyle(color: Colors.white, fontSize: 14)),
//                 onTap: () => Navigator.pop(context, m),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _methodIcon(PaymentMethod m) {
//     switch (m) {
//       case PaymentMethod.creditCard:
//         return const Icon(Icons.credit_card, color: Color(0xFF1A6EE8));
//       case PaymentMethod.mobileWallet:
//         return const Icon(Icons.account_balance_wallet,
//             color: Color(0xFFE53935));
//       case PaymentMethod.fawryPay:
//         return const Icon(Icons.star_rounded, color: Color(0xFFFFB300));
//     }
//   }

//   // ─────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<PaymentBloc, PaymentState>(
//       listener: (context, state) {
//         // Credit card: open redirect URL in browser
//         if (state is PaymentRedirectReady) {
//           launchUrl(
//             Uri.parse(state.redirectUrl),
//             mode: LaunchMode.externalApplication,
//           );
//         }

//         // Success (manual activation done)
//         if (state is ManualActivateSuccess) {
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (_) => _SuccessDialog(
//               message: state.message ?? 'Subscription activated!',
//               onDone: () {
//                 Navigator.pop(context); // close dialog
//                 Navigator.pop(context); // close subscription screen
//               },
//             ),
//           );
//         }

//         if (state is PaymentInitiateError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message),
//               backgroundColor: Colors.red.shade700,
//             ),
//           );
//         }
//       },

//       child: Scaffold(
//         backgroundColor: const Color(0xFF0D1B2A),
//         body: BlocBuilder<PaymentBloc, PaymentState>(
//           builder: (context, state) {
//             return Stack(
//               children: [
//                 // ── Hero image ──
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.38,
//                   width: double.infinity,
//                   child: const _HeroImage(),
//                 ),

//                 // ── Main scrollable content ──
//                 SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                           height:
//                               MediaQuery.of(context).size.height * 0.30),
//                       Container(
//                         decoration: const BoxDecoration(
//                           color: Color(0xFF0D1B2A),
//                           borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(28)),
//                         ),
//                         padding:
//                             const EdgeInsets.fromLTRB(20, 28, 20, 32),
//                         child: _buildBody(state),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // ── Close button ──
//                 Positioned(
//                   top: MediaQuery.of(context).padding.top + 12,
//                   right: 16,
//                   child: GestureDetector(
//                     onTap: () => Navigator.of(context).pop(),
//                     child: Container(
//                       width: 34,
//                       height: 34,
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.45),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.close,
//                           color: Colors.white, size: 18),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(PaymentState state) {
//     // ── Loading ──
//     if (state is PlansLoading) {
//       return const SizedBox(
//         height: 300,
//         child: Center(
//           child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
//         ),
//       );
//     }
//    if (state is ProcessSuccessful) {
//      PaymentSuccessDialog(transactionId: 'transaction @?',);
//     }
//     // ── Error ──
//     if (state is PlansError) {
//       return SizedBox(
//         height: 300,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline, color: Colors.red, size: 48),
//               const SizedBox(height: 12),
//               Text(state.message,
//                   style: const TextStyle(color: Colors.white70),
//                   textAlign: TextAlign.center),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () =>
//                     context.read<PaymentBloc>().add(const FetchPlansEvent()),
//                 child: const Text('Retry',
//                     style: TextStyle(color: Color(0xFF4CAF50))),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // ── Plans ──
//     final plans = state is PlansLoaded
//         ? state.plans
//         : <SubscriptionPlanModel>[];

//     // Auto-select middle plan on first load
//     if (plans.isNotEmpty && _selectedPlan == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           setState(() {
//             _selectedPlan = plans.length >= 2 ? plans[1] : plans[0];
//           });
//         }
//       });
//     }

//     return Column(
//       children: [
//         const Text(
//           'Premium Access',
//           style: TextStyle(
//             fontSize: 26,
//             fontWeight: FontWeight.w800,
//             color: Colors.white,
//             letterSpacing: -0.5,
//           ),
//         ),
//         const SizedBox(height: 10),
//         const Text(
//           'Upgrade and analyse your game without limits',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               fontSize: 14, color: Color(0xFFB8C8D8), height: 1.55),
//         ),
//         const SizedBox(height: 28),

//         // ── Plan cards ──
//         plans.isEmpty
//             ? const SizedBox(
//                 height: 180,
//                 child: Center(
//                     child: CircularProgressIndicator(
//                         color: Color(0xFF4CAF50))),
//               )
//             : Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: plans.asMap().entries.map((entry) {
//                   final plan = entry.value;
//                   final isMiddle =
//                       entry.key == 1 && plans.length >= 3;
//                   final isSelected = _selectedPlan?.id == plan.id;
//                   return Expanded(
//                     flex: isMiddle ? 12 : 10,
//                     child: GestureDetector(
//                       onTap: () =>
//                           setState(() => _selectedPlan = plan),
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                           left: entry.key == 0 ? 0 : 5,
//                           right: entry.key == plans.length - 1
//                               ? 0
//                               : 5,
//                         ),
//                         child: _PlanCard(
//                           plan: plan,
//                           isSelected: isSelected,
//                           index: entry.key,
//                           total: plans.length,
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),

//         const SizedBox(height: 28),

//         // ── Subscribe button ──
//         ScaleTransition(
//           scale: _btnController,
//           child: GestureDetector(
//             onTap: () => _onSubscribeTap(plans),
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 200),
//               opacity: _selectedPlan != null ? 1.0 : 0.5,
//               child: Container(
//                 width: double.infinity,
//                 height: 58,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF8BC34A), Color(0xFF4CAF50)],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: BorderRadius.circular(32),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF4CAF50).withOpacity(0.4),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'SUBSCRIBE NOW',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),

//         const SizedBox(height: 16),
//         const Text(
//           'This is an automatically renewed subscription.\nYou can cancel anytime in settings.',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               fontSize: 11.5, color: Color(0xFF607080), height: 1.6),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  PLAN CARD
// // ─────────────────────────────────────────────
// class _PlanCard extends StatelessWidget {
//   final SubscriptionPlanModel plan;
//   final bool isSelected;
//   final int index;
//   final int total;

//   const _PlanCard({
//     required this.plan,
//     required this.isSelected,
//     required this.index,
//     required this.total,
//   });

//   Color get _accent {
//     if (plan.isFree) return const Color(0xFF607D8B);
//     if (index == 1) return const Color(0xFF1A6EE8);
//     return const Color(0xFFFFC107);
//   }

//   Color get _cardBg {
//     if (index == 1 && total >= 3) return const Color(0xFF1565C0);
//     return const Color(0xFF1A2A3A);
//   }

//   String? get _badge {
//     if (index == 1 && total >= 3) return 'POPULAR';
//     if (index == total - 1 && total >= 3) return 'BEST VALUE';
//     return null;
//   }

//   List<String> get _features {
//     return [
//       if (plan.monthlyVideoAnalysisLimit > 0)
//         plan.monthlyVideoAnalysisLimit == -1
//             ? 'Unlimited Videos'
//             : '${plan.monthlyVideoAnalysisLimit} Videos / month',
//       if (plan.monthlyAdLimit > 0) '${plan.monthlyAdLimit} Ads / month',
//       if (plan.hasDetailedReports) 'Detailed Reports',
//       if (plan.isFree) 'Basic Stats',
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (_badge != null)
//           Container(
//             margin: const EdgeInsets.only(bottom: 6),
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: _accent,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               _badge!,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 9,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 0.8),
//             ),
//           )
//         else
//           const SizedBox(height: 26),

//         AnimatedContainer(
//           duration: const Duration(milliseconds: 220),
//           curve: Curves.easeOut,
//           decoration: BoxDecoration(
//             color: _cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: isSelected ? _accent : Colors.transparent,
//               width: 2.5,
//             ),
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: _accent.withOpacity(0.35),
//                       blurRadius: 18,
//                       offset: const Offset(0, 6),
//                     )
//                   ]
//                 : [],
//           ),
//           padding:
//               const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Text(plan.name,
//                     style: TextStyle(
//                         color: _accent,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700)),
//               ),
//               const SizedBox(height: 8),
//               Center(
//                 child: Text(
//                   plan.price == 0
//                       ? '0'
//                       : plan.price.toStringAsFixed(0),
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.w900),
//                 ),
//               ),
//               Center(
//                 child: Text(
//                   plan.isFree
//                       ? 'forever'
//                       : plan.durationDays <= 31
//                           ? '/ month'
//                           : '/ year',
//                   style: const TextStyle(
//                       color: Color(0xFF8099B0), fontSize: 10),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Divider(
//                   color: Colors.white.withOpacity(0.1), height: 1),
//               const SizedBox(height: 10),
//               ..._features.map(
//                 (f) => Padding(
//                   padding: const EdgeInsets.only(bottom: 6),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.check_rounded,
//                           size: 13, color: _accent),
//                       const SizedBox(width: 5),
//                       Expanded(
//                         child: Text(f,
//                             style: const TextStyle(
//                                 color: Color(0xFFCCDDEE),
//                                 fontSize: 10.5,
//                                 height: 1.3)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 14),
//               SizedBox(
//                 width: double.infinity,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 220),
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   decoration: BoxDecoration(
//                     color: isSelected ? _accent : Colors.transparent,
//                     borderRadius: BorderRadius.circular(8),
//                     border: isSelected
//                         ? null
//                         : Border.all(
//                             color: _accent.withOpacity(0.5)),
//                   ),
//                   child: Center(
//                     child: Text(
//                       plan.isFree ? 'Current Plan' : 'Select Now',
//                       style: TextStyle(
//                           color:
//                               isSelected ? Colors.white : _accent,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  HERO IMAGE
// // ─────────────────────────────────────────────
// class _HeroImage extends StatelessWidget {
//   const _HeroImage();

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF1B3A2D), Color(0xFF0D1B2A)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//         Center(
//           child: Icon(Icons.sports_soccer,
//               size: 120, color: Colors.white.withOpacity(0.06)),
//         ),
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           height: 80,
//           child: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.transparent, Color(0xFF0D1B2A)],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  SUCCESS DIALOG
// // ─────────────────────────────────────────────
// class _SuccessDialog extends StatelessWidget {
//   final String message;
//   final VoidCallback onDone;

//   const _SuccessDialog({required this.message, required this.onDone});

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(const Duration(seconds: 3), onDone);

//     return Dialog(
//       shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.white,
//       child: Padding(
//         padding:
//             const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.check_circle,
//                 color: Color(0xFF4CAF50), size: 72),
//             const SizedBox(height: 16),
//             const Text(
//               'Payment Successful!',
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF1A1A1A)),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF757575),
//                   height: 1.6),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/presentation/fawery_mobile_screen.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/vodafon_cash_screen.dart';
import 'package:sports_in/features/payment/presentation/widgets/manual.dart';

import 'package:sports_in/features/payment/presentation/widgets/payment_methods_dailog.dart';
import 'package:sports_in/features/payment/presentation/widgets/processing_dailog.dart';
import 'package:sports_in/features/payment/presentation/widgets/sucess_dailog.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  SubscriptionPlanModel? _selectedPlan;
  late AnimationController _btnController;
  bool _isProcessingDialogOpen = false;

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
  }

  @override
  void dispose() {
    _btnController.dispose();
    super.dispose();
  }

  // ── Dialog helpers ────────────────────────────────────────────────────────

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

  void _showPaymentSuccessDialog(String transactionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentSuccessDialog(
        transactionId: transactionId,
        onDismissed: () {
          if (mounted) {
            context.read<PaymentBloc>().add(const FetchPlansEvent());
          }
        },
      ),
    );
  }

  void _showManualActivationSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ManualActivationSuccessDialog(
        message: message,
        onDone: () {
          Navigator.pop(context); // close dialog
          context.read<PaymentBloc>().add(const FetchPlansEvent());
        },
      ),
    );
  }

  // ── Subscribe button tap ──────────────────────────────────────────────────

  Future<void> _onSubscribeTap(List<SubscriptionPlanModel> plans) async {
    if (_selectedPlan == null) return;

    context.read<PaymentBloc>().add(SelectPlanEvent(_selectedPlan!));

    // Free plan — no payment method picker needed
    if (_selectedPlan!.isFree) {
      context.read<PaymentBloc>().add(
            InitiatePaymentEvent(
              targetId: _selectedPlan!.id,
              targetType: PaymentTargetType.supscription,
              method: PaymentMethod.creditCard,
            ),
          );
      return;
    }

    // Show payment method bottom sheet
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
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        // 1. Payment initiating → show processing dialog
        if (state is PaymentInitiating) {
          _showProcessingDialog();
        }

        // 2. Credit card redirect → close processing, open browser
        if (state is PaymentRedirectReady) {
          _dismissProcessingDialog();
          launchUrl(
            Uri.parse(state.redirectUrl),
            mode: LaunchMode.externalApplication,
          );
        }

        // 3. Online payment success (credit card callback)
        if (state is ProcessSuccessful) {
          _dismissProcessingDialog();
          _showPaymentSuccessDialog('N/A');
        }

        // 4. Manual activation success (Vodafone Cash / Fawry)
        if (state is ManualActivateSuccess) {
          _dismissProcessingDialog();
          _showManualActivationSuccessDialog(
            state.message ?? 'Subscription activated!',
          );
        }

        // 5. Error
        if (state is PaymentInitiateError) {
          _dismissProcessingDialog();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1B2A),
        body: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            return Stack(
              children: [
                // ── Hero image ──────────────────────────────────────────────
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.38,
                  width: double.infinity,
                  child: const _HeroImage(),
                ),

                // ── Main scrollable content ─────────────────────────────────
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
                        child: _buildBody(state),
                      ),
                    ],
                  ),
                ),

                // ── Close button ────────────────────────────────────────────
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(PaymentState state) {
    if (state is PlansLoading) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
        ),
      );
    }

    if (state is PlansError) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(state.message,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    context.read<PaymentBloc>().add(const FetchPlansEvent()),
                child: const Text('Retry',
                    style: TextStyle(color: Color(0xFF4CAF50))),
              ),
            ],
          ),
        ),
      );
    }

    final plans = state is PlansLoaded
        ? state.plans
        : <SubscriptionPlanModel>[];

    if (plans.isNotEmpty && _selectedPlan == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedPlan = plans.length >= 2 ? plans[1] : plans[0];
          });
        }
      });
    }

    return Column(
      children: [
        const Text(
          'Premium Access',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Upgrade and analyse your game without limits',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14, color: Color(0xFFB8C8D8), height: 1.55),
        ),
        const SizedBox(height: 28),

        // ── Plan cards ──────────────────────────────────────────────────────
        plans.isEmpty
            ? const SizedBox(
                height: 180,
                child: Center(
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
                          left: entry.key == 0 ? 0 : 5,
                          right: entry.key == plans.length - 1
                              ? 0
                              : 5,
                        ),
                        child: _PlanCard(
                          plan: plan,
                          isSelected: isSelected,
                          index: entry.key,
                          total: plans.length,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

        const SizedBox(height: 28),

        // ── Subscribe button ────────────────────────────────────────────────
        ScaleTransition(
          scale: _btnController,
          child: GestureDetector(
            onTap: () => _onSubscribeTap(plans),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _selectedPlan != null ? 1.0 : 0.5,
              child: Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8BC34A), Color(0xFF4CAF50)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SUBSCRIBE NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
        const Text(
          'This is an automatically renewed subscription.\nYou can cancel anytime in settings.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 11.5, color: Color(0xFF607080), height: 1.6),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  PLAN CARD
// ─────────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final bool isSelected;
  final int index;
  final int total;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.index,
    required this.total,
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

  String? get _badge {
    if (index == 1 && total >= 3) return 'POPULAR';
    if (index == total - 1 && total >= 3) return 'BEST VALUE';
    return null;
  }

  List<String> get _features {
    return [
      if (plan.monthlyVideoAnalysisLimit > 0)
        plan.monthlyVideoAnalysisLimit == -1
            ? 'Unlimited Videos'
            : '${plan.monthlyVideoAnalysisLimit} Videos / month',
      if (plan.monthlyAdLimit > 0) '${plan.monthlyAdLimit} Ads / month',
      if (plan.hasDetailedReports) 'Detailed Reports',
      if (plan.isFree) 'Basic Stats',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_badge != null)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _badge!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8),
            ),
          )
        else
          const SizedBox(height: 26),

        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
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
                    )
                  ]
                : [],
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(plan.name,
                    style: TextStyle(
                        color: _accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  plan.price == 0
                      ? '0'
                      : plan.price.toStringAsFixed(0),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900),
                ),
              ),
              Center(
                child: Text(
                  plan.isFree
                      ? 'forever'
                      : plan.durationDays <= 31
                          ? '/ month'
                          : '/ year',
                  style: const TextStyle(
                      color: Color(0xFF8099B0), fontSize: 10),
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.white.withOpacity(0.1), height: 1),
              const SizedBox(height: 10),
              ..._features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_rounded, size: 13, color: _accent),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(f,
                            style: const TextStyle(
                                color: Color(0xFFCCDDEE),
                                fontSize: 10.5,
                                height: 1.3)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? _accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? null
                        : Border.all(color: _accent.withOpacity(0.5)),
                  ),
                  child: Center(
                    child: Text(
                      plan.isFree ? 'Current Plan' : 'Select Now',
                      style: TextStyle(
                          color: isSelected ? Colors.white : _accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700),
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
//  HERO IMAGE
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
          child: Icon(Icons.sports_soccer,
              size: 120, color: Colors.white.withOpacity(0.06)),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80,
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