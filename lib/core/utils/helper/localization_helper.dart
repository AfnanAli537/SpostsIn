import 'package:sports_in/generated/l10n.dart';

extension LocalizationHelper on S {
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
        return fallback ?? 'An unexpected error occurred';
    }
  }

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