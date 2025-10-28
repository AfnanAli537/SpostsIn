import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/view/auth/widgets/auth_text_form_feild.dart';
import 'package:sports_in/view/auth/widgets/auth_title.dart';


class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthTitle(title: "Forget Password", subtitle: "Enter Email Address here",
              hintDesc: "Enter Email Adress associated with your account "),
              const SizedBox(height: 24),
              AuthTextField(label: "Email", controller: emailController,prefixSvg: svgAssets.email,inputType: TextInputType.emailAddress,),
              const SizedBox(height: 24),
              CustomElevatedButton(text: "Send verification code", onPressed: () {Navigator.pushNamed(context, AppRoutes.otp);}),
            ],
          ),
        ),
      ),
    );
  }
}
