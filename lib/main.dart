import 'package:flutter/material.dart';
import 'package:sports_in/app/sports_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/app/routes/app_routes.dart';

// void main() {
//   runApp(const SportsIn());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final seenPrivacy = prefs.getBool('seenPrivacy') ?? false;
  final completedOnboarding = prefs.getBool('completedOnboarding') ?? false;

  String initialRoute;
  if (completedOnboarding) {
    initialRoute = AppRoutes.login;
  } else if (seenPrivacy) {
    initialRoute = AppRoutes.onboarding;
  } else {
    initialRoute = AppRoutes.privacyPolicy;
  }

  runApp(SportsIn(initialRoute: initialRoute));
}

