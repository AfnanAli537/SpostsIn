import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';

class Validators {
  /// Email validation
  static String? validateEmail(BuildContext context, String? value) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterEmail;
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(value)) return s.invalidEmail;
    return null;
  }

  /// Password validation
  static String? validatePassword(BuildContext context, String? value) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterPassword;
    if (value.length < 6) return s.shortPassword;
    return null;
  }

  /// Confirm password validation
  static String? validateConfirmPassword(
    BuildContext context,
    String? value,
    String password,
  ) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.confirmPassword;
    if (value != password) return s.passwordsDontMatch;
    return null;
  }

  /// Name validation (supports Arabic + English)
  static String? validateName(BuildContext context, String? value,
      {String? fieldName}) {
    final s = S.of(context);
    if (value == null || value.isEmpty) {
      return s.enterField(fieldName ?? s.name);
    }
    if (value.length < 2) {
      return s.fieldTooShort(fieldName ?? s.name);
    }
    final nameRegex = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return s.invalidField(fieldName ?? s.name);
    }
    return null;
  }

  /// Number validation (for generic numerical fields)
  static String? validateNumber(BuildContext context, String? value,
      {String? fieldName}) {
    final s = S.of(context);
    if (value == null || value.isEmpty) {
      return s.enterField(fieldName ?? '');
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return s.invalidField(fieldName ?? '');
    }
    return null;
  }

  /// Height validation (typically between 100–250 cm)
  static String? validateHeight(BuildContext context, String? value) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterHeight;
    final height = double.tryParse(value);
    if (height == null || height < 100 || height > 300) {
      return s.invalidHeight;
    }
    return null;
  }

  /// Weight validation (typically between 30–200 kg)
  static String? validateWeight(BuildContext context, String? value) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterWeight;
    final weight = double.tryParse(value);
    if (weight == null || weight < 30 || weight > 250) {
      return s.invalidWeight;
    }
    return null;
  }

  /// Dropdown validation
  static String? validateDropdown(BuildContext context, String? value,
      {String? fieldName}) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.selectField(fieldName ?? '');
    return null;
  }

  /// Required field validation
  static String? validateRequired(BuildContext context, String? value,
      {String? fieldName}) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterField(fieldName ?? '');
    return null;
  }

  /// Age validation
  static String? validateAge(BuildContext context, String? value) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterAge;
    final age = int.tryParse(value);
    if (age == null || age < 1 || age > 120) return s.invalidAge;
    return null;
  }

  /// Date validation (for your DatePickerTextField)
  static String? validateDate(BuildContext context, String? value) {
    final s = S.of(context);
    if (value == null || value.isEmpty) return s.enterDate;
    return null;
  }
}
