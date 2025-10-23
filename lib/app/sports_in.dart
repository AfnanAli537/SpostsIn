import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/app/routes/route_generator.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class SportsIn extends StatelessWidget {
    const SportsIn({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:Size(393, 841) ,
      splitScreenMode: true,
      minTextAdapt: true,
      builder:(context, _)=>   MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login,
        onGenerateRoute:RoutesManager.router,
        // theme: ,
        // darkTheme:,
      localizationsDelegates: [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  locale: const Locale('en'),
  // Dynamic (uses device language)
// locale: null,
      ),
    );
  }
}