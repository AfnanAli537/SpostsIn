import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/view/auth/login/presentation/login_screen.dart';
import 'package:sports_in/view/auth/register/club/presentation/club_register.dart';
import 'package:sports_in/view/auth/register/coach/presentation/coach_register.dart';
import 'package:sports_in/view/auth/register/institute/presentation/institute_register.dart';
import 'package:sports_in/view/auth/register/other/presentation/other_register.dart';
import 'package:sports_in/view/auth/register/player/presentation/player_register.dart';
import 'package:sports_in/view/auth/register/scout/presentation/scout_register.dart';
import 'package:sports_in/view/user_type/presentation/user_type_screen.dart';

abstract class RoutesManager{
  static Route? router(RouteSettings settings){
    switch(settings.name){
      case AppRoutes.login:{
        return CupertinoPageRoute(builder: (context)=> LoginScreen());
      }
      case AppRoutes.userType:{
        return CupertinoPageRoute(builder: (context)=> UserTypeScreen());
      }
      case AppRoutes.playerRegister:{
        return CupertinoPageRoute(builder: (context)=> PlayerRegisterScreen());
      }
      case AppRoutes.coachRegister:{
        return CupertinoPageRoute(builder: (context)=> CoachRegisterScreen());
      }
      case AppRoutes.instituteRegister:{
        return CupertinoPageRoute(builder: (context)=> InstituteRegisterScreen());
      }
      case AppRoutes.otherRegister:{
        return CupertinoPageRoute(builder: (context)=> OtherRegisterScreen());
      }
      case AppRoutes.scoutRegister:{
        return CupertinoPageRoute(builder: (context)=> ScoutRegisterScreen());
      }
      case AppRoutes.clubRegister:{
        return CupertinoPageRoute(builder: (context)=> ClubRegisterScreen());
      }
      
    }
    return null;
  }
}