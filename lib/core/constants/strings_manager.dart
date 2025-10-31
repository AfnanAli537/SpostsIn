// class StringsManager {
//   // Common
//   static const String register = 'Register';
//   static const String create = 'Create';
//   static const String createYourAccount = 'Create your Account';
//   static const String registeredSuccessfully = 'Registered successfully!';

//   // User Type Screen
//   static const String whatIsYourType = 'What Is Your Type?';
//   static const String knowingYourGoal =
//       'Knowing your goal helps us tailor your experience';
//   static const String continueText = 'CONTINUE';
//   static const String alreadyHaveAnAccount = 'Already have an account?';
//   static const String login = 'Login';

//   // User Types
//   static const String player = 'Player';
//   static const String coach = 'Coach';
//   static const String scout = 'Scout';
//   static const String club = 'Club';
//   static const String institute = 'Institute';
//   static const String other = 'Other';

//   // Form Labels
//   static const String firstName = 'First name';
//   static const String lastName = 'Last name';
//   static const String email = 'Email';
//   static const String password = 'Password';
//   static const String confirmPassword = 'Confirm password';
//   static const String height = 'Height (cm)';
//   static const String weight = 'Weight (kg)';
//   static const String gender = 'Gender';
//   static const String location = 'Location';
//   static const String sportProfession = 'Sport profession';
//   static const String specializedSport = 'specialized sports';
//   static const String position = 'Position';
//   static const String nationality = 'Nationality';
//   static const String yearsOfExperience = 'Years of experience';

//   // Placeholder text
//   static const String firstNamePlaceholder = 'First name';
//   static const String lastNamePlaceholder = 'Last name';
//   static const String emailPlaceholder = 'example@gmail.com';
//   static const String passwordPlaceholder = 'Password';
//   static const String confirmPasswordPlaceholder = 'Confirm your password';
//   static const String yearsOfExperiencePlaceholder = 'Years of experience';
//   static const String sportNamePlaceholder = 'Football';
//   static const String locationPlaceholder = 'Egypt';

  
//   //Institute
//   static const String instituteName = 'Institute name';
//   static const String industary = 'Industary';

//   //Club
//   static const String clubName = 'Club name';
//   static const String foundDate = 'Foundation date dd/mm/yyyy';

//   // Radio Options
//   static const String currentlyInClub = 'Currently in a Club';

//   // Gender Options
//   static const String male = 'Male';
//   static const String female = 'Female';

//   // Location Options
//   static const String algeria = 'Algeria';
//   static const String egypt = 'Egypt';
//   static const String morocco = 'Morocco';
//   static const String tunisia = 'Tunisia';
//   static const String sudan = 'Sudan';

//   // Sport Profession Options
//   static const String footballer = 'Footballer';
//   static const String basketballer = 'Basketballer';
//   static const String tennisPlayer = 'Tennis Player';
//   static const String swimmer = 'Swimmer';

//   // Sport Name Options
//   static const String football = 'Football';
//   static const String basketball = 'Basketball';
//   static const String tennis = 'Tennis';
//   static const String swimming = 'Swimming';

//   // Position Options
//   static const String goalkeeper = 'Goalkeeper';
//   static const String defender = 'Defender';
//   static const String midfielder = 'Midfielder';
//   static const String forward = 'Forward';

//   //years of experience Options
//   static const String yearsOfExperience0to2 = '0-2 years';
//   static const String yearsOfExperience3to5 = '3-5 years';
//   static const String yearsOfExperience5to10 = '6-10 years';
//   static const String yearsOfExperience10Plus = '10+ years';
// }

import 'package:flutter/widgets.dart';
import 'package:sports_in/generated/l10n.dart';

/// StringsManager
/// A clean wrapper around Flutter Intl localization.
/// Use: StringsManager.register(context) → localized string
class StringsManager {
  static S of(BuildContext context) => S.of(context);

  // 🔹 Common
  static String register(BuildContext context) => of(context).register;
  static String create(BuildContext context) => of(context).create;
  static String createYourAccount(BuildContext context) => of(context).createYourAccount;
  static String registeredSuccessfully(BuildContext context) => of(context).registeredSuccessfully;

  // 🔹 User Type Screen
  static String whatIsYourType(BuildContext context) => of(context).whatIsYourType;
  static String knowingYourGoal(BuildContext context) => of(context).knowingYourGoal;
  static String continueText(BuildContext context) => of(context).continueText;
  static String alreadyHaveAnAccount(BuildContext context) => of(context).alreadyHaveAnAccount;
  static String login(BuildContext context) => of(context).login;

  // 🔹 User Types
  static String player(BuildContext context) => of(context).player;
  static String coach(BuildContext context) => of(context).coach;
  static String scout(BuildContext context) => of(context).scout;
  static String club(BuildContext context) => of(context).club;
  static String institute(BuildContext context) => of(context).institute;
  static String other(BuildContext context) => of(context).other;

  // 🔹 Form Labels
  static String firstName(BuildContext context) => of(context).firstName;
  static String lastName(BuildContext context) => of(context).lastName;
  static String email(BuildContext context) => of(context).email;
  static String password(BuildContext context) => of(context).password;
  static String confirmPassword(BuildContext context) => of(context).confirmPassword;
  static String height(BuildContext context) => of(context).height;
  static String weight(BuildContext context) => of(context).weight;
  static String gender(BuildContext context) => of(context).gender;
  static String location(BuildContext context) => of(context).location;
  static String sportProfession(BuildContext context) => of(context).sportProfession;
  static String specializedSport(BuildContext context) => of(context).specializedSport;
  static String position(BuildContext context) => of(context).position;
  static String nationality(BuildContext context) => of(context).nationality;
  static String yearsOfExperience(BuildContext context) => of(context).yearsOfExperience;

  // 🔹 Institute
  static String instituteName(BuildContext context) => of(context).instituteName;
  static String industary(BuildContext context) => of(context).industary;

  // 🔹 Club
  static String clubName(BuildContext context) => of(context).clubName;
  static String foundDate(BuildContext context) => of(context).foundDate;

  // 🔹 Radio Options
  static String currentlyInClub(BuildContext context) => of(context).currentlyInClub;

  // 🔹 Gender Options
  static String male(BuildContext context) => of(context).male;
  static String female(BuildContext context) => of(context).female;

  // 🔹 Location Options
  static String algeria(BuildContext context) => of(context).algeria;
  static String egypt(BuildContext context) => of(context).egypt;
  static String morocco(BuildContext context) => of(context).morocco;
  static String tunisia(BuildContext context) => of(context).tunisia;
  static String sudan(BuildContext context) => of(context).sudan;

  // 🔹 Sport Profession Options
  static String footballer(BuildContext context) => of(context).footballer;
  static String basketballer(BuildContext context) => of(context).basketballer;
  static String tennisPlayer(BuildContext context) => of(context).tennisPlayer;
  static String swimmer(BuildContext context) => of(context).swimmer;

  // 🔹 Sport Name Options
  static String selectSports(BuildContext context) => of(context).selectSports;
  static String football(BuildContext context) => of(context).football;
  static String basketball(BuildContext context) => of(context).basketball;
  static String tennis(BuildContext context) => of(context).tennis;
  static String swimming(BuildContext context) => of(context).swimming;

  // 🔹 Position Options
  static String goalkeeper(BuildContext context) => of(context).goalkeeper;
  static String defender(BuildContext context) => of(context).defender;
  static String midfielder(BuildContext context) => of(context).midfielder;
  static String forward(BuildContext context) => of(context).forward;

  // 🔹 Years of experience options
  static String yearsOfExperience0to2(BuildContext context) => of(context).yearsOfExperience0to2;
  static String yearsOfExperience3to5(BuildContext context) => of(context).yearsOfExperience3to5;
  static String yearsOfExperience5to10(BuildContext context) => of(context).yearsOfExperience5to10;
  static String yearsOfExperience10Plus(BuildContext context) => of(context).yearsOfExperience10Plus;

  // 🔹 Miscellaneous
  static String selectLanguage(BuildContext context) => of(context).selectLanguage;
  static String arabic(BuildContext context) => of(context).arabic;
  static String english(BuildContext context) => of(context).english;
  static String next(BuildContext context) => of(context).next;
  static String skip(BuildContext context) => of(context).skip;
  static String back(BuildContext context) => of(context).back;
  static String forgotPassword(BuildContext context) => of(context).forgotPassword;
  static String verify(BuildContext context) => of(context).verify;
  static String signUp(BuildContext context) => of(context).signUp;
  static String notHaveAccount(BuildContext context) => of(context).notHaveAccount;
  static String confirmPasswordIsRequired(BuildContext context) => of(context).confirmPasswordIsRequired;
  static String passwordsDonotMatch(BuildContext context) => of(context).passwordsDonotMatch;
  static String passwordIsRequired(BuildContext context) => of(context).passwordIsRequired;
  static String pleaseEnteraStrongPassword(BuildContext context) => of(context).pleaseEnteraStrongPassword;
  static String selectAtLeastOne(BuildContext context) => of(context).selectAtLeastOne;
  static String lowercaseValidation(BuildContext context) => of(context).lowercaseValidation;
  static String uppercaseValidation(BuildContext context) => of(context).uppercaseValidation;
  static String specialCharacterValidation(BuildContext context) => of(context).specialCharacterValidation;
  static String numberValidation(BuildContext context) => of(context).numberValidation;
  static String minLengthValidation(BuildContext context) => of(context).minLengthValidation;
  static String home(BuildContext context) => of(context).home;
  static String chats(BuildContext context) => of(context).chats;
  static String chat(BuildContext context) => of(context).chat;
  static String profile(BuildContext context) => of(context).profile;
}
