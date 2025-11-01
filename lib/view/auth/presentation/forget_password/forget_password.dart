import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/widgets/auth_text_form_feild.dart';
import 'package:sports_in/view/auth/widgets/auth_title.dart';


class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     final string =S.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTitle(title: string.forgetPassword, subtitle:string.enterEmailAddressHere ,
              hintDesc:string.enterEmailAssociated),
              const SizedBox(height: 24),
              AuthTextField(label: string.email, controller: emailController,prefixSvg: svgAssets.email,inputType: TextInputType.emailAddress,),
              const SizedBox(height: 24),
              CustomElevatedButton(text:string.sendVerificationCode , onPressed: () {Navigator.pushNamed(context, AppRoutes.otp);}),
            ],
          ),
        ),
      ),
    );
  }
}
