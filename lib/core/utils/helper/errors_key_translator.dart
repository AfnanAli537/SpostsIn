import 'package:flutter/material.dart';
import 'package:sports_in/core/utils/helper/localization_helper.dart';
import 'package:sports_in/generated/l10n.dart';

class TranslateErrorHelper {
  // Sync version — for known keys only (no API call needed)
  static String translateErrorKey(BuildContext context, String key) {
    return S.of(context).getErrorMessage(key);
  }

  // Async version — translates unknown server messages via Google Translate
  static Future<String> translateErrorKeyAsync(
    BuildContext context,
    String key,
  ) async {
    //try local localization
    final s = S.of(context);
    final localized = s.getErrorMessage(key);

    // If key unchanged, then translate it
    if (localized == key) {
      return await ErrorTranslator.translate(key, context);
    }

    return localized;
  }
}