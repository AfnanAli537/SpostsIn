import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/view/auth/widgets/auth_text_form_feild.dart';
import 'package:sports_in/view/auth/widgets/auth_title.dart';


class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthTitle(
                title: "Reset Password",
                subtitle: "Enter your new password",
                hintDesc: "your new password must be different than previous password",
              ),
              const SizedBox(height: 24),
              AuthTextField(
                prefixSvg: svgAssets.lockOn,
                label: "New Password",
                controller: newPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                prefixIcon: Icons.password_outlined,
                label: "Confirm Password",
                controller: confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              CustomElevatedButton(text: "OK", onPressed: () {Navigator.pushReplacementNamed(context, AppRoutes.login);}),
            ],
          ),
        ),
      ),
    );
  }
}
