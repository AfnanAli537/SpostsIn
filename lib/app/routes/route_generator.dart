import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/data/repo/auth_repository.dart';
import 'package:sports_in/view/auth/login/presentation/login_screen.dart';
import 'package:sports_in/view/auth/register/player/presentation/player_register.dart';
import 'package:sports_in/view/auth/register/club/presentation/club_register.dart';
import 'package:sports_in/view/auth/register/coach/presentation/coach_register.dart';
import 'package:sports_in/view/auth/register/institute/presentation/institute_register.dart';
import 'package:sports_in/view/auth/register/other/presentation/other_register.dart';
import 'package:sports_in/view/auth/register/scout/presentation/scout_register.dart';
import 'package:sports_in/view/user_type/presentation/user_type_screen.dart';
import 'package:sports_in/view_model/auth/register_bloc/register_bloc.dart';

abstract class RoutesManager {
  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        {
          return CupertinoPageRoute(builder: (context) => LoginScreen());
        }
      case AppRoutes.userType:
        {
          return CupertinoPageRoute(builder: (context) => UserTypeScreen());
        }
      case AppRoutes.playerRegister:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => RegistrationBloc(RegistrationRepository()),
            child: const PlayerRegisterScreen(),
          ),
        );
      case AppRoutes.coachRegister:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => RegistrationBloc(RegistrationRepository()),
              child: const CoachRegisterScreen(),
            ),
          );
        }
      case AppRoutes.instituteRegister:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => RegistrationBloc(RegistrationRepository()),
              child: const InstituteRegisterScreen(),
            ),
          );
        }
      case AppRoutes.otherRegister:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => RegistrationBloc(RegistrationRepository()),
              child: const OthersRegisterScreen(),
            ),
          );
        }
      case AppRoutes.scoutRegister:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => RegistrationBloc(RegistrationRepository()),
              child: const ScoutRegisterScreen(),
            ),
          );
        }
      case AppRoutes.clubRegister:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => RegistrationBloc(RegistrationRepository()),
              child: const ClubRegisterScreen(),
            ),
          );
        }
    }
    return null;
  }
}
