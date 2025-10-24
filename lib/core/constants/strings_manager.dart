// class StringsManager {
//   ///onboarding 
//   ///title
//   ///S.of(context).edit
//   static const String onboarding1Title = "Discover Sports Talents";
  
//   static const String onboarding2Title = "Post Opportunities";
//   static const String onboarding3Title = "Build Your Sports Profile";
//   static const String onboarding4Title = "AI Video Analysis";
//   static const String onboarding5Title = "Connect & Communicate";
//   ///description
//   static const String onboarding1desc="Find and connect with top athletes through AI-powered talent discovery. Filter by sport, skills, and achievements.";
//   static const String onboarding2desc="Create and publish tryouts, competitions, or sponsorship offers to attract the right athletes.";
//   static const String onboarding3desc="Join SportsIn and take your sports career to the next level.";
//   static const String onboarding4desc="Upload your performance videos and get instant AI-powered analysis on your skills, movements, and progress.";
//   static const String onboarding5desc="Chat directly with coaches, clubs, and athletes. Build your sports network and stay updated with new opportunities.";




// }

 import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
import 'package:sports_in/generated/l10n.dart';

// class StringsManager {
//   /// Onboarding Titles
//   static String onboarding1Title(BuildContext context) =>
//       S.of(context).onboarding1Title;
//   static String onboarding2Title(BuildContext context) =>
//       S.of(context).onboarding2Title;
//   static String onboarding3Title(BuildContext context) =>
//       S.of(context).onboarding3Title;
//   static String onboarding4Title(BuildContext context) =>
//       S.of(context).onboarding4Title;
//   static String onboarding5Title(BuildContext context) =>
//       S.of(context).onboarding5Title;

//   /// Onboarding Descriptions
//   static String onboarding1Desc(BuildContext context) =>
//       S.of(context).onboarding1Desc;
//   static String onboarding2Desc(BuildContext context) =>
//       S.of(context).onboarding2Desc;
//   static String onboarding3Desc(BuildContext context) =>
//       S.of(context).onboarding3Desc;
//   static String onboarding4Desc(BuildContext context) =>
//       S.of(context).onboarding4Desc;
//   static String onboarding5Desc(BuildContext context) =>
//       S.of(context).onboarding5Desc;
// }


class StringsManager {
  static String getLocalizedString(BuildContext context, String key) {
    final s = S.of(context);
    switch (key) {
      // Titles
      case StringKeys.onboarding1Title:
        return s.onboarding1Title;
      case StringKeys.onboarding2Title:
        return s.onboarding2Title;
      case StringKeys.onboarding3Title:
        return s.onboarding3Title;
      case StringKeys.onboarding4Title:
        return s.onboarding4Title;
      case StringKeys.onboarding5Title:
        return s.onboarding5Title;

      // Descriptions
      case StringKeys.onboarding1Desc:
        return s.onboarding1Desc;
      case StringKeys.onboarding2Desc:
        return s.onboarding2Desc;
      case StringKeys.onboarding3Desc:
        return s.onboarding3Desc;
      case StringKeys.onboarding4Desc:
        return s.onboarding4Desc;
      case StringKeys.onboarding5Desc:
        return s.onboarding5Desc;

      default:
        return key; // fallback in case key missing
    }
  }
}
