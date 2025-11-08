import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/widgets/auth_text_form_feild.dart';
import 'package:sports_in/view/auth/widgets/auth_title.dart';


class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
     final string =S.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(24.0.h),
          child: Form(
  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUnfocus,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthTitle(title: string.forgetPassword, subtitle:string.enterEmailAddressHere ,
                hintDesc:string.enterEmailAssociated),
                 SizedBox(height: 24.h),
                AuthTextField(validator:  (value) =>
                              Validators.validateEmail(context, value),label: string.email, controller: emailController,prefixSvg: svgAssets.email,inputType: TextInputType.emailAddress,),
                 SizedBox(height: 24.h),
                CustomElevatedButton(text:string.sendVerificationCode ,
                 onPressed: () {
                   if (_formKey.currentState!.validate()) {
                            // final email = emailController.text.trim();
                  Navigator.pushNamed(context, AppRoutes.otp);}
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
