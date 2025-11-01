import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/constants/strings_keys.dart';

class ThemeCubit extends Cubit<ThemeMode> {


  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = SharedPref.getString(StringKeys.themeKey);

    if (mode == 'light') {
      emit(ThemeMode.light);
    } else if (mode == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.system); 
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    await SharedPref.setString(StringKeys.themeKey, mode.name);
    emit(mode);
  }

  Future<void> resetToSystem() async {
    await SharedPref.setString(StringKeys.themeKey, 'system');
    emit(ThemeMode.system);
  }
}
