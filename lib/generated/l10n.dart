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

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Forgot Password`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
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

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
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

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Registered successfully!`
  String get registeredSuccessfully {
    return Intl.message(
      'Registered successfully!',
      name: 'registeredSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `What Is Your Type?`
  String get whatIsYourType {
    return Intl.message(
      'What Is Your Type?',
      name: 'whatIsYourType',
      desc: '',
      args: [],
    );
  }

  /// `Knowing your goal helps us tailor your experience`
  String get knowingYourGoal {
    return Intl.message(
      'Knowing your goal helps us tailor your experience',
      name: 'knowingYourGoal',
      desc: '',
      args: [],
    );
  }

  /// `CONTINUE`
  String get continueText {
    return Intl.message('CONTINUE', name: 'continueText', desc: '', args: []);
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Player`
  String get player {
    return Intl.message('Player', name: 'player', desc: '', args: []);
  }

  /// `Coach`
  String get coach {
    return Intl.message('Coach', name: 'coach', desc: '', args: []);
  }

  /// `Scout`
  String get scout {
    return Intl.message('Scout', name: 'scout', desc: '', args: []);
  }

  /// `Club`
  String get club {
    return Intl.message('Club', name: 'club', desc: '', args: []);
  }

  /// `Institute`
  String get institute {
    return Intl.message('Institute', name: 'institute', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `First name`
  String get firstName {
    return Intl.message('First name', name: 'firstName', desc: '', args: []);
  }

  /// `Last name`
  String get lastName {
    return Intl.message('Last name', name: 'lastName', desc: '', args: []);
  }

  /// `Height (cm)`
  String get height {
    return Intl.message('Height (cm)', name: 'height', desc: '', args: []);
  }

  /// `Weight (kg)`
  String get weight {
    return Intl.message('Weight (kg)', name: 'weight', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Sport profession`
  String get sportProfession {
    return Intl.message(
      'Sport profession',
      name: 'sportProfession',
      desc: '',
      args: [],
    );
  }

  /// `Specialized sports`
  String get specializedSport {
    return Intl.message(
      'Specialized sports',
      name: 'specializedSport',
      desc: '',
      args: [],
    );
  }

  /// `Position`
  String get position {
    return Intl.message('Position', name: 'position', desc: '', args: []);
  }

  /// `Nationality`
  String get nationality {
    return Intl.message('Nationality', name: 'nationality', desc: '', args: []);
  }

  /// `Years of experience`
  String get yearsOfExperience {
    return Intl.message(
      'Years of experience',
      name: 'yearsOfExperience',
      desc: '',
      args: [],
    );
  }

  /// `Institute name`
  String get instituteName {
    return Intl.message(
      'Institute name',
      name: 'instituteName',
      desc: '',
      args: [],
    );
  }

  /// `Industry`
  String get industary {
    return Intl.message('Industry', name: 'industary', desc: '', args: []);
  }

  /// `Club name`
  String get clubName {
    return Intl.message('Club name', name: 'clubName', desc: '', args: []);
  }

  /// `Foundation date dd/mm/yyyy`
  String get foundDate {
    return Intl.message(
      'Foundation date dd/mm/yyyy',
      name: 'foundDate',
      desc: '',
      args: [],
    );
  }

  /// `Currently in a Club`
  String get currentlyInClub {
    return Intl.message(
      'Currently in a Club',
      name: 'currentlyInClub',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Algeria`
  String get algeria {
    return Intl.message('Algeria', name: 'algeria', desc: '', args: []);
  }

  /// `Egypt`
  String get egypt {
    return Intl.message('Egypt', name: 'egypt', desc: '', args: []);
  }

  /// `Morocco`
  String get morocco {
    return Intl.message('Morocco', name: 'morocco', desc: '', args: []);
  }

  /// `Tunisia`
  String get tunisia {
    return Intl.message('Tunisia', name: 'tunisia', desc: '', args: []);
  }

  /// `Sudan`
  String get sudan {
    return Intl.message('Sudan', name: 'sudan', desc: '', args: []);
  }

  /// `Select a Sport`
  String get selectSports {
    return Intl.message(
      'Select a Sport',
      name: 'selectSports',
      desc: '',
      args: [],
    );
  }

  /// `Sport`
  String get sport {
    return Intl.message('Sport', name: 'sport', desc: '', args: []);
  }

  /// `Footballer`
  String get footballer {
    return Intl.message('Footballer', name: 'footballer', desc: '', args: []);
  }

  /// `Basketballer`
  String get basketballer {
    return Intl.message(
      'Basketballer',
      name: 'basketballer',
      desc: '',
      args: [],
    );
  }

  /// `Tennis Player`
  String get tennisPlayer {
    return Intl.message(
      'Tennis Player',
      name: 'tennisPlayer',
      desc: '',
      args: [],
    );
  }

  /// `Swimmer`
  String get swimmer {
    return Intl.message('Swimmer', name: 'swimmer', desc: '', args: []);
  }

  /// `Football`
  String get football {
    return Intl.message('Football', name: 'football', desc: '', args: []);
  }

  /// `Basketball`
  String get basketball {
    return Intl.message('Basketball', name: 'basketball', desc: '', args: []);
  }

  /// `Tennis`
  String get tennis {
    return Intl.message('Tennis', name: 'tennis', desc: '', args: []);
  }

  /// `Swimming`
  String get swimming {
    return Intl.message('Swimming', name: 'swimming', desc: '', args: []);
  }

  /// `Goalkeeper`
  String get goalkeeper {
    return Intl.message('Goalkeeper', name: 'goalkeeper', desc: '', args: []);
  }

  /// `Defender`
  String get defender {
    return Intl.message('Defender', name: 'defender', desc: '', args: []);
  }

  /// `Midfielder`
  String get midfielder {
    return Intl.message('Midfielder', name: 'midfielder', desc: '', args: []);
  }

  /// `Forward`
  String get forward {
    return Intl.message('Forward', name: 'forward', desc: '', args: []);
  }

  /// `0-2 years`
  String get yearsOfExperience0to2 {
    return Intl.message(
      '0-2 years',
      name: 'yearsOfExperience0to2',
      desc: '',
      args: [],
    );
  }

  /// `3-5 years`
  String get yearsOfExperience3to5 {
    return Intl.message(
      '3-5 years',
      name: 'yearsOfExperience3to5',
      desc: '',
      args: [],
    );
  }

  /// `6-10 years`
  String get yearsOfExperience5to10 {
    return Intl.message(
      '6-10 years',
      name: 'yearsOfExperience5to10',
      desc: '',
      args: [],
    );
  }

  /// `10+ years`
  String get yearsOfExperience10Plus {
    return Intl.message(
      '10+ years',
      name: 'yearsOfExperience10Plus',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get enterEmail {
    return Intl.message(
      'Please enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get enterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get shortPassword {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'shortPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDontMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your height`
  String get enterHeight {
    return Intl.message(
      'Please enter your height',
      name: 'enterHeight',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid height (100–250 cm)`
  String get invalidHeight {
    return Intl.message(
      'Please enter a valid height (100–250 cm)',
      name: 'invalidHeight',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your weight`
  String get enterWeight {
    return Intl.message(
      'Please enter your weight',
      name: 'enterWeight',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid weight (30–200 kg)`
  String get invalidWeight {
    return Intl.message(
      'Please enter a valid weight (30–200 kg)',
      name: 'invalidWeight',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your age`
  String get enterAge {
    return Intl.message(
      'Please enter your age',
      name: 'enterAge',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid age`
  String get invalidAge {
    return Intl.message(
      'Please enter a valid age',
      name: 'invalidAge',
      desc: '',
      args: [],
    );
  }

  /// `Please select a date`
  String get enterDate {
    return Intl.message(
      'Please select a date',
      name: 'enterDate',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one sport`
  String get selectAtLeastOne {
    return Intl.message(
      'Please select at least one sport',
      name: 'selectAtLeastOne',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message('Loading', name: 'loading', desc: '', args: []);
  }

  /// `name`
  String get name {
    return Intl.message('name', name: 'name', desc: '', args: []);
  }

  /// `number`
  String get number {
    return Intl.message('number', name: 'number', desc: '', args: []);
  }

  /// `field`
  String get field {
    return Intl.message('field', name: 'field', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Please enter your {field}`
  String enterField(String field) {
    return Intl.message(
      'Please enter your $field',
      name: 'enterField',
      desc: '',
      args: [field],
    );
  }

  /// `{field} is too short`
  String fieldTooShort(String field) {
    return Intl.message(
      '$field is too short',
      name: 'fieldTooShort',
      desc: '',
      args: [field],
    );
  }

  /// `Invalid {field}`
  String invalidField(String field) {
    return Intl.message(
      'Invalid $field',
      name: 'invalidField',
      desc: '',
      args: [field],
    );
  }

  /// `Please select a {field}`
  String selectField(String field) {
    return Intl.message(
      'Please select a $field',
      name: 'selectField',
      desc: '',
      args: [field],
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
