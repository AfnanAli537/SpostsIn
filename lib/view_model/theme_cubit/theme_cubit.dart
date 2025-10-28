import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/constants/strings_keys.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPref sharedPref;

  ThemeCubit(this.sharedPref) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = sharedPref.getString(StringKeys.themeKey);

    if (mode == 'light') {
      emit(ThemeMode.light);
    } else if (mode == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.system); 
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    await sharedPref.setString(StringKeys.themeKey, mode.name);
    emit(mode);
  }

  Future<void> resetToSystem() async {
    await sharedPref.setString(StringKeys.themeKey, 'system');
    emit(ThemeMode.system);
  }
}
