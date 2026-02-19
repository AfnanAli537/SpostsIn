// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:translator/translator.dart';

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
        return fallback ?? key;
    }
  }

  String getSuccessMessage(String key, {String? fallback}) {
    switch (key) {
      case 'registrationSuccessful':
        return registrationSuccessful;
      case 'registrationFailed':
        return registrationFailed;
      default:
        return fallback ?? key;
    }
  }
}

class ErrorTranslator {
  static final GoogleTranslator _translator = GoogleTranslator();

  static Future<String> translate(String message, BuildContext context) async {
    try {
      final languageCode = Localizations.localeOf(context).languageCode;

      // No need to translate if already in English or message is empty
      if (languageCode == 'en' || message.trim().isEmpty) {
        return message;
      }

      final translation = await _translator.translate(
        message,
        to: languageCode,
      );

      return translation.text;
    } catch (e) {
      return message; 
    }
  }
}