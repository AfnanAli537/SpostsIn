// import 'package:flutter/material.dart';
// import 'package:sports_in/generated/l10n.dart';
// class Validators {
//   static String? validateEmail({required BuildContext context, String? value}) {
//     final string = S.of(context);
//     if (value == null || value.isEmpty) return string.emptyEmail;
//     final emailRegex = RegExp(r'^[\w-]+@([\w-]+\.)+[\w]{2,4}$');
//     if (!emailRegex.hasMatch(value)) return string.validEmail;
//     return null;
//   }
//   static String? validatePassword({required BuildContext context, String? value}) {
//     final string = S.of(context);
//     if (value == null || value.isEmpty) return string.emptyPassword;
//     final strongPasswordRegex = RegExp(
//       r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
//     );
//     if (!strongPasswordRegex.hasMatch(value)) {
//       return string.strongPassword;
//     }
//     return null;
//   }
// }
import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';

class Validators {
  /// Helper to get localized string or fallback
  static S? _tryLocalization(BuildContext? context) {
    try {
      if (context != null) return S.of(context);
    } catch (_) {}
    return null;
  }

  // ==================== UI Layer Validators (with BuildContext) ====================
  
  /// Email validation (UI layer)
  static String? validateEmail(BuildContext? context, String? value) {
    final s = _tryLocalization(context);
    if (value == null || value.isEmpty) return s?.enterEmail ?? 'Please enter your email.';
    final emailRegex = RegExp(r'^[\w-]+@([\w-]+\.)+[\w]{2,4}$');
    if (!emailRegex.hasMatch(value)) return s?.invalidEmail ?? 'Invalid email format.';
    return null;
  }

  /// Password validation with strong password requirements (UI layer)
  static String? validatePassword(BuildContext? context, String? value) {
    final s = _tryLocalization(context);
    
    if (value == null || value.isEmpty) {
      return s?.enterPassword ?? 'Please enter your password.';
    }
    
    if (value.length < 8) {
      return s?.passwordMinLength ?? 'Password must be at least 8 characters.';
    }
    
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return s?.passwordNeedsUppercase ?? 'Password must contain at least one uppercase letter.';
    }
    
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return s?.passwordNeedsLowercase ?? 'Password must contain at least one lowercase letter.';
    }
    
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return s?.passwordNeedsNumber ?? 'Password must contain at least one number.';
    }
    
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;~`]').hasMatch(value)) {
      return s?.passwordNeedsSpecialChar ?? 'Password must contain at least one special character.';
    }
    
    return null;
  }

  /// Confirm password validation (UI layer)
  static String? validateConfirmPassword(
    BuildContext? context,
    String? value,
    String password,
  ) {
    final s = _tryLocalization(context);
    if (value == null || value.isEmpty) return s?.confirmPassword ?? 'Please confirm your password.';
    if (value != password) return s?.passwordsDontMatch ?? 'Passwords do not match.';
    return null;
  }

  /// Name validation (UI layer - supports Arabic + English)
  static String? validateName(BuildContext? context, String? value, {String? fieldName}) {
    final s = _tryLocalization(context);
    final name = fieldName ?? s?.name ?? 'name';

    if (value == null || value.isEmpty) {
      return s?.enterField(name) ?? 'Please enter your $name.';
    }
    if (value.length < 2) {
      return s?.fieldTooShort(name) ?? '$name is too short.';
    }
    final nameRegex = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return s?.invalidField(name) ?? 'Invalid $name.';
    }
    return null;
  }

  /// Height validation (UI layer)
  static String? validateHeight(BuildContext? context, String? value) {
    final s = _tryLocalization(context);
    if (value == null || value.isEmpty) return s?.enterHeight ?? 'Please enter your height.';
    final height = double.tryParse(value);
    if (height == null || height < 100 || height > 300) {
      return s?.invalidHeight ?? 'Height must be between 100 and 300 cm.';
    }
    return null;
  }

  /// Weight validation (UI layer)
  static String? validateWeight(BuildContext? context, String? value) {
    final s = _tryLocalization(context);
    if (value == null || value.isEmpty) return s?.enterWeight ?? 'Please enter your weight.';
    final weight = double.tryParse(value);
    if (weight == null || weight < 30 || weight > 250) {
      return s?.invalidWeight ?? 'Weight must be between 30 and 250 kg.';
    }
    return null;
  }
/// Height validation (UI layer)
  static String? validateAge(BuildContext? context, String? value) {
    final s = _tryLocalization(context);
    if (value == null || value.isEmpty) return s?.enterAge ?? 'Please enter your age.';
    final age = double.tryParse(value);
    if (age == null || age < 5 || age > 99) {
      return s?.invalidAge ?? 'Age must be between 5 and 99 year.';
    }
    return null;
  }

  /// Experiance validation (UI layer)
  static String? validateExperience(BuildContext? context, String? value) {
    final s = _tryLocalization(context);
    if (value == null || value.isEmpty) return s?.enterExperience ?? 'Please enter your Experience years.';
    final exp = double.tryParse(value);
    if (exp == null || exp < 0 || exp > 60) {
      return s?.invalidExperience ?? 'Age must be between 0 and 60 year.';
    }
    return null;
  }

  /// Dropdown validation (UI layer)
  static String? validateDropdown(BuildContext? context, String? value, {String? fieldName}) {
    final s = _tryLocalization(context);
    final name = fieldName ?? s?.field ?? 'field';
    if (value == null || value.isEmpty) {
      return s?.selectField(name) ?? 'Please select a $name.';
    }
    return null;
  }

  /// Required field validation (UI layer)
  static String? validateRequired(BuildContext? context, String? value, {String? fieldName}) {
    final s = _tryLocalization(context);
    final name = fieldName ?? s?.field ?? 'field';
    if (value == null || value.isEmpty) {
      return s?.enterField(name) ?? 'Please enter $name.';
    }
    return null;
  }
  
  /// List validation (UI layer)
  static String? validateList(BuildContext? context, List<String>? value, {String? fieldName}) {
    final s = _tryLocalization(context);
    final name = fieldName ??  s?.field ?? 'field';
    if (value == null || value.isEmpty) {
      return s?.enterField(name) ?? 'Please enter $name.';
    }
    return null;
  }

  /// Date validation (UI layer)
  static String? validateDate(BuildContext? context, String? value) {
    final s = _tryLocalization(context);
    if (value == null || value.isEmpty) return s?.enterDate ?? 'Please enter a date.';
    return null;
  }

  // ==================== BLoC Layer Validators (Localized, no BuildContext) ====================

  /// Email validation (BLoC layer)
  static ValidationResult validateEmailBLoC(String? value, S localizations) {
    if (value == null || value.isEmpty) {
      return ValidationResult.error(localizations.enterEmail);
    }
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(value)) {
      return ValidationResult.error(localizations.invalidEmail);
    }
    return ValidationResult.success();
  }

  /// Password validation with strong password requirements (BLoC layer)
  static ValidationResult validatePasswordBLoC(String? value, S localizations) {
    if (value == null || value.isEmpty) {
      return ValidationResult.error(localizations.passwordIsRequired);
    }
    
    if (value.length < 8) {
      return ValidationResult.error(
        localizations.passwordMinLength
      );
    }
    
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return ValidationResult.error(
        localizations.passwordNeedsUppercase
      );
    }
    
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return ValidationResult.error(
        localizations.passwordNeedsLowercase
      );
    }
    
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return ValidationResult.error(
        localizations.passwordNeedsNumber
      );
    }
    
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;~`]').hasMatch(value)) {
      return ValidationResult.error(
        localizations.passwordNeedsSpecialChar
      );
    }
    
    return ValidationResult.success();
  }

  /// Confirm Password validation (BLoC layer)
  static ValidationResult validateConfirmPasswordBLoC(String? value, S localizations, {String? password}) {
    if (value == null || value.isEmpty) {
      return ValidationResult.error(localizations.confirmPasswordIsRequired);
    }
    if (value != password) {
      return ValidationResult.error(localizations.passwordsDonotMatch);
    }
    return ValidationResult.success();
  }

  /// Name validation (BLoC layer - supports Arabic + English)
  static ValidationResult validateNameBLoC(String? value, S localizations, {String? fieldName}) {
    final name = fieldName ?? localizations.name;

    if (value == null || value.isEmpty) {
      return ValidationResult.error(localizations.enterField(name));
    }
    if (value.length < 2) {
      return ValidationResult.error(localizations.fieldTooShort(name));
    }
    final nameRegex = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return ValidationResult.error(localizations.invalidField(name));
    }
    return ValidationResult.success();
  }

  /// Height validation (BLoC layer)
  static ValidationResult validateHeightBLoC(int? value, S localizations) {
    if (value == null) {
      return ValidationResult.error(localizations.enterHeight);
    }
    final height =value;
    if (height < 100 || height > 300) {
      return ValidationResult.error(localizations.invalidHeight);
    }
    return ValidationResult.success();
  }

  /// Weight validation (BLoC layer)
  static ValidationResult validateWeightBLoC(int? value, S localizations) {
    if (value == null) {
      return ValidationResult.error(localizations.enterWeight);
    }
    final weight = value;
    if (weight < 30 || weight > 250) {
      return ValidationResult.error(localizations.invalidWeight);
    }
    return ValidationResult.success();
  }
 /// Age validation (BLoC layer)
  static ValidationResult validateAgeBLoC(int? value, S localizations) {
    if (value == null) {
      return ValidationResult.error(localizations.enterAge);
    }
    final age = value;
    if (age < 5 || age > 99) {
      return ValidationResult.error(localizations.invalidAge);
    }
    return ValidationResult.success();
  }
/// Experience validation (BLoC layer)
  static ValidationResult validateExperienceBLoC(int? value, S localizations,) {
    if (value == null) {
      return ValidationResult.error(localizations.enterExperience);
    }
    final exp = value;
    if (exp < 0 || exp > 60) {
      return ValidationResult.error(localizations.invalidExperience);
    }
    return ValidationResult.success();
  }
  /// Dropdown validation (BLoC layer)
  static ValidationResult validateDropdownBLoC(String? value, S localizations, {String? fieldName}) {
    final name = fieldName ?? localizations.field;
    if (value == null || value.isEmpty) {
      return ValidationResult.error(localizations.selectField(name));
    }
    return ValidationResult.success();
  }

  /// Required field validation (BLoC layer)
  static ValidationResult validateRequiredBLoC(String? value, S localizations, {String? fieldName}) {
    final name = fieldName ?? localizations.field;
    if (value == null || value.isEmpty) {
      return ValidationResult.error(localizations.enterField(name));
    }
    return ValidationResult.success();
  }

  /// Date validation (BLoC layer)
  static ValidationResult validateDateBLoC(String? value, S localizations) {
    if (value == null || value.isEmpty) {
      return ValidationResult.error(localizations.enterDate);
    }
    return ValidationResult.success();
  }

  /// List validation (BLoC layer)
  static ValidationResult validateListBLoC(List<String>? value, S localizations, {String? fieldName}) {
    final name = fieldName ?? localizations.field;
    if (value == null || value.isEmpty) {
      return ValidationResult.error(localizations.selectField(name));
    }
    return ValidationResult.success();
  }
}

/// Result class for BLoC validation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult._(this.isValid, this.errorMessage);

  factory ValidationResult.success() => const ValidationResult._(true, null);
  
  factory ValidationResult.error(String message) => ValidationResult._(false, message);
}