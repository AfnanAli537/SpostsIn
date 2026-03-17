// lib/features/payment/presentation/screens/vodafone_cash_screen.dart

// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/data/model/subscription%20plan%20model.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';

/// Screen shown when user selects "Mobile Wallet" (Vodafone Cash) as payment method.
///
/// Usage:
/// ```dart
/// Navigator.push(context, MaterialPageRoute(
///   builder: (_) => VodafoneCashScreen(plan: selectedPlan),
/// ));
/// ```
class VodafoneCashScreen extends StatefulWidget {
  final SubscriptionPlanModel plan;

  const VodafoneCashScreen({super.key, required this.plan});

  @override
  State<VodafoneCashScreen> createState() => _VodafoneCashScreenState();
}

class _VodafoneCashScreenState extends State<VodafoneCashScreen> {
  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _onSendPayment() {
    if (!_formKey.currentState!.validate()) return;

    context.read<PaymentBloc>().add(
          InitiatePaymentEvent(
            targetId: widget.plan.id,
            targetType: PaymentTargetType.supscription,
            method: PaymentMethod.mobileWallet,
            mobileNumber: _mobileController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
  if (state is PaymentInitiating || state is ManualActivating) {
    setState(() => _isLoading = true);
  } else {
    setState(() => _isLoading = false);
  }

  // ✅ بس pop — الـ SubscriptionScreen هيعرض الـ dialog
  if (state is ManualActivateSuccess) {
    Navigator.of(context).pop();
  }

  if (state is PaymentInitiateError || state is ManualActivateError) {
    final msg = state is PaymentInitiateError
        ? (state as PaymentInitiateError).message
        : (state as ManualActivateError).message;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }
},
      // listener: (context, state) {
      //   if (state is PaymentInitiating) {
      //     setState(() => _isLoading = true);
      //   } else {
      //     setState(() => _isLoading = false);
      //   }

      //   if (state is ManualActivateSuccess) {
      //     // Pop back to subscription screen or home
      //     Navigator.of(context).popUntil((route) => route.isFirst);
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(state.message ?? 'Subscription activated!'),
      //         backgroundColor: Colors.green,
      //       ),
      //     );
      //   } else if (state is PaymentInitiateError) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(state.message),
      //         backgroundColor: Colors.red.shade700,
      //       ),
      //     );
      //   } else if (state is ManualActivateError) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(state.message),
      //         backgroundColor: Colors.red.shade700,
      //       ),
      //     );
      //   }
      // },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () { context.read<PaymentBloc>().add(const FetchPlansEvent());Navigator.of(context).pop(); },
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          title: const Text(
            'Enter Card Details',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ── Vodafone Cash Banner ──
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      color: const Color(0xFFE60000),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Vodafone Cash icon (phone with leaf/bird)
                          _VodafoneCashIcon(),
                          const SizedBox(height: 14),
                          const Text(
                            'فودافون كاش',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Labels ──
                  const Text(
                    'Enter your payment details',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'By continuing you agree to our Terms',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black45,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Mobile Number Field ──
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Mobile Number (e.g., 010xxxxxxxx)',
                      hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black26),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE60000), width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (!RegExp(r'^01[0125]\d{8}$').hasMatch(v.trim())) {
                        return 'Enter a valid Egyptian mobile number';
                      }
                      return null;
                    },
                  ),

                  const Spacer(),

                  // ── CTA Button ──
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onSendPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A2A3A),
                        disabledBackgroundColor: const Color(0xFF1A2A3A).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFCCFF00),
                              ),
                            )
                          : const Text(
                              'Send Payment Request',
                              style: TextStyle(
                                color: Color(0xFFCCFF00),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Vodafone Cash custom icon widget
// ─────────────────────────────────────────────
class _VodafoneCashIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phone body
          Container(
            width: 44,
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: 12,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE60000),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          // Bird/check mark overlay
          Positioned(
            top: 2,
            right: 2,
            child: Icon(
              Icons.check_circle,
              color: const Color(0xFFE60000),
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}