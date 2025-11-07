import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
import 'package:sports_in/generated/l10n.dart';
class TranslateErrorHelper {
 static String translateErrorKey(BuildContext context, String key) {
  final s = S.of(context);
  switch (key) {
    case StringKeys.connectionTimedOut:
      return s.connectionTimedOut;
    case StringKeys.requestCancelled:
      return s.requestCancelled;
    case StringKeys.somethingWentWrong:
      return s.somethingWentWrong;
    case StringKeys.invalidEmailOrPassword:
      return s.invalidEmailOrPassword;
    case StringKeys.unauthorized:
      return s.unauthorized;
    case StringKeys.resourceNotFound:
      return s.resourceNotFound;
    case StringKeys.serverError:
      return s.serverError;
      case StringKeys.noInternetConnection:
      return s.noInternetConnection;
    default:
      return s.unexpectedError;
  }
}
}
