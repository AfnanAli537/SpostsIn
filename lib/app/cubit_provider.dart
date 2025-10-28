
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/view_model/language_cubit/language_cubit.dart';
import 'package:sports_in/view_model/theme_cubit/theme_cubit.dart';

class AppCubitProviders {
  static List<BlocProvider> getProviders(SharedPref sharedPref) {
    return [
      BlocProvider<ThemeCubit>(
        create: (_) => ThemeCubit(sharedPref),
      ),
      BlocProvider<LocaleCubit>(
        create: (_) => LocaleCubit(sharedPref),
      ),
    ];
  }
}


