import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/view/auth/login/presentation/login_screen.dart';
import 'package:sports_in/view/onboarding/presentation/onboarding_screen.dart';
import 'package:sports_in/view/onboarding/presentation/privacy_policy_screen.dart';

abstract class RoutesManager{
  static Route? router(RouteSettings settings){
    switch(settings.name){
      case AppRoutes.login:{
        return CupertinoPageRoute(builder: (context)=> LoginScreen());
      }
      case AppRoutes.privacyPolicy:{
        return CupertinoPageRoute(builder: (context)=> PrivacyPolicyScreen());
      }
      case AppRoutes.onboarding:{
        return CupertinoPageRoute(builder: (context)=> OnboardingScreen());
      }
    }
    return null;
  }
}