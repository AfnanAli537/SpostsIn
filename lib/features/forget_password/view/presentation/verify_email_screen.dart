import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/auth_title.dart';
import 'package:sports_in/features/forget_password/view_model/forget_password_bloc/forget_password_bloc.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> _showError(BuildContext context, String message) async {
    final msg = await TranslateErrorHelper.translateErrorKeyAsync(
      context,
      message,
    );
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }
  @override
  Widget build(BuildContext context) {
    final string = S.of(context);
    return BlocConsumer<ForgotPasswordBloc, ForgetPasswordBlocState>(
      listener: (context, state) {
        if (state is OtpSentSuccess) {
          Fluttertoast.showToast(
            msg: string.otpSentSuccessfully,
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
          );
          Navigator.pushNamed(context, AppRoutes.otp, arguments: state.email);
        }
        if (state is ForgotPasswordFailure) {
          _showError(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0.h),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthTitle(
                      title: string.forgetPassword,
                      subtitle: string.enterEmailAddressHere,
                      hintDesc: string.enterEmailAssociated,
                    ),
                    SizedBox(height: 24.h),
                    AuthTextField(
                      validator: (value) =>
                          Validators.validateEmail(context:context, value:value),
                      label: string.email,
                      controller: emailController,
                      prefixSvg: SvgAssets.email,
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 24.h),
                    CustomElevatedButton(
                      text: state is ForgotPasswordLoading
                          ? string.loading
                          : string.sendVerificationCode,
                      isLoading: state is ForgotPasswordLoading,
                      enabled: true,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = emailController.text.trim();
                          context.read<ForgotPasswordBloc>().add(
                            SendOtpEvent(email: email),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
