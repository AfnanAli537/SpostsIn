import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/widgets/auth_text_form_feild.dart';
import 'package:sports_in/view/auth/widgets/auth_title.dart';


class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     final string =S.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTitle(
                title: string.resetPassword,
                subtitle: string.enterNewPassword,
                hintDesc: string.passwordHintDesc,
              ),
              const SizedBox(height: 24),
              AuthTextField(
                prefixSvg: svgAssets.lockOn,
                label:string.newPassword ,
                controller: newPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                prefixIcon: Icons.password_outlined,
                label: string.confirmPassword,
                controller: confirmPasswordController,
                isConfirmPassword: true,
              ),
              const SizedBox(height: 32),
              CustomElevatedButton(text: string.ok, onPressed: () {Navigator.pushReplacementNamed(context, AppRoutes.login);}),
            ],
          ),
        ),
      ),
    );
  }
}
