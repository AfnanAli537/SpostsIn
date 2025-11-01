import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/widgets/auth_title.dart';


class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key});

  final codeControllers =
      List.generate(4, (_) => TextEditingController());

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
              AuthTitle(
                 title:string.emailVerfiy,
                  subtitle: string.GetYourCode,
                  hintDesc: string.otpHint,),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (i) => SizedBox(
                    width: 60,
                    child: TextField(
                      controller: codeControllers[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomElevatedButton(text:string.VerifyAndProceed, onPressed: () {Navigator.pushNamed(context, AppRoutes.resetPassword);}),
            ],
          ),
        ),
      ),
    );
  }
}






