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

  /// `Sign in`
  String get signIn {
    return Intl.message('Sign in', name: 'signIn', desc: '', args: []);
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

  /// `Handball Player`
  String get handballPlayer {
    return Intl.message(
      'Handball Player',
      name: 'handballPlayer',
      desc: '',
      args: [],
    );
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

  /// `Volleyballer`
  String get volleyballer {
    return Intl.message(
      'Volleyballer',
      name: 'volleyballer',
      desc: '',
      args: [],
    );
  }

  /// `Teakwando Player`
  String get teakwandoPlayer {
    return Intl.message(
      'Teakwando Player',
      name: 'teakwandoPlayer',
      desc: '',
      args: [],
    );
  }

  /// `Gymnast`
  String get gymnast {
    return Intl.message('Gymnast', name: 'gymnast', desc: '', args: []);
  }

  /// `Football`
  String get football {
    return Intl.message('Football', name: 'football', desc: '', args: []);
  }

  /// `Handball`
  String get handball {
    return Intl.message('Handball', name: 'handball', desc: '', args: []);
  }

  /// `Basketball`
  String get basketball {
    return Intl.message('Basketball', name: 'basketball', desc: '', args: []);
  }

  /// `Volleyball`
  String get volleyball {
    return Intl.message('Volleyball', name: 'volleyball', desc: '', args: []);
  }

  /// `Teakwando`
  String get teakwando {
    return Intl.message('Teakwando', name: 'teakwando', desc: '', args: []);
  }

  /// `Gymnastics`
  String get gymnastics {
    return Intl.message('Gymnastics', name: 'gymnastics', desc: '', args: []);
  }

  /// `Point Guard`
  String get pointGuard {
    return Intl.message('Point Guard', name: 'pointGuard', desc: '', args: []);
  }

  /// `Shooting Guard`
  String get shootingGuard {
    return Intl.message(
      'Shooting Guard',
      name: 'shootingGuard',
      desc: '',
      args: [],
    );
  }

  /// `Small Forward`
  String get smallForward {
    return Intl.message(
      'Small Forward',
      name: 'smallForward',
      desc: '',
      args: [],
    );
  }

  /// `Power Forward`
  String get powerForward {
    return Intl.message(
      'Power Forward',
      name: 'powerForward',
      desc: '',
      args: [],
    );
  }

  /// `Center`
  String get center {
    return Intl.message('Center', name: 'center', desc: '', args: []);
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

  /// `Setter`
  String get setter {
    return Intl.message('Setter', name: 'setter', desc: '', args: []);
  }

  /// `Outside Hitter`
  String get outsideHitter {
    return Intl.message(
      'Outside Hitter',
      name: 'outsideHitter',
      desc: '',
      args: [],
    );
  }

  /// `Opposite Hitter`
  String get oppositeHitter {
    return Intl.message(
      'Opposite Hitter',
      name: 'oppositeHitter',
      desc: '',
      args: [],
    );
  }

  /// `Middle Blocker`
  String get middleBlocker {
    return Intl.message(
      'Middle Blocker',
      name: 'middleBlocker',
      desc: '',
      args: [],
    );
  }

  /// `Libero`
  String get libero {
    return Intl.message('Libero', name: 'libero', desc: '', args: []);
  }

  /// `Left Wing`
  String get leftWing {
    return Intl.message('Left Wing', name: 'leftWing', desc: '', args: []);
  }

  /// `Right Wing`
  String get rightWing {
    return Intl.message('Right Wing', name: 'rightWing', desc: '', args: []);
  }

  /// `Left Back`
  String get leftBack {
    return Intl.message('Left Back', name: 'leftBack', desc: '', args: []);
  }

  /// `Center Back`
  String get centerBack {
    return Intl.message('Center Back', name: 'centerBack', desc: '', args: []);
  }

  /// `Right Back`
  String get rightBack {
    return Intl.message('Right Back', name: 'rightBack', desc: '', args: []);
  }

  /// `Pivot`
  String get pivot {
    return Intl.message('Pivot', name: 'pivot', desc: '', args: []);
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

  /// `Password must be at least 8 characters.`
  String get passwordMinLength {
    return Intl.message(
      'Password must be at least 8 characters.',
      name: 'passwordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one uppercase letter.`
  String get passwordNeedsUppercase {
    return Intl.message(
      'Password must contain at least one uppercase letter.',
      name: 'passwordNeedsUppercase',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one lowercase letter.`
  String get passwordNeedsLowercase {
    return Intl.message(
      'Password must contain at least one lowercase letter.',
      name: 'passwordNeedsLowercase',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one number.`
  String get passwordNeedsNumber {
    return Intl.message(
      'Password must contain at least one number.',
      name: 'passwordNeedsNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one special character (!@#$%^&* etc).`
  String get passwordNeedsSpecialChar {
    return Intl.message(
      'Password must contain at least one special character (!@#\$%^&* etc).',
      name: 'passwordNeedsSpecialChar',
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

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
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

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
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
