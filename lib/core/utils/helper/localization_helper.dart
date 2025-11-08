import 'package:sports_in/generated/l10n.dart';

/// Extension to get localized error messages from error keys
extension LocalizationHelper on S {
  /// Get localized error message based on error key
  String getErrorMessage(String key, {String? fallback}) {
    switch (key) {
      // Network errors
      case 'noInternetConnection':
        return noInternetConnection;
      case 'connectionTimedOut':
        return connectionTimedOut;
      case 'requestCancelled':
        return requestCancelled;

      // Validation errors
      case 'validationError':
        return validationError;
      case 'emailAlreadyExists':
        return emailAlreadyExists;
      case 'invalidPassword':
        return invalidPassword;
      case 'passwordMismatch':
        return passwordMismatch;
      case 'invalidEmailOrPassword':
        return invalidEmailOrPassword;

      // HTTP errors
      case 'badRequest':
        return badRequest;
      case 'unauthorized':
        return unauthorized;
      case 'forbidden':
        return forbidden;
      case 'resourceNotFound':
        return resourceNotFound;
      case 'conflict':
        return conflict;
      case 'serverError':
        return serverError;
      case 'serviceUnavailable':
        return serviceUnavailable;

      // General errors
      case 'somethingWentWrong':
        return somethingWentWrong;
      case 'unexpectedError':
        return unexpectedError;
      case 'userNotFound':
        return userNotFound;

      default:
        // Return fallback message if provided, otherwise the key itself
        return fallback ?? 'An unexpected error occurred';
    }
  }

  /// Get localized success message based on message key
  String getSuccessMessage(String key, {String? fallback}) {
    switch (key) {
      case 'registrationSuccessful':
        return registrationSuccessful;
      case 'registrationFailed':
        return registrationFailed;
      default:
        return fallback ?? 'Success';
    }
  }
}