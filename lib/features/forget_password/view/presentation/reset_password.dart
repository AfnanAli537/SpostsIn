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

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final String otp;
  ResetPasswordScreen({super.key, required this.email, required this.otp});

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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
        if (state is PasswordResetSuccess) {
          Fluttertoast.showToast(
            msg: string.resetPasswordSuccess,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
          );
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
        if (state is ForgotPasswordFailure) {
          _showError(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.all(24.0.h),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthTitle(
                      title: string.resetPassword,
                      subtitle: string.enterNewPassword,
                      hintDesc: string.passwordHintDesc,
                    ),
                    SizedBox(height: 24.h),
                    AuthTextField(
                      validator: (value) =>
                          Validators.validatePassword(context:context, value:value),
                      prefixSvg: SvgAssets.lockOn,
                      label: string.newPassword,
                      controller: newPasswordController,
                      isPassword: true,
                    ),
                    SizedBox(height: 16.h),
                    AuthTextField(
                      prefixIcon: Icons.password_outlined,
                      label: string.confirmPassword,
                      controller: confirmPasswordController,
                      isConfirmPassword: true,
                      validator: (value) => Validators.validateConfirmPassword(
                        context: context,
                        value: value,
                        password: newPasswordController.text,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    CustomElevatedButton(
                      text: state is ForgotPasswordLoading
                          ? string.loading
                          : string.ok,
                      isLoading: state is ForgotPasswordLoading,
                      enabled: true,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newPassword = newPasswordController.text.trim();
                          final confirmPassword = confirmPasswordController.text
                              .trim();
                          context.read<ForgotPasswordBloc>().add(
                            ResetPasswordEvent(
                              email: email,
                              otp: otp,
                              newPassword: newPassword,
                              confirmPassword: confirmPassword,
                            ),
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
