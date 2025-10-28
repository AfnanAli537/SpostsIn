import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/cubit_provider.dart';
import 'package:sports_in/app/di/dependency_injection.dart';
import 'package:sports_in/app/sports_in.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';


late SharedPref sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await initDependencies(); 
  sharedPref = await SharedPref.init();
  final bool completedOnboarding = sharedPref.getOnboardingCompleted();
  final bool seenPrivacy = sharedPref.getPrivacySeen();
  late final String initialRoute;
  if (completedOnboarding) {
    initialRoute = AppRoutes.login;
  } else if (seenPrivacy) {
    initialRoute = AppRoutes.onboarding;
  } else {
    initialRoute = AppRoutes.privacyPolicy;
  }

  runApp( 
    MultiBlocProvider(
      providers: AppCubitProviders.getProviders(sharedPref),
      child:    SportsIn(initialRoute: initialRoute),
    ),
 );
}

