import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/di/dependency_injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/data/repo/auth_repo.dart';
import 'package:sports_in/view/auth/presentation/forget_password/forget_password.dart';
import 'package:sports_in/view/auth/presentation/forget_password/reset_password.dart';
import 'package:sports_in/view/auth/presentation/login/presentation/login_screen.dart';
import 'package:sports_in/view/auth/presentation/otp/otp_screen.dart';
import 'package:sports_in/view/onboarding/presentation/onboarding_screen.dart';
import 'package:sports_in/view/onboarding/presentation/privacy_policy_screen.dart';
import 'package:sports_in/view_model/auth/login_bloc/login_bloc.dart';
import 'package:sports_in/view_model/onboarding_bloc/onboarding_bloc.dart';

abstract class RoutesManager {
  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => LoginBloc(sl<AuthRepo>()),
              child: LoginScreen(),
            ),
          );
        }
      case AppRoutes.privacyPolicy:
        {
          return CupertinoPageRoute(
            builder: (context) => PrivacyPolicyScreen(),
          );
        }
      case AppRoutes.onboarding:
        {
          return CupertinoPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => OnboardingBloc(),
              child: OnboardingScreen(),
            ),
          );
        }
      case AppRoutes.forgetPassword:
        {
          return CupertinoPageRoute(
            builder: (context) => ForgetPasswordScreen(),
          );
        }
      case AppRoutes.otp:
        {
          return CupertinoPageRoute(
            builder: (context) => EmailVerificationScreen(),
          );
        }
      case AppRoutes.resetPassword:
        {
          return CupertinoPageRoute(
            builder: (context) => ResetPasswordScreen(),
          );
        }
    }
    return null;
  }
}
