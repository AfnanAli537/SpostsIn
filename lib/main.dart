import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/di/dependency_injection.dart';
import 'package:sports_in/app/sports_in.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/view_model/language_cubit/language_cubit.dart';
import 'package:sports_in/view_model/theme_cubit/theme_cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies(); 
  await SharedPref.init();
  final bool completedOnboarding = SharedPref.getOnboardingCompleted();
  final bool seenPrivacy = SharedPref.getPrivacySeen();
  late final String initialRoute;
  if (completedOnboarding) {
    initialRoute = AppRoutes.login;
  } else if (seenPrivacy) {
    initialRoute = AppRoutes.onboarding;
  } else {
    initialRoute = AppRoutes.privacyPolicy;
  }
   await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]); 
  runApp( 
    MultiBlocProvider(
      providers:[BlocProvider<ThemeCubit>(
        create: (_) => ThemeCubit(),
      ),
      BlocProvider<LocaleCubit>(
        create: (_) => LocaleCubit(),
      ),
      ],
      child:SportsIn(initialRoute: initialRoute),
    ),
 );
}

