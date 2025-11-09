import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/route_generator.dart';
import 'package:sports_in/core/theme/theme_manager.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sports_in/view_model/language_cubit/language_cubit.dart';
import 'package:sports_in/view_model/theme_cubit/theme_cubit.dart';

class SportsIn extends StatelessWidget {
  final String initialRoute;
  const SportsIn({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    var locale=context.watch<LocaleCubit>().defualtLocale;
    return ScreenUtilInit(
      designSize: const Size(393, 841),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, _) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 1300),
              switchInCurve: Curves.easeInCirc,
              switchOutCurve: Curves.easeInOutCirc,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: MaterialApp(
                key: ValueKey(locale.languageCode),
                debugShowCheckedModeBanner: false,
                theme: ThemeManager.lightTheme,
                darkTheme: ThemeManager.darkTheme,
                themeAnimationCurve: Curves.easeInCirc,
                themeAnimationDuration: const Duration(milliseconds: 1000),
                themeMode: themeMode,
                initialRoute: initialRoute,
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
}
