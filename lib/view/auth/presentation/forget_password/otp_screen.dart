// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/widgets/auth_title.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

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

  void _handleKeyPress(
      RawKeyEvent event, int index, BuildContext context) {
    if (event is RawKeyDownEvent &&
        event.logicalKey.keyLabel == 'Backspace') {
      if (codeControllers[index].text.isEmpty && index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
        codeControllers[index - 1].clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final string = S.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(26.0.h),
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
          style:  TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            height: 1.4.h, 
          ),
          decoration:  InputDecoration(
            counterText: '',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h), 
          ),
          onChanged: (value) => _handleInputChange(value, i, context),
        ),
      ),
    ),
  ),
),

               SizedBox(height: 40.h),
              CustomElevatedButton(
                text: string.VerifyAndProceed,
                onPressed: () {
                  final code = codeControllers.map((c) => c.text).join();

                  if (code.length == 6) {
                    Navigator.pushNamed(context, AppRoutes.resetPassword);
                       Fluttertoast.showToast(
                      msg: string.otpMsgSuccess,
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.green,
                      toastLength: Toast.LENGTH_LONG,
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
  }
}
