// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/constants/strings_keys.dart';

class LocaleCubit extends Cubit<Locale> {
  final SharedPref sharedPref;

  LocaleCubit(this.sharedPref) : super(window.locale) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final langCode = sharedPref.getString(StringKeys.languageKey);

    if (langCode != null && langCode.isNotEmpty) {
      emit(Locale(langCode));
    } else {
      emit(window.locale); 
    }
  }

  Future<void> setLocale(Locale locale) async {
    await sharedPref.setString(StringKeys.languageKey, locale.languageCode);
    emit(locale);
  }
}


