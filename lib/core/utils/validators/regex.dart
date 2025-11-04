import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';

class Validators {
  static String? email({required BuildContext context, String? value}) {
    final string = S.of(context);
    if (value == null || value.isEmpty) return string.emptyEmail;
    final emailRegex = RegExp(r'^[\w-]+@([\w-]+\.)+[\w]{2,4}$');
    if (!emailRegex.hasMatch(value)) return string.validEmail;
    return null;
  }

  static String? password({required BuildContext context, String? value}) {
    final string = S.of(context);
    if (value == null || value.isEmpty) return string.emptyPassword;
    final strongPasswordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    if (!strongPasswordRegex.hasMatch(value)) {
      return string.strongPassword;
    }
    return null;
  }
}
