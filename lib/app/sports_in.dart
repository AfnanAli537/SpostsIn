import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/app/routes/route_generator.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/theme/theme_manager.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sports_in/core/config/language_cubit/language_cubit.dart';
import 'package:sports_in/core/config/theme_cubit/theme_cubit.dart';

class SportsIn extends StatelessWidget {
  const SportsIn({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = context.watch<LocaleCubit>().defualtLocale;
    return ScreenUtilInit(
      designSize: const Size(393, 841),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, _) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              switchInCurve: Curves.easeInCirc,
              switchOutCurve: Curves.easeInCirc,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: MaterialApp(
                key: ValueKey(locale.languageCode),
                debugShowCheckedModeBanner: false,
                theme: ThemeManager.lightTheme,
                darkTheme: ThemeManager.darkTheme,
                themeAnimationCurve: Curves.easeInCirc,
                themeAnimationDuration: const Duration(milliseconds: 300),
                themeMode: themeMode,
                initialRoute: getInitialRoute(),
                onGenerateRoute: RoutesManager.router,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                locale: locale,
              ),
            );
          },
        );
      },
    );
  }

  String getInitialRoute() {
    final sharedPref = getIt<SharedPref>();
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
  }
}
