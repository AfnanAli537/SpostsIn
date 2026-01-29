import 'package:flutter/material.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';

class InitialResolverScreen extends StatelessWidget {
  const InitialResolverScreen({super.key});

  Future<String> _resolveRoute() async {
    final sharedPref = getIt<SharedPref>();
    // await Future.delayed(const Duration(milliseconds: 50));

    final hasValidToken = sharedPref.isTokenValid();
    final bool completedOnboarding = sharedPref.getOnboardingCompleted();
    final bool seenPrivacy = sharedPref.getPrivacySeen();
    late final String initialRoute;

    if (hasValidToken) {
      initialRoute = AppRoutes.mainLayout;
    } else if (completedOnboarding) {
      initialRoute = AppRoutes.login;
    } else if (seenPrivacy) {
      initialRoute = AppRoutes.onboarding;
    } else {
      initialRoute = AppRoutes.privacyPolicy;
    }
    return initialRoute;

    // final hasValidToken = sharedPref.isTokenValid();
    // final seenPrivacy = sharedPref.getPrivacySeen();
    // final completedOnboarding = sharedPref.getOnboardingCompleted();

    // if (hasValidToken) return AppRoutes.mainLayout;
    // if (!seenPrivacy) return AppRoutes.privacyPolicy;
    // if (!completedOnboarding) return AppRoutes.onboarding;
    // return AppRoutes.login;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _resolveRoute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 👇 Navigation مرة واحدة وبنمسح كل اللي قبلها
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(snapshot.data!, (route) => false);
        });
        return const SizedBox.shrink();
        // return Navigator(
        //   initialRoute: snapshot.data!,
        //   onGenerateRoute: RoutesManager.router,
        // );
      },
    );
  }
}
