import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';

class Validators {
  /// Email validation 
  static String? validateEmail({required BuildContext context, String? value}) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterEmail;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return s.invalidEmail;
    return null;
  }

/// Password validation with strong password requirements
  static String? validatePassword({required BuildContext context, String? value}) {
    final string = S.of(context);
    if (value == null || value.isEmpty) return string.emptyPassword;
   final strongPasswordRegex = RegExp(
  r'''^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;'`~])[A-Za-z\d!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;'`~]{8,}$''',
);
    if (!strongPasswordRegex.hasMatch(value)) {
      return string.strongPassword;
    }
    return null;
  }
  // /// Password validation with strong password requirements
  // static String? validatePassword({required BuildContext context, String? value}) {
  //   final s = S.of(context);
  //   if (value == null || value.isEmpty) {
  //     return s.enterPassword;
  //   }
  //   if (value.length < 8) {
  //     return s.passwordMinLength ;
  //   }
  //   // Check for at least one uppercase letter
  //   if (!RegExp(r'[A-Z]').hasMatch(value)) {
  //     return s.passwordNeedsUppercase ;
  //   }
  //   // Check for at least one lowercase letter
  //   if (!RegExp(r'[a-z]').hasMatch(value)) {
  //     return s.passwordNeedsLowercase ;
  //   }
  //   // Check for at least one digit
  //   if (!RegExp(r'[0-9]').hasMatch(value)) {
  //     return s.passwordNeedsNumber ;
  //   }
  //   // Check for at least one special character
  //   if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;~`]').hasMatch(value)) {
  //     return s.passwordNeedsSpecialChar ;
  //   }
  //   return null;
  // }

  /// Confirm password validation 
  static String? validateConfirmPassword(
    {required BuildContext context,
     String? value,
    required String password,}
  ) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.confirmPassword ;
    if (value != password) return s.passwordsDontMatch;
    return null;
  }

  /// Name validation
  static String? validateName({required BuildContext context, String? value, String? fieldName}) {
    final s = S.of(context);
    final name = fieldName ?? s.name;

    if (value == null || value.isEmpty) {
      return s.enterField(name);
    }
    if (value.length < 2) {
      return s.fieldTooShort(name);
    }
    final nameRegex = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return s.invalidField(name);
    }
    return null;
  }

  /// Height validation
  static String? validateHeight({required BuildContext context, String? value}) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterHeight;
    final height = double.tryParse(value);
    if (height == null || height < 100 || height > 300) {
      return s.invalidHeight ;
    }
    return null;
  }

  /// Weight validation
  static String? validateWeight({required BuildContext context, String? value}) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterWeight;
    final weight = double.tryParse(value);
    if (weight == null || weight < 30 || weight > 250) {
      return s.invalidWeight;
    }
    return null;
  }
/// Height validation
  static String? validateAge({required BuildContext context, String? value}) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterAge;
    final age = double.tryParse(value);
    if (age == null || age < 5 || age > 99) {
      return s.invalidAge;
    }
    return null;
  }

  /// Experiance validation
  static String? validateExperience({required BuildContext context, String? value}) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterExperience;
    final exp = double.tryParse(value);
    if (exp == null || exp < 0 || exp > 60) {
      return s.invalidExperience;
    }
    return null;
  }

  /// Dropdown validation
  static String? validateDropdown({required BuildContext context, String? value, String? fieldName}) {
    final s = S.of(context);
    final name = fieldName ?? s.field;
    if (value == null || value.isEmpty) {
      return s.selectField(name);
    }
    return null;
  }

  /// Required field validation
  static String? validateRequired({required BuildContext context, String? value, String? fieldName}) {
    final s = S.of(context);
    final name = fieldName ?? s.field;
    if (value == null || value.isEmpty) {
      return s.enterField(name);
    }
    return null;
  }
  
  /// List validation
  static String? validateList({required BuildContext context, List<String>? value, String? fieldName}) {
    final s = S.of(context);
    final name = fieldName ??  s.field;
    if (value == null || value.isEmpty) {
      return s.enterField(name);
    }
    return null;
  }

  /// Date validation
  static String? validateDate({required BuildContext context, String? value}) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterDate;
    return null;
  }

}
