// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/core/widgets/auth_title.dart';
import 'package:sports_in/features/forget_password/view_model/forget_password_bloc/forget_password_bloc.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  const EmailVerificationScreen({super.key, required this.email});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final codeControllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in codeControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _handleInputChange(String value, int index, BuildContext context) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        codeControllers[index].text = value[value.length - 1];
      }
      if (index < 5) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  void _handleKeyPress(RawKeyEvent event, int index, BuildContext context) {
    if (event is RawKeyDownEvent && event.logicalKey.keyLabel == 'Backspace') {
      if (codeControllers[index].text.isEmpty && index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
        codeControllers[index - 1].clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final string = S.of(context);
    return BlocConsumer<ForgotPasswordBloc, ForgetPasswordBlocState>(
      listener: (context, state) {
        if (state is OtpVerifiedSuccess) {
          Fluttertoast.showToast(
            msg: string.otpMsgSuccess,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
          );
          Navigator.pushNamed(
            context,
            AppRoutes.resetPassword,
            arguments: {'email': state.email, 'otp': state.otp},
          );
        }
        if (state is ForgotPasswordFailure) {
          final msg = TranslateErrorHelper.translateErrorKey(
            context,
            state.message,
          );
          Fluttertoast.showToast(
            msg: msg,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(26.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthTitle(
                    title: string.emailVerfiy,
                    subtitle: string.GetYourCode,
                    hintDesc: string.otpHint,
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (i) => SizedBox(
                        width: 45.w,
                        height: 60.h,
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (event) => _handleKeyPress(event, i, context),
                          child: TextField(
                            controller: codeControllers[i],
                            focusNode: focusNodes[i],
                            autofocus: i == 0,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.4.h,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14.h,
                              ),
                            ),
                            onChanged: (value) =>
                                _handleInputChange(value, i, context),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),
                  CustomElevatedButton(
                    text: state is ForgotPasswordLoading
                        ? string.loading
                        : string.VerifyAndProceed,
                    isLoading: state is ForgotPasswordLoading,
                    enabled: true,
                    onPressed: () {
                      final code = codeControllers.map((c) => c.text).join();

                      if (code.length == 6) {
                        context.read<ForgotPasswordBloc>().add(
                          VerifyOtpEvent(email: widget.email, otp: code),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: string.otpMsgError,
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.red,
                          toastLength: Toast.LENGTH_LONG,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
