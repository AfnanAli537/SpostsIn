// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/constants/strings_keys.dart';

class LocaleCubit extends Cubit<Locale> {
    Locale defualtLocale=window.locale;

  LocaleCubit() : super(window.locale) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final langCode = SharedPref.getString(StringKeys.languageKey);

    if (langCode != null && langCode.isNotEmpty) {
      defualtLocale=Locale(langCode);
      emit(Locale(langCode));
    } else {
      emit(window.locale); 
    }
  }

  Future<void> setLocale(Locale locale) async {
    await SharedPref.setString(StringKeys.languageKey, locale.languageCode);
    defualtLocale=locale;
    emit(locale);
  }
}


