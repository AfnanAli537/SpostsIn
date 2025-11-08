import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/widgets/auth_text_form_feild.dart';
import 'package:sports_in/view/auth/widgets/auth_title.dart';


class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
   final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
     final string =S.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.all(24.0.h),
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
                 validator:  (value) =>
                              Validators.validatePassword(context, value),
                  prefixSvg: svgAssets.lockOn,
                  label:string.newPassword ,
                  controller: newPasswordController,
                  isPassword: true,
                ),
                 SizedBox(height: 16.h),
                AuthTextField(
                  prefixIcon: Icons.password_outlined,
                  label: string.confirmPassword,
                  controller: confirmPasswordController,
                  isConfirmPassword: true,
                  validator:  (value) =>
                              Validators.validateConfirmPassword(context, value,newPasswordController.text),
                ),
                 SizedBox(height: 32.h),
                
                CustomElevatedButton(text: string.ok, onPressed: () {
                      if (_formKey.currentState!.validate()) {
                            // final newPassword = newPasswordController.text.trim();
                            // final confirmPassword =confirmPasswordController.text.trim();
      Fluttertoast.showToast(
                      msg: string.resetPasswordSuccess,
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.green,
                      toastLength: Toast.LENGTH_LONG,
                    );
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                    
                  }
                  else{
                       Fluttertoast.showToast(
                      msg: string.resetPasswordFailure,
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.red,
                      toastLength: Toast.LENGTH_LONG,
                    );
                  }
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
