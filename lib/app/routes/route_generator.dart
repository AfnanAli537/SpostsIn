import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/di/dependency_injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/data/repo/auth_repo.dart';
import 'package:sports_in/view/auth/presentation/forget_password/verify_email_screen.dart';
import 'package:sports_in/view/auth/presentation/forget_password/reset_password.dart';
import 'package:sports_in/view/auth/presentation/login/presentation/login_screen.dart';
import 'package:sports_in/view/auth/presentation/forget_password/otp_screen.dart';
import 'package:sports_in/view/onboarding/presentation/onboarding_screen.dart';
import 'package:sports_in/view/onboarding/presentation/privacy_policy_screen.dart';
import 'package:sports_in/view_model/auth/login_bloc/login_bloc.dart';
import 'package:sports_in/view_model/onboarding_bloc/onboarding_bloc.dart';
import 'package:sports_in/view/auth/presentation/register/player/presentation/player_register.dart';
import 'package:sports_in/view/auth/presentation/register/club/presentation/club_register.dart';
import 'package:sports_in/view/auth/presentation/register/coach/presentation/coach_register.dart';
import 'package:sports_in/view/auth/presentation/register/institute/presentation/institute_register.dart';
import 'package:sports_in/view/auth/presentation/register/other/presentation/other_register.dart';
import 'package:sports_in/view/auth/presentation/register/scout/presentation/scout_register.dart';
import 'package:sports_in/view/user_type/presentation/user_type_screen.dart';
import 'package:sports_in/view_model/auth/register_bloc/register_bloc.dart';

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
      case AppRoutes.userType:
        {
          return CupertinoPageRoute(builder: (context) => UserTypeScreen());
        }
      case AppRoutes.playerRegister:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => RegistrationBloc(sl<AuthRepo>()),
            child: const PlayerRegisterScreen(),
          ),
        );
      case AppRoutes.coachRegister:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => RegistrationBloc(sl<AuthRepo>()),
              child: const CoachRegisterScreen(),
            ),
          );
        }
      case AppRoutes.instituteRegister:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => RegistrationBloc(sl<AuthRepo>()),
              child: const InstituteRegisterScreen(),
            ),
          );
        }
      case AppRoutes.otherRegister:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => RegistrationBloc(sl<AuthRepo>()),
              child: const OthersRegisterScreen(),
            ),
          );
        }
      case AppRoutes.scoutRegister:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => RegistrationBloc(sl<AuthRepo>()),
              child: const ScoutRegisterScreen(),
            ),
          );
        }
      case AppRoutes.clubRegister:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => RegistrationBloc(sl<AuthRepo>()),
              child: const ClubRegisterScreen(),
            ),
          );
        }
    }
    return null;
  }
}
