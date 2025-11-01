// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Previous`
  String get back {
    return Intl.message('Previous', name: 'back', desc: '', args: []);
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create your Account`
  String get createYourAccount {
    return Intl.message(
      'Create your Account',
      name: 'createYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Confirm password is required`
  String get confirmPasswordIsRequired {
    return Intl.message(
      'Confirm password is required',
      name: 'confirmPasswordIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDonotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDonotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordIsRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a strong password`
  String get pleaseEnteraStrongPassword {
    return Intl.message(
      'Please enter a strong password',
      name: 'pleaseEnteraStrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `At least 1 lowercase letter`
  String get lowercaseValidation {
    return Intl.message(
      'At least 1 lowercase letter',
      name: 'lowercaseValidation',
      desc: '',
      args: [],
    );
  }

  /// `At least 1 uppercase letter`
  String get uppercaseValidation {
    return Intl.message(
      'At least 1 uppercase letter',
      name: 'uppercaseValidation',
      desc: '',
      args: [],
    );
  }

  /// `At least 1 special character`
  String get specialCharacterValidation {
    return Intl.message(
      'At least 1 special character',
      name: 'specialCharacterValidation',
      desc: '',
      args: [],
    );
  }

  /// `At least 1 number`
  String get numberValidation {
    return Intl.message(
      'At least 1 number',
      name: 'numberValidation',
      desc: '',
      args: [],
    );
  }

  /// `At least 8 characters long`
  String get minLengthValidation {
    return Intl.message(
      'At least 8 characters long',
      name: 'minLengthValidation',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Chats`
  String get chats {
    return Intl.message('Chats', name: 'chats', desc: '', args: []);
  }

  /// `Chat`
  String get chat {
    return Intl.message('Chat', name: 'chat', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `create`
  String get create {
    return Intl.message('create', name: 'create', desc: '', args: []);
  }

  /// `Discover Sports Talents`
  String get onboarding1Title {
    return Intl.message(
      'Discover Sports Talents',
      name: 'onboarding1Title',
      desc: '',
      args: [],
    );
  }

  /// `Post Opportunities`
  String get onboarding2Title {
    return Intl.message(
      'Post Opportunities',
      name: 'onboarding2Title',
      desc: '',
      args: [],
    );
  }

  /// `Build Your Sports Profile`
  String get onboarding3Title {
    return Intl.message(
      'Build Your Sports Profile',
      name: 'onboarding3Title',
      desc: '',
      args: [],
    );
  }

  /// `AI Video Analysis`
  String get onboarding4Title {
    return Intl.message(
      'AI Video Analysis',
      name: 'onboarding4Title',
      desc: '',
      args: [],
    );
  }

  /// `Connect & Communicate`
  String get onboarding5Title {
    return Intl.message(
      'Connect & Communicate',
      name: 'onboarding5Title',
      desc: '',
      args: [],
    );
  }

  /// `Find and connect with top athletes through AI-powered talent discovery. Filter by sport, skills, and achievements.`
  String get onboarding1Desc {
    return Intl.message(
      'Find and connect with top athletes through AI-powered talent discovery. Filter by sport, skills, and achievements.',
      name: 'onboarding1Desc',
      desc: '',
      args: [],
    );
  }

  /// `Create and publish tryouts, competitions, or sponsorship offers to attract the right athletes.`
  String get onboarding2Desc {
    return Intl.message(
      'Create and publish tryouts, competitions, or sponsorship offers to attract the right athletes.',
      name: 'onboarding2Desc',
      desc: '',
      args: [],
    );
  }

  /// `Join SportsIn and take your sports career to the next level.`
  String get onboarding3Desc {
    return Intl.message(
      'Join SportsIn and take your sports career to the next level.',
      name: 'onboarding3Desc',
      desc: '',
      args: [],
    );
  }

  /// `Upload your performance videos and get instant AI-powered analysis on your skills, movements, and progress.`
  String get onboarding4Desc {
    return Intl.message(
      'Upload your performance videos and get instant AI-powered analysis on your skills, movements, and progress.',
      name: 'onboarding4Desc',
      desc: '',
      args: [],
    );
  }

  /// `Chat directly with coaches, clubs, and athletes. Build your sports network and stay updated with new opportunities.`
  String get onboarding5Desc {
    return Intl.message(
      'Chat directly with coaches, clubs, and athletes. Build your sports network and stay updated with new opportunities.',
      name: 'onboarding5Desc',
      desc: '',
      args: [],
    );
  }

  /// `Email Verification`
  String get emailVerfiy {
    return Intl.message(
      'Email Verification',
      name: 'emailVerfiy',
      desc: '',
      args: [],
    );
  }

  /// `or continue with`
  String get continueWith {
    return Intl.message(
      'or continue with',
      name: 'continueWith',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgetYourPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgetYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Sign in`
  String get signIn {
    return Intl.message('Sign in', name: 'signIn', desc: '', args: []);
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get notHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'notHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Login to your Account`
  String get loginToYourAccount {
    return Intl.message(
      'Login to your Account',
      name: 'loginToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Get Your Code !`
  String get GetYourCode {
    return Intl.message(
      'Get Your Code !',
      name: 'GetYourCode',
      desc: '',
      args: [],
    );
  }

  /// `please enter 4 digits code that send to yor email address`
  String get otpHint {
    return Intl.message(
      'please enter 4 digits code that send to yor email address',
      name: 'otpHint',
      desc: '',
      args: [],
    );
  }

  /// `Verify and proceed`
  String get VerifyAndProceed {
    return Intl.message(
      'Verify and proceed',
      name: 'VerifyAndProceed',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter your new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your new password must be different than the previous password`
  String get passwordHintDesc {
    return Intl.message(
      'Your new password must be different than the previous password',
      name: 'passwordHintDesc',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Forget Password`
  String get forgetPassword {
    return Intl.message(
      'Forget Password',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Email Address here`
  String get enterEmailAddressHere {
    return Intl.message(
      'Enter Email Address here',
      name: 'enterEmailAddressHere',
      desc: '',
      args: [],
    );
  }

  /// `Enter Email Address associated with your account`
  String get enterEmailAssociated {
    return Intl.message(
      'Enter Email Address associated with your account',
      name: 'enterEmailAssociated',
      desc: '',
      args: [],
    );
  }

  /// `Send verification code`
  String get sendVerificationCode {
    return Intl.message(
      'Send verification code',
      name: 'sendVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & Policy`
  String get privacyPolicyTitle {
    return Intl.message(
      'Privacy & Policy',
      name: 'privacyPolicyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Last updated: 11 October 2025`
  String get lastUpdated {
    return Intl.message(
      'Last updated: 11 October 2025',
      name: 'lastUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Introduction`
  String get introductionTitle {
    return Intl.message(
      'Introduction',
      name: 'introductionTitle',
      desc: '',
      args: [],
    );
  }

  /// `SportsIn is a professional social platform for athletes, coaches, and sports clubs to connect, share experiences, and discover opportunities.`
  String get introductionBody {
    return Intl.message(
      'SportsIn is a professional social platform for athletes, coaches, and sports clubs to connect, share experiences, and discover opportunities.',
      name: 'introductionBody',
      desc: '',
      args: [],
    );
  }

  /// `Information We Collect`
  String get informationTitle {
    return Intl.message(
      'Information We Collect',
      name: 'informationTitle',
      desc: '',
      args: [],
    );
  }

  /// `When you use SportsIn, we may collect the following types of information:\n\n• Personal data: your name, email, profile photo, sports skills, and interests.\n• Activity data: posts, messages, likes, and other interactions.\n• Device data: device type, operating system, and IP address.`
  String get informationBody {
    return Intl.message(
      'When you use SportsIn, we may collect the following types of information:\n\n• Personal data: your name, email, profile photo, sports skills, and interests.\n• Activity data: posts, messages, likes, and other interactions.\n• Device data: device type, operating system, and IP address.',
      name: 'informationBody',
      desc: '',
      args: [],
    );
  }

  /// `How We Use Your Information`
  String get useInfoTitle {
    return Intl.message(
      'How We Use Your Information',
      name: 'useInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `We use the collected data to:\n\n• Personalize your experience within the app.\n• Improve our features and services.\n• Send you relevant notifications about activities or opportunities.\n• Ensure the security and integrity of our platform.`
  String get useInfoBody {
    return Intl.message(
      'We use the collected data to:\n\n• Personalize your experience within the app.\n• Improve our features and services.\n• Send you relevant notifications about activities or opportunities.\n• Ensure the security and integrity of our platform.',
      name: 'useInfoBody',
      desc: '',
      args: [],
    );
  }

  /// `Sharing Your Information`
  String get sharingInfoTitle {
    return Intl.message(
      'Sharing Your Information',
      name: 'sharingInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `We do not share your personal data with third parties except in the following cases:\n\n• To comply with legal obligations or official requests.\n• To provide services through trusted partners (e.g., analytics or notification services).`
  String get sharingInfoBody {
    return Intl.message(
      'We do not share your personal data with third parties except in the following cases:\n\n• To comply with legal obligations or official requests.\n• To provide services through trusted partners (e.g., analytics or notification services).',
      name: 'sharingInfoBody',
      desc: '',
      args: [],
    );
  }

  /// `Changes to This Policy`
  String get changesTitle {
    return Intl.message(
      'Changes to This Policy',
      name: 'changesTitle',
      desc: '',
      args: [],
    );
  }

  /// `We may update this Privacy Policy from time to time. Any significant changes will be communicated through the app.`
  String get changesBody {
    return Intl.message(
      'We may update this Privacy Policy from time to time. Any significant changes will be communicated through the app.',
      name: 'changesBody',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactTitle {
    return Intl.message('Contact Us', name: 'contactTitle', desc: '', args: []);
  }

  /// `If you have any questions or concerns about this Privacy Policy, please contact us at: support@sportsin.app`
  String get contactBody {
    return Intl.message(
      'If you have any questions or concerns about this Privacy Policy, please contact us at: support@sportsin.app',
      name: 'contactBody',
      desc: '',
      args: [],
    );
  }

  /// `I agree`
  String get agreeLabel {
    return Intl.message('I agree', name: 'agreeLabel', desc: '', args: []);
  }

  /// `CONTINUE`
  String get continueButton {
    return Intl.message('CONTINUE', name: 'continueButton', desc: '', args: []);
  }

  /// `Enter Strong Password ,contain at least 8 characters , 1 uppercase, 1 lowercase, 1 digit , 1 special character `
  String get strongPassword {
    return Intl.message(
      'Enter Strong Password ,contain at least 8 characters , 1 uppercase, 1 lowercase, 1 digit , 1 special character ',
      name: 'strongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get emptyPassword {
    return Intl.message(
      'Password is required',
      name: 'emptyPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get emprtEmail {
    return Intl.message(
      'Email is required',
      name: 'emprtEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email`
  String get validEmail {
    return Intl.message(
      'Enter a valid email',
      name: 'validEmail',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
