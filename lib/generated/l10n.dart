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

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
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

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
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

  /// `Foundation date`
  String get foundDate {
    return Intl.message(
      'Foundation date',
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

  /// `Please enter a valid age (5-99)`
  String get invalidAge {
    return Intl.message(
      'Please enter a valid age (5-99)',
      name: 'invalidAge',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Experience years.`
  String get enterExperience {
    return Intl.message(
      'Please enter your Experience years.',
      name: 'enterExperience',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Experience years.`
  String get invalidExperience {
    return Intl.message(
      'Please enter your Experience years.',
      name: 'invalidExperience',
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

  /// `please enter 6 digits code that send to yor email address`
  String get otpHint {
    return Intl.message(
      'please enter 6 digits code that send to yor email address',
      name: 'otpHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter all 6 digits to verify your email`
  String get otpMsgError {
    return Intl.message(
      'Please enter all 6 digits to verify your email',
      name: 'otpMsgError',
      desc: '',
      args: [],
    );
  }

  /// `Your email has been verified successfully`
  String get otpMsgSuccess {
    return Intl.message(
      'Your email has been verified successfully',
      name: 'otpMsgSuccess',
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

  /// `Your password has been reset successfully`
  String get resetPasswordSuccess {
    return Intl.message(
      'Your password has been reset successfully',
      name: 'resetPasswordSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to reset password. Please try again`
  String get resetPasswordFailure {
    return Intl.message(
      'Failed to reset password. Please try again',
      name: 'resetPasswordFailure',
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

  /// `OTP sent successfully! Please check your email.`
  String get otpSentSuccessfully {
    return Intl.message(
      'OTP sent successfully! Please check your email.',
      name: 'otpSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Session expired, please login again`
  String get tokenEX {
    return Intl.message(
      'Session expired, please login again',
      name: 'tokenEX',
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
  String get emptyEmail {
    return Intl.message(
      'Email is required',
      name: 'emptyEmail',
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

  /// `Signing in...`
  String get signingIn {
    return Intl.message('Signing in...', name: 'signingIn', desc: '', args: []);
  }

  /// `Welcome back,let’s get started!`
  String get loginSuccess {
    return Intl.message(
      'Welcome back,let’s get started!',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Connection timed out. Please try again.`
  String get connectionTimedOut {
    return Intl.message(
      'Connection timed out. Please try again.',
      name: 'connectionTimedOut',
      desc: '',
      args: [],
    );
  }

  /// `Request was cancelled.`
  String get requestCancelled {
    return Intl.message(
      'Request was cancelled.',
      name: 'requestCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error occurred.`
  String get unexpectedError {
    return Intl.message(
      'Unexpected error occurred.',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again.`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong. Please try again.',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password.`
  String get invalidEmailOrPassword {
    return Intl.message(
      'Invalid email or password.',
      name: 'invalidEmailOrPassword',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized. Please check your credentials.`
  String get unauthorized {
    return Intl.message(
      'Unauthorized. Please check your credentials.',
      name: 'unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Resource not found.`
  String get resourceNotFound {
    return Intl.message(
      'Resource not found.',
      name: 'resourceNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Server error. Please try again later.`
  String get serverError {
    return Intl.message(
      'Server error. Please try again later.',
      name: 'serverError',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get noInternetConnection {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful!`
  String get registrationSuccessful {
    return Intl.message(
      'Registration successful!',
      name: 'registrationSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed. Please try again.`
  String get registrationFailed {
    return Intl.message(
      'Registration failed. Please try again.',
      name: 'registrationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Validation error. Please check your inputs.`
  String get validationError {
    return Intl.message(
      'Validation error. Please check your inputs.',
      name: 'validationError',
      desc: '',
      args: [],
    );
  }

  /// `This email is already registered`
  String get emailAlreadyExists {
    return Intl.message(
      'This email is already registered',
      name: 'emailAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Invalid password`
  String get invalidPassword {
    return Intl.message(
      'Invalid password',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordMismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Invalid request`
  String get badRequest {
    return Intl.message(
      'Invalid request',
      name: 'badRequest',
      desc: '',
      args: [],
    );
  }

  /// `Access forbidden`
  String get forbidden {
    return Intl.message(
      'Access forbidden',
      name: 'forbidden',
      desc: '',
      args: [],
    );
  }

  /// `Data conflict occurred`
  String get conflict {
    return Intl.message(
      'Data conflict occurred',
      name: 'conflict',
      desc: '',
      args: [],
    );
  }

  /// `Service temporarily unavailable`
  String get serviceUnavailable {
    return Intl.message(
      'Service temporarily unavailable',
      name: 'serviceUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get userNotFound {
    return Intl.message(
      'User not found',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notifications {
    return Intl.message(
      'Notification',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get settings {
    return Intl.message('Setting', name: 'settings', desc: '', args: []);
  }

  /// `Light`
  String get theme {
    return Intl.message('Light', name: 'theme', desc: '', args: []);
  }

  /// `About us`
  String get aboutUs {
    return Intl.message('About us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Contact us`
  String get contactUs {
    return Intl.message('Contact us', name: 'contactUs', desc: '', args: []);
  }

  /// `LOG OUT`
  String get logout {
    return Intl.message('LOG OUT', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Followers`
  String get followers {
    return Intl.message('Followers', name: 'followers', desc: '', args: []);
  }

  /// `Following`
  String get following {
    return Intl.message('Following', name: 'following', desc: '', args: []);
  }

  /// `Connections`
  String get connections {
    return Intl.message('Connections', name: 'connections', desc: '', args: []);
  }

  /// `Analyzed People`
  String get analyzedPeople {
    return Intl.message(
      'Analyzed People',
      name: 'analyzedPeople',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get connect {
    return Intl.message('Connect', name: 'connect', desc: '', args: []);
  }

  /// `Follow`
  String get follow {
    return Intl.message('Follow', name: 'follow', desc: '', args: []);
  }

  /// `Connected`
  String get connected {
    return Intl.message('Connected', name: 'connected', desc: '', args: []);
  }

  /// `Posts`
  String get posts {
    return Intl.message('Posts', name: 'posts', desc: '', args: []);
  }

  /// `My Posts`
  String get myPosts {
    return Intl.message('My Posts', name: 'myPosts', desc: '', args: []);
  }

  /// `Post Title`
  String get postTitle {
    return Intl.message('Post Title', name: 'postTitle', desc: '', args: []);
  }

  /// `No Posts`
  String get noPosts {
    return Intl.message('No Posts', name: 'noPosts', desc: '', args: []);
  }

  /// `Post deleted successfully`
  String get postDeleteed {
    return Intl.message(
      'Post deleted successfully',
      name: 'postDeleteed',
      desc: '',
      args: [],
    );
  }

  /// `Post updated successfully`
  String get postUpdated {
    return Intl.message(
      'Post updated successfully',
      name: 'postUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Opportunities`
  String get opportunities {
    return Intl.message(
      'Opportunities',
      name: 'opportunities',
      desc: '',
      args: [],
    );
  }

  /// `Opportunities`
  String get myOpportunities {
    return Intl.message(
      'Opportunities',
      name: 'myOpportunities',
      desc: '',
      args: [],
    );
  }

  /// `Archive Opportunities`
  String get archiveOpportunities {
    return Intl.message(
      'Archive Opportunities',
      name: 'archiveOpportunities',
      desc: '',
      args: [],
    );
  }

  /// `Public Opportunities`
  String get publicOpportunities {
    return Intl.message(
      'Public Opportunities',
      name: 'publicOpportunities',
      desc: '',
      args: [],
    );
  }

  /// `No Opportunities`
  String get noOpportunities {
    return Intl.message(
      'No Opportunities',
      name: 'noOpportunities',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get courses {
    return Intl.message('Courses', name: 'courses', desc: '', args: []);
  }

  /// `No Courses`
  String get noCourses {
    return Intl.message('No Courses', name: 'noCourses', desc: '', args: []);
  }

  /// `Achievements`
  String get achievements {
    return Intl.message(
      'Achievements',
      name: 'achievements',
      desc: '',
      args: [],
    );
  }

  /// `No Achievements`
  String get noAchievements {
    return Intl.message(
      'No Achievements',
      name: 'noAchievements',
      desc: '',
      args: [],
    );
  }

  /// `Achievement`
  String get achievement {
    return Intl.message('Achievement', name: 'achievement', desc: '', args: []);
  }

  /// `Added New Achievement`
  String get addAchievement {
    return Intl.message(
      'Added New Achievement',
      name: 'addAchievement',
      desc: '',
      args: [],
    );
  }

  /// `Achievement deleted successfully`
  String get achievementDeleted {
    return Intl.message(
      'Achievement deleted successfully',
      name: 'achievementDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Achievement updated successfully`
  String get achievementUpdated {
    return Intl.message(
      'Achievement updated successfully',
      name: 'achievementUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this achievement?`
  String get deleteachievementconfirmation {
    return Intl.message(
      'Are you sure you want to delete this achievement?',
      name: 'deleteachievementconfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Delete Achievement`
  String get deleteachievement {
    return Intl.message(
      'Delete Achievement',
      name: 'deleteachievement',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Analyzed Videos Reports`
  String get analyzedVideosReports {
    return Intl.message(
      'Analyzed Videos Reports',
      name: 'analyzedVideosReports',
      desc: '',
      args: [],
    );
  }

  /// `Interests`
  String get interests {
    return Intl.message('Interests', name: 'interests', desc: '', args: []);
  }

  /// `Show all`
  String get showAll {
    return Intl.message('Show all', name: 'showAll', desc: '', args: []);
  }

  /// `More details`
  String get moreDetails {
    return Intl.message(
      'More details',
      name: 'moreDetails',
      desc: '',
      args: [],
    );
  }

  /// `Skills`
  String get skills {
    return Intl.message('Skills', name: 'skills', desc: '', args: []);
  }

  /// `Connected successfully!`
  String get connectionSuccess {
    return Intl.message(
      'Connected successfully!',
      name: 'connectionSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect`
  String get connectionError {
    return Intl.message(
      'Failed to connect',
      name: 'connectionError',
      desc: '',
      args: [],
    );
  }

  /// `Following successfully!`
  String get followSuccess {
    return Intl.message(
      'Following successfully!',
      name: 'followSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to follow`
  String get followError {
    return Intl.message(
      'Failed to follow',
      name: 'followError',
      desc: '',
      args: [],
    );
  }

  /// `Unfollowed successfully!`
  String get unfollowSuccess {
    return Intl.message(
      'Unfollowed successfully!',
      name: 'unfollowSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Disconnected successfully!`
  String get disconnectSuccess {
    return Intl.message(
      'Disconnected successfully!',
      name: 'disconnectSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Search Result`
  String get searchResults {
    return Intl.message(
      'Search Result',
      name: 'searchResults',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResultsFound {
    return Intl.message(
      'No results found',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Try a different search`
  String get tryDifferentSearch {
    return Intl.message(
      'Try a different search',
      name: 'tryDifferentSearch',
      desc: '',
      args: [],
    );
  }

  /// `Start searching`
  String get startSearching {
    return Intl.message(
      'Start searching',
      name: 'startSearching',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully!`
  String get editProfileSuccess {
    return Intl.message(
      'Profile updated successfully!',
      name: 'editProfileSuccess',
      desc: '',
      args: [],
    );
  }

  /// `No profile data available.`
  String get noProfileData {
    return Intl.message(
      'No profile data available.',
      name: 'noProfileData',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update profile.`
  String get editProfileFailed {
    return Intl.message(
      'Failed to update profile.',
      name: 'editProfileFailed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load profile. Please try again.`
  String get profileLoadFailed {
    return Intl.message(
      'Failed to load profile. Please try again.',
      name: 'profileLoadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get bio {
    return Intl.message('Description', name: 'bio', desc: '', args: []);
  }

  /// `No bio`
  String get noBio {
    return Intl.message('No bio', name: 'noBio', desc: '', args: []);
  }

  /// `Update Post`
  String get updatePost {
    return Intl.message('Update Post', name: 'updatePost', desc: '', args: []);
  }

  /// `Updating post`
  String get updatingPost {
    return Intl.message(
      'Updating post',
      name: 'updatingPost',
      desc: '',
      args: [],
    );
  }

  /// `Updating profile`
  String get updatingProfile {
    return Intl.message(
      'Updating profile',
      name: 'updatingProfile',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update post. Please try again.`
  String get postUpdateFailed {
    return Intl.message(
      'Failed to update post. Please try again.',
      name: 'postUpdateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Delete Post`
  String get deletePost {
    return Intl.message('Delete Post', name: 'deletePost', desc: '', args: []);
  }

  /// `Are you sure you want to delete this post?`
  String get deletePostConfirmation {
    return Intl.message(
      'Are you sure you want to delete this post?',
      name: 'deletePostConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Post deleted successfully!`
  String get postDeleted {
    return Intl.message(
      'Post deleted successfully!',
      name: 'postDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Archive Post`
  String get archivePost {
    return Intl.message(
      'Archive Post',
      name: 'archivePost',
      desc: '',
      args: [],
    );
  }

  /// `Archive Posts`
  String get archivePosts {
    return Intl.message(
      'Archive Posts',
      name: 'archivePosts',
      desc: '',
      args: [],
    );
  }

  /// `Public Posts`
  String get publicPosts {
    return Intl.message(
      'Public Posts',
      name: 'publicPosts',
      desc: '',
      args: [],
    );
  }

  /// `Post archived successfully!`
  String get postArchived {
    return Intl.message(
      'Post archived successfully!',
      name: 'postArchived',
      desc: '',
      args: [],
    );
  }

  /// `this post will be archived and hidden from your profile and feed, but you can restore it later. Are you sure you want to archive this post?`
  String get archivePostConfirmation {
    return Intl.message(
      'this post will be archived and hidden from your profile and feed, but you can restore it later. Are you sure you want to archive this post?',
      name: 'archivePostConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Restore Post`
  String get restorePost {
    return Intl.message(
      'Restore Post',
      name: 'restorePost',
      desc: '',
      args: [],
    );
  }

  /// `Post restored successfully!`
  String get postRestored {
    return Intl.message(
      'Post restored successfully!',
      name: 'postRestored',
      desc: '',
      args: [],
    );
  }

  /// `this post will be restored and visible in your profile and feed. Are you sure you want to restore this post?`
  String get restorePostConfirmation {
    return Intl.message(
      'this post will be restored and visible in your profile and feed. Are you sure you want to restore this post?',
      name: 'restorePostConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete post. Please try again.`
  String get postDeleteFailed {
    return Intl.message(
      'Failed to delete post. Please try again.',
      name: 'postDeleteFailed',
      desc: '',
      args: [],
    );
  }

  /// `Comment added successfully`
  String get commentAddedSuccessfully {
    return Intl.message(
      'Comment added successfully',
      name: 'commentAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Comment updated successfully`
  String get commentUpdatedSuccessfully {
    return Intl.message(
      'Comment updated successfully',
      name: 'commentUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Comment deleted successfully`
  String get commentDeletedSuccessfully {
    return Intl.message(
      'Comment deleted successfully',
      name: 'commentDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message('Comments', name: 'comments', desc: '', args: []);
  }

  /// `No comments yet`
  String get noCommentsYet {
    return Intl.message(
      'No comments yet',
      name: 'noCommentsYet',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Delete Comment`
  String get deleteComment {
    return Intl.message(
      'Delete Comment',
      name: 'deleteComment',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this comment?`
  String get deleteCommentConfirmation {
    return Intl.message(
      'Are you sure you want to delete this comment?',
      name: 'deleteCommentConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Editing comment`
  String get editingComment {
    return Intl.message(
      'Editing comment',
      name: 'editingComment',
      desc: '',
      args: [],
    );
  }

  /// `Edit your comment...`
  String get editYourComment {
    return Intl.message(
      'Edit your comment...',
      name: 'editYourComment',
      desc: '',
      args: [],
    );
  }

  /// `Add a comment...`
  String get addAComment {
    return Intl.message(
      'Add a comment...',
      name: 'addAComment',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Post`
  String get post {
    return Intl.message('Post', name: 'post', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Loading user data...`
  String get loadingUserData {
    return Intl.message(
      'Loading user data...',
      name: 'loadingUserData',
      desc: '',
      args: [],
    );
  }

  /// `No user data found`
  String get noUserDataFound {
    return Intl.message(
      'No user data found',
      name: 'noUserDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Hi`
  String get hi {
    return Intl.message('Hi', name: 'hi', desc: '', args: []);
  }

  /// `Guest`
  String get guest {
    return Intl.message('Guest', name: 'guest', desc: '', args: []);
  }

  /// `Happy to see you today`
  String get happyToSeeYouToday {
    return Intl.message(
      'Happy to see you today',
      name: 'happyToSeeYouToday',
      desc: '',
      args: [],
    );
  }

  /// `Latest posts`
  String get latestPosts {
    return Intl.message(
      'Latest posts',
      name: 'latestPosts',
      desc: '',
      args: [],
    );
  }

  /// `Latest Courses`
  String get latestCourses {
    return Intl.message(
      'Latest Courses',
      name: 'latestCourses',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Something went wrong`
  String get oopsSomethingWentWrong {
    return Intl.message(
      'Oops! Something went wrong',
      name: 'oopsSomethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `No posts yet`
  String get noPostsYet {
    return Intl.message('No posts yet', name: 'noPostsYet', desc: '', args: []);
  }

  /// `No archived posts`
  String get noArchivedPosts {
    return Intl.message(
      'No archived posts',
      name: 'noArchivedPosts',
      desc: '',
      args: [],
    );
  }

  /// `No posts available`
  String get noPostsAvailable {
    return Intl.message(
      'No posts available',
      name: 'noPostsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get likes {
    return Intl.message('Likes', name: 'likes', desc: '', args: []);
  }

  /// `No likes yet`
  String get noLikesYet {
    return Intl.message('No likes yet', name: 'noLikesYet', desc: '', args: []);
  }

  /// `Be the first to create a post!`
  String get beTheFirstToCreatePost {
    return Intl.message(
      'Be the first to create a post!',
      name: 'beTheFirstToCreatePost',
      desc: '',
      args: [],
    );
  }

  /// `Pick Image`
  String get pickImage {
    return Intl.message('Pick Image', name: 'pickImage', desc: '', args: []);
  }

  /// `Pick Video`
  String get pickVideo {
    return Intl.message('Pick Video', name: 'pickVideo', desc: '', args: []);
  }

  /// `Post uploaded successfully!`
  String get postUploadedSuccessfully {
    return Intl.message(
      'Post uploaded successfully!',
      name: 'postUploadedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Upload Content`
  String get uploadContent {
    return Intl.message(
      'Upload Content',
      name: 'uploadContent',
      desc: '',
      args: [],
    );
  }

  /// `Upload an Image or video`
  String get uploadImageOrVideo {
    return Intl.message(
      'Upload an Image or video',
      name: 'uploadImageOrVideo',
      desc: '',
      args: [],
    );
  }

  /// `Maximum file size is 200 MB`
  String get maximumFileSize {
    return Intl.message(
      'Maximum file size is 200 MB',
      name: 'maximumFileSize',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Enter Your Title.`
  String get enterYourTitle {
    return Intl.message(
      'Enter Your Title.',
      name: 'enterYourTitle',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Enter Your Description...`
  String get enterYourDescription {
    return Intl.message(
      'Enter Your Description...',
      name: 'enterYourDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields`
  String get pleaseFillAllFields {
    return Intl.message(
      'Please fill all fields',
      name: 'pleaseFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Create Post`
  String get createPost {
    return Intl.message('Create Post', name: 'createPost', desc: '', args: []);
  }

  /// `Create Achievement`
  String get createAchievement {
    return Intl.message(
      'Create Achievement',
      name: 'createAchievement',
      desc: '',
      args: [],
    );
  }

  /// `Create opportunity`
  String get createOpportunity {
    return Intl.message(
      'Create opportunity',
      name: 'createOpportunity',
      desc: '',
      args: [],
    );
  }

  /// `Create Advertisement`
  String get createAdvertisement {
    return Intl.message(
      'Create Advertisement',
      name: 'createAdvertisement',
      desc: '',
      args: [],
    );
  }

  /// `Make Video Analysis`
  String get makeVideoAnalysis {
    return Intl.message(
      'Make Video Analysis',
      name: 'makeVideoAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load image`
  String get failedToLoadImage {
    return Intl.message(
      'Failed to load image',
      name: 'failedToLoadImage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to translate`
  String get failedToTranslate {
    return Intl.message(
      'Failed to translate',
      name: 'failedToTranslate',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load video`
  String get failedToLoadVideo {
    return Intl.message(
      'Failed to load video',
      name: 'failedToLoadVideo',
      desc: '',
      args: [],
    );
  }

  /// `Analyze video feature coming soon`
  String get analyzeVideoComingSoon {
    return Intl.message(
      'Analyze video feature coming soon',
      name: 'analyzeVideoComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Analyze Video`
  String get analyzeVideo {
    return Intl.message(
      'Analyze Video',
      name: 'analyzeVideo',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get archive {
    return Intl.message('Archive', name: 'archive', desc: '', args: []);
  }

  /// `Restore`
  String get restore {
    return Intl.message('Restore', name: 'restore', desc: '', args: []);
  }

  /// `See Original`
  String get seeOriginal {
    return Intl.message(
      'See Original',
      name: 'seeOriginal',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get translate {
    return Intl.message('Translate', name: 'translate', desc: '', args: []);
  }

  /// `forYou`
  String get forYou {
    return Intl.message('forYou', name: 'forYou', desc: '', args: []);
  }

  /// `Just now`
  String get justNow {
    return Intl.message('Just now', name: 'justNow', desc: '', args: []);
  }

  /// `Select Sport`
  String get selectSport {
    return Intl.message(
      'Select Sport',
      name: 'selectSport',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Opportunity created successfully!`
  String get opportunityCreatedSuccessfully {
    return Intl.message(
      'Opportunity created successfully!',
      name: 'opportunityCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Application submitted successfully!`
  String get applicationSubmittedSuccessfully {
    return Intl.message(
      'Application submitted successfully!',
      name: 'applicationSubmittedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No Opportunities found`
  String get noOpportunitiesFound {
    return Intl.message(
      'No Opportunities found',
      name: 'noOpportunitiesFound',
      desc: '',
      args: [],
    );
  }

  /// `Clear filters`
  String get clearFilters {
    return Intl.message(
      'Clear filters',
      name: 'clearFilters',
      desc: '',
      args: [],
    );
  }

  /// `Since`
  String get since {
    return Intl.message('Since', name: 'since', desc: '', args: []);
  }

  /// `Apply opportunity`
  String get applyOpportunity {
    return Intl.message(
      'Apply opportunity',
      name: 'applyOpportunity',
      desc: '',
      args: [],
    );
  }

  /// `Delete Opportunity`
  String get deleteOpportunity {
    return Intl.message(
      'Delete Opportunity',
      name: 'deleteOpportunity',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this opportunity? This action cannot be undone.`
  String get deleteOpportunityConfirmation {
    return Intl.message(
      'Are you sure you want to delete this opportunity? This action cannot be undone.',
      name: 'deleteOpportunityConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Deleting opportunity...`
  String get deletingOpportunity {
    return Intl.message(
      'Deleting opportunity...',
      name: 'deletingOpportunity',
      desc: '',
      args: [],
    );
  }

  /// `Requirements`
  String get requirements {
    return Intl.message(
      'Requirements',
      name: 'requirements',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get endDate {
    return Intl.message('End Date', name: 'endDate', desc: '', args: []);
  }

  /// `Show Applicants`
  String get showApplicants {
    return Intl.message(
      'Show Applicants',
      name: 'showApplicants',
      desc: '',
      args: [],
    );
  }

  /// `Already Applied`
  String get alreadyApplied {
    return Intl.message(
      'Already Applied',
      name: 'alreadyApplied',
      desc: '',
      args: [],
    );
  }

  /// `Apply Now`
  String get applyNow {
    return Intl.message('Apply Now', name: 'applyNow', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Applicants`
  String get applicants {
    return Intl.message('Applicants', name: 'applicants', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Rejected`
  String get rejected {
    return Intl.message('Rejected', name: 'rejected', desc: '', args: []);
  }

  /// `No accepted applicants`
  String get noAcceptedApplicants {
    return Intl.message(
      'No accepted applicants',
      name: 'noAcceptedApplicants',
      desc: '',
      args: [],
    );
  }

  /// `No rejected applicants`
  String get noRejectedApplicants {
    return Intl.message(
      'No rejected applicants',
      name: 'noRejectedApplicants',
      desc: '',
      args: [],
    );
  }

  /// `No applicants found`
  String get noApplicantsFound {
    return Intl.message(
      'No applicants found',
      name: 'noApplicantsFound',
      desc: '',
      args: [],
    );
  }

  /// `Error loading applicants`
  String get errorLoadingApplicants {
    return Intl.message(
      'Error loading applicants',
      name: 'errorLoadingApplicants',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Upload an Image`
  String get uploadAnImage {
    return Intl.message(
      'Upload an Image',
      name: 'uploadAnImage',
      desc: '',
      args: [],
    );
  }

  /// `Tap to select from gallery`
  String get tapToSelectFromGallery {
    return Intl.message(
      'Tap to select from gallery',
      name: 'tapToSelectFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Tap to Change`
  String get tapToChange {
    return Intl.message(
      'Tap to Change',
      name: 'tapToChange',
      desc: '',
      args: [],
    );
  }

  /// `Enter Requirements (one per line)...`
  String get enterYourRequirements {
    return Intl.message(
      'Enter Requirements (one per line)...',
      name: 'enterYourRequirements',
      desc: '',
      args: [],
    );
  }

  /// `Select End Date`
  String get selectEndDate {
    return Intl.message(
      'Select End Date',
      name: 'selectEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message('Upload', name: 'upload', desc: '', args: []);
  }

  /// `Please enter a title`
  String get pleaseEnterTitle {
    return Intl.message(
      'Please enter a title',
      name: 'pleaseEnterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a description`
  String get pleaseEnterDescription {
    return Intl.message(
      'Please enter a description',
      name: 'pleaseEnterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please enter requirements`
  String get pleaseEnterRequirements {
    return Intl.message(
      'Please enter requirements',
      name: 'pleaseEnterRequirements',
      desc: '',
      args: [],
    );
  }

  /// `Please select a sport`
  String get pleaseSelectSport {
    return Intl.message(
      'Please select a sport',
      name: 'pleaseSelectSport',
      desc: '',
      args: [],
    );
  }

  /// `Please select an end date`
  String get pleaseSelectEndDate {
    return Intl.message(
      'Please select an end date',
      name: 'pleaseSelectEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `No opportunities available`
  String get noOpportunitiesAvailable {
    return Intl.message(
      'No opportunities available',
      name: 'noOpportunitiesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Taekwondo`
  String get taekwondo {
    return Intl.message('Taekwondo', name: 'taekwondo', desc: '', args: []);
  }

  /// `{count, plural, =1 {{count} year ago} other {{count} years ago}}`
  String yearsAgo(int count) {
    return Intl.plural(
      count,
      one: '$count year ago',
      other: '$count years ago',
      name: 'yearsAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1 {{count} month ago} other {{count} months ago}}`
  String monthsAgo(int count) {
    return Intl.plural(
      count,
      one: '$count month ago',
      other: '$count months ago',
      name: 'monthsAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1 {{count} week ago} other {{count} weeks ago}}`
  String weeksAgo(int count) {
    return Intl.plural(
      count,
      one: '$count week ago',
      other: '$count weeks ago',
      name: 'weeksAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1 {{count} day ago} other {{count} days ago}}`
  String daysAgo(int count) {
    return Intl.plural(
      count,
      one: '$count day ago',
      other: '$count days ago',
      name: 'daysAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1 {{count} hour ago} other {{count} hours ago}}`
  String hoursAgo(int count) {
    return Intl.plural(
      count,
      one: '$count hour ago',
      other: '$count hours ago',
      name: 'hoursAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1 {{count} minute ago} other {{count} minutes ago}}`
  String minutesAgo(int count) {
    return Intl.plural(
      count,
      one: '$count minute ago',
      other: '$count minutes ago',
      name: 'minutesAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1 {{count} second ago} other {{count} seconds ago}}`
  String secondsAgo(int count) {
    return Intl.plural(
      count,
      one: '$count second ago',
      other: '$count seconds ago',
      name: 'secondsAgo',
      desc: '',
      args: [count],
    );
  }

  /// `Failed to load post. Please try again.`
  String get postLoadFailed {
    return Intl.message(
      'Failed to load post. Please try again.',
      name: 'postLoadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Edit Achievement`
  String get edit_achievement {
    return Intl.message(
      'Edit Achievement',
      name: 'edit_achievement',
      desc: '',
      args: [],
    );
  }

  /// `Add Achievement`
  String get add_achievement_title {
    return Intl.message(
      'Add Achievement',
      name: 'add_achievement_title',
      desc: '',
      args: [],
    );
  }

  /// `Upload Achievement Photo`
  String get upload_photo_hint {
    return Intl.message(
      'Upload Achievement Photo',
      name: 'upload_photo_hint',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date_label {
    return Intl.message('Date', name: 'date_label', desc: '', args: []);
  }

  /// `Select Date`
  String get select_date_hint {
    return Intl.message(
      'Select Date',
      name: 'select_date_hint',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title_label {
    return Intl.message('Title', name: 'title_label', desc: '', args: []);
  }

  /// `e.g. National Championship`
  String get title_hint {
    return Intl.message(
      'e.g. National Championship',
      name: 'title_hint',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description_label {
    return Intl.message(
      'Description',
      name: 'description_label',
      desc: '',
      args: [],
    );
  }

  /// `Explain your achievement...`
  String get description_hint {
    return Intl.message(
      'Explain your achievement...',
      name: 'description_hint',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update_button {
    return Intl.message('Update', name: 'update_button', desc: '', args: []);
  }

  /// `Save Achievement`
  String get save_achievement_button {
    return Intl.message(
      'Save Achievement',
      name: 'save_achievement_button',
      desc: '',
      args: [],
    );
  }

  /// `Please select a date`
  String get please_select_date {
    return Intl.message(
      'Please select a date',
      name: 'please_select_date',
      desc: '',
      args: [],
    );
  }

  /// `Achievement added successfully`
  String get achievement_added_success {
    return Intl.message(
      'Achievement added successfully',
      name: 'achievement_added_success',
      desc: '',
      args: [],
    );
  }

  /// `Achievement updated successfully`
  String get achievement_updated_success {
    return Intl.message(
      'Achievement updated successfully',
      name: 'achievement_updated_success',
      desc: '',
      args: [],
    );
  }

  /// `Message sent successfully`
  String get messageSent {
    return Intl.message(
      'Message sent successfully',
      name: 'messageSent',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send message. Please try again.`
  String get failedToSendMessage {
    return Intl.message(
      'Failed to send message. Please try again.',
      name: 'failedToSendMessage',
      desc: '',
      args: [],
    );
  }

  /// `FREE`
  String get free {
    return Intl.message('FREE', name: 'free', desc: '', args: []);
  }

  /// `EGP`
  String get egp {
    return Intl.message('EGP', name: 'egp', desc: '', args: []);
  }

  /// `Enroll`
  String get enroll {
    return Intl.message('Enroll', name: 'enroll', desc: '', args: []);
  }

  /// `{count} lessons`
  String lessonsCount(int count) {
    return Intl.message(
      '$count lessons',
      name: 'lessonsCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count} enrolled`
  String enrolledCount(int count) {
    return Intl.message(
      '$count enrolled',
      name: 'enrolledCount',
      desc: '',
      args: [count],
    );
  }

  /// `{percentage}% complete`
  String completePercentage(String percentage) {
    return Intl.message(
      '$percentage% complete',
      name: 'completePercentage',
      desc: '',
      args: [percentage],
    );
  }

  /// `Edit Price`
  String get editPrice {
    return Intl.message('Edit Price', name: 'editPrice', desc: '', args: []);
  }

  /// `Free Course`
  String get freeCourse {
    return Intl.message('Free Course', name: 'freeCourse', desc: '', args: []);
  }

  /// `Price (EGP)`
  String get priceEGP {
    return Intl.message('Price (EGP)', name: 'priceEGP', desc: '', args: []);
  }

  /// `Price is required`
  String get priceRequired {
    return Intl.message(
      'Price is required',
      name: 'priceRequired',
      desc: '',
      args: [],
    );
  }

  /// `Invalid price`
  String get invalidPrice {
    return Intl.message(
      'Invalid price',
      name: 'invalidPrice',
      desc: '',
      args: [],
    );
  }

  /// `{number} Lesson`
  String lessonNumber(int number) {
    return Intl.message(
      '$number Lesson',
      name: 'lessonNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Playing`
  String get playing {
    return Intl.message('Playing', name: 'playing', desc: '', args: []);
  }

  /// `Show Description`
  String get showDescription {
    return Intl.message(
      'Show Description',
      name: 'showDescription',
      desc: '',
      args: [],
    );
  }

  /// `Hide Description`
  String get hideDescription {
    return Intl.message(
      'Hide Description',
      name: 'hideDescription',
      desc: '',
      args: [],
    );
  }

  /// `Watched`
  String get watched {
    return Intl.message('Watched', name: 'watched', desc: '', args: []);
  }

  /// `{percentage}% watched`
  String percentageWatched(String percentage) {
    return Intl.message(
      '$percentage% watched',
      name: 'percentageWatched',
      desc: '',
      args: [percentage],
    );
  }

  /// `Create Course`
  String get createCourse {
    return Intl.message(
      'Create Course',
      name: 'createCourse',
      desc: '',
      args: [],
    );
  }

  /// `Upload Course Thumbnail`
  String get uploadCourseThumbnail {
    return Intl.message(
      'Upload Course Thumbnail',
      name: 'uploadCourseThumbnail',
      desc: '',
      args: [],
    );
  }

  /// `Course Thumbnail`
  String get courseThumbnail {
    return Intl.message(
      'Course Thumbnail',
      name: 'courseThumbnail',
      desc: '',
      args: [],
    );
  }

  /// `Course Title`
  String get courseTitleHint {
    return Intl.message(
      'Course Title',
      name: 'courseTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Course Title`
  String get enterCourseTitleHint {
    return Intl.message(
      'Course Title',
      name: 'enterCourseTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Course Description`
  String get courseDescriptionHint {
    return Intl.message(
      'Course Description',
      name: 'courseDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter Course Description`
  String get enterCourseDescriptionHint {
    return Intl.message(
      'Enter Course Description',
      name: 'enterCourseDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `No description available`
  String get noDescriptionAvailable {
    return Intl.message(
      'No description available',
      name: 'noDescriptionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Enter price (0 for free)`
  String get enterPriceHint {
    return Intl.message(
      'Enter price (0 for free)',
      name: 'enterPriceHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a price`
  String get pleaseEnterPrice {
    return Intl.message(
      'Please enter a price',
      name: 'pleaseEnterPrice',
      desc: '',
      args: [],
    );
  }

  /// `Course created successfully`
  String get courseCreatedSuccess {
    return Intl.message(
      'Course created successfully',
      name: 'courseCreatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Add Lesson`
  String get addLesson {
    return Intl.message('Add Lesson', name: 'addLesson', desc: '', args: []);
  }

  /// `Would you like to add a lesson to this course now?`
  String get addLessonQuestion {
    return Intl.message(
      'Would you like to add a lesson to this course now?',
      name: 'addLessonQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Add Later`
  String get addLater {
    return Intl.message('Add Later', name: 'addLater', desc: '', args: []);
  }

  /// `Add Now`
  String get addNow {
    return Intl.message('Add Now', name: 'addNow', desc: '', args: []);
  }

  /// `Error picking image. Please try again.`
  String get error_picking_image {
    return Intl.message(
      'Error picking image. Please try again.',
      name: 'error_picking_image',
      desc: '',
      args: [],
    );
  }

  /// `Please select a sport`
  String get select_sport_error {
    return Intl.message(
      'Please select a sport',
      name: 'select_sport_error',
      desc: '',
      args: [],
    );
  }

  /// `Edit Lesson`
  String get editLesson {
    return Intl.message('Edit Lesson', name: 'editLesson', desc: '', args: []);
  }

  /// `Lesson Title`
  String get lessonTitle {
    return Intl.message(
      'Lesson Title',
      name: 'lessonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter lesson title`
  String get enterLessonTitleHint {
    return Intl.message(
      'Enter lesson title',
      name: 'enterLessonTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter description`
  String get enterDescriptionHint {
    return Intl.message(
      'Enter description',
      name: 'enterDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Title is required`
  String get titleRequired {
    return Intl.message(
      'Title is required',
      name: 'titleRequired',
      desc: '',
      args: [],
    );
  }

  /// `Description is required`
  String get descriptionRequired {
    return Intl.message(
      'Description is required',
      name: 'descriptionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Lesson order: {order}`
  String lessonOrder(String order) {
    return Intl.message(
      'Lesson order: $order',
      name: 'lessonOrder',
      desc: '',
      args: [order],
    );
  }

  /// `Duration: {duration}`
  String duration(String duration) {
    return Intl.message(
      'Duration: $duration',
      name: 'duration',
      desc: '',
      args: [duration],
    );
  }

  /// `Update Lesson`
  String get updateLesson {
    return Intl.message(
      'Update Lesson',
      name: 'updateLesson',
      desc: '',
      args: [],
    );
  }

  /// `New video will be uploaded`
  String get newVideoWillBeUploaded {
    return Intl.message(
      'New video will be uploaded',
      name: 'newVideoWillBeUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message('Video', name: 'video', desc: '', args: []);
  }

  /// `Change Video`
  String get changeVideo {
    return Intl.message(
      'Change Video',
      name: 'changeVideo',
      desc: '',
      args: [],
    );
  }

  /// `Replace Video`
  String get replaceVideo {
    return Intl.message(
      'Replace Video',
      name: 'replaceVideo',
      desc: '',
      args: [],
    );
  }

  /// `Extracting duration...`
  String get extractingDuration {
    return Intl.message(
      'Extracting duration...',
      name: 'extractingDuration',
      desc: '',
      args: [],
    );
  }

  /// `New video selected`
  String get newVideoSelected {
    return Intl.message(
      'New video selected',
      name: 'newVideoSelected',
      desc: '',
      args: [],
    );
  }

  /// `Current video`
  String get currentVideo {
    return Intl.message(
      'Current video',
      name: 'currentVideo',
      desc: '',
      args: [],
    );
  }

  /// `Updating lesson...`
  String get updatingLesson {
    return Intl.message(
      'Updating lesson...',
      name: 'updatingLesson',
      desc: '',
      args: [],
    );
  }

  /// `File size exceeds 500MB`
  String get file_size_exceeds_limit {
    return Intl.message(
      'File size exceeds 500MB',
      name: 'file_size_exceeds_limit',
      desc: '',
      args: [],
    );
  }

  /// `Error picking video. Please try again.`
  String get error_picking_video {
    return Intl.message(
      'Error picking video. Please try again.',
      name: 'error_picking_video',
      desc: '',
      args: [],
    );
  }

  /// `Failed to read video duration`
  String get failed_to_read_video_duration {
    return Intl.message(
      'Failed to read video duration',
      name: 'failed_to_read_video_duration',
      desc: '',
      args: [],
    );
  }

  /// `Upload Lesson`
  String get uploadLesson {
    return Intl.message(
      'Upload Lesson',
      name: 'uploadLesson',
      desc: '',
      args: [],
    );
  }

  /// `Upload Video`
  String get uploadVideo {
    return Intl.message(
      'Upload Video',
      name: 'uploadVideo',
      desc: '',
      args: [],
    );
  }

  /// `Max 500MB`
  String get maxFileSize {
    return Intl.message('Max 500MB', name: 'maxFileSize', desc: '', args: []);
  }

  /// `Not detected`
  String get notDetected {
    return Intl.message(
      'Not detected',
      name: 'notDetected',
      desc: '',
      args: [],
    );
  }

  /// `Lesson order: {order} • Duration: {duration}`
  String lessonOrderAndDuration(String order, String duration) {
    return Intl.message(
      'Lesson order: $order • Duration: $duration',
      name: 'lessonOrderAndDuration',
      desc: '',
      args: [order, duration],
    );
  }

  /// `Lessons`
  String get lessons {
    return Intl.message('Lessons', name: 'lessons', desc: '', args: []);
  }

  /// `Revenue`
  String get revenue {
    return Intl.message('Revenue', name: 'revenue', desc: '', args: []);
  }

  /// `Edit Course`
  String get editCourse {
    return Intl.message('Edit Course', name: 'editCourse', desc: '', args: []);
  }

  /// `Cancel Edit`
  String get cancelEdit {
    return Intl.message('Cancel Edit', name: 'cancelEdit', desc: '', args: []);
  }

  /// `Delete Course`
  String get deleteCourse {
    return Intl.message(
      'Delete Course',
      name: 'deleteCourse',
      desc: '',
      args: [],
    );
  }

  /// `Delete Lesson`
  String get deleteLesson {
    return Intl.message(
      'Delete Lesson',
      name: 'deleteLesson',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete "{lessonTitle}"? This action cannot be undone.`
  String deleteLessonConfirmation(String lessonTitle) {
    return Intl.message(
      'Are you sure you want to delete "$lessonTitle"? This action cannot be undone.',
      name: 'deleteLessonConfirmation',
      desc: '',
      args: [lessonTitle],
    );
  }

  /// `Are you sure you want to delete this course?`
  String get deleteCourseConfirmation {
    return Intl.message(
      'Are you sure you want to delete this course?',
      name: 'deleteCourseConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Title cannot be empty`
  String get titleCannotBeEmpty {
    return Intl.message(
      'Title cannot be empty',
      name: 'titleCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Saving changes...`
  String get savingChanges {
    return Intl.message(
      'Saving changes...',
      name: 'savingChanges',
      desc: '',
      args: [],
    );
  }

  /// `Deleting lesson...`
  String get deletingLesson {
    return Intl.message(
      'Deleting lesson...',
      name: 'deletingLesson',
      desc: '',
      args: [],
    );
  }

  /// `Enrolled successfully`
  String get enrolledSuccessfully {
    return Intl.message(
      'Enrolled successfully',
      name: 'enrolledSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Course deleted`
  String get courseDeleted {
    return Intl.message(
      'Course deleted',
      name: 'courseDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Enroll Now`
  String get enrollNow {
    return Intl.message('Enroll Now', name: 'enrollNow', desc: '', args: []);
  }

  /// `Enroll for {price}`
  String enrollForPrice(String price) {
    return Intl.message(
      'Enroll for $price',
      name: 'enrollForPrice',
      desc: '',
      args: [price],
    );
  }

  /// `Available`
  String get available {
    return Intl.message('Available', name: 'available', desc: '', args: []);
  }

  /// `New Courses`
  String get newCourses {
    return Intl.message('New Courses', name: 'newCourses', desc: '', args: []);
  }

  /// `Continue Watching`
  String get continueWatching {
    return Intl.message(
      'Continue Watching',
      name: 'continueWatching',
      desc: '',
      args: [],
    );
  }

  /// `Show More`
  String get showMore {
    return Intl.message('Show More', name: 'showMore', desc: '', args: []);
  }

  /// `No courses found for "{searchTerm}"`
  String noCoursesFoundFor(String searchTerm) {
    return Intl.message(
      'No courses found for "$searchTerm"',
      name: 'noCoursesFoundFor',
      desc: '',
      args: [searchTerm],
    );
  }

  /// `{percentage}% Complete`
  String percentComplete(String percentage) {
    return Intl.message(
      '$percentage% Complete',
      name: 'percentComplete',
      desc: '',
      args: [percentage],
    );
  }

  /// `{completed} / {total} Lessons`
  String lessonsProgress(String completed, String total) {
    return Intl.message(
      '$completed / $total Lessons',
      name: 'lessonsProgress',
      desc: '',
      args: [completed, total],
    );
  }

  /// `Failed to play video`
  String get failedToPlayVideo {
    return Intl.message(
      'Failed to play video',
      name: 'failedToPlayVideo',
      desc: '',
      args: [],
    );
  }

  /// `Video Playback Error`
  String get videoPlaybackError {
    return Intl.message(
      'Video Playback Error',
      name: 'videoPlaybackError',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknownError {
    return Intl.message(
      'Unknown error',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Available Courses`
  String get availableCourses {
    return Intl.message(
      'Available Courses',
      name: 'availableCourses',
      desc: '',
      args: [],
    );
  }

  /// `No Available Courses`
  String get noAvailableCourses {
    return Intl.message(
      'No Available Courses',
      name: 'noAvailableCourses',
      desc: '',
      args: [],
    );
  }

  /// `Enrolled Courses`
  String get enrolledCourses {
    return Intl.message(
      'Enrolled Courses',
      name: 'enrolledCourses',
      desc: '',
      args: [],
    );
  }

  /// `My Courses`
  String get myCourses {
    return Intl.message('My Courses', name: 'myCourses', desc: '', args: []);
  }

  /// `No courses found`
  String get noCoursesFound {
    return Intl.message(
      'No courses found',
      name: 'noCoursesFound',
      desc: '',
      args: [],
    );
  }

  /// `No results for your criteria`
  String get noResultsForCriteria {
    return Intl.message(
      'No results for your criteria',
      name: 'noResultsForCriteria',
      desc: '',
      args: [],
    );
  }

  /// `Try adjusting your search or filter`
  String get tryAdjustingSearch {
    return Intl.message(
      'Try adjusting your search or filter',
      name: 'tryAdjustingSearch',
      desc: '',
      args: [],
    );
  }

  /// `Please select a video`
  String get pleaseSelectVideo {
    return Intl.message(
      'Please select a video',
      name: 'pleaseSelectVideo',
      desc: '',
      args: [],
    );
  }

  /// `Invalid video duration. Please select another video.`
  String get invalidVideoDuration {
    return Intl.message(
      'Invalid video duration. Please select another video.',
      name: 'invalidVideoDuration',
      desc: '',
      args: [],
    );
  }

  /// `Uploading lesson in background...`
  String get uploadingInBackground {
    return Intl.message(
      'Uploading lesson in background...',
      name: 'uploadingInBackground',
      desc: '',
      args: [],
    );
  }

  /// `Upload will continue in background`
  String get uploadWillContinue {
    return Intl.message(
      'Upload will continue in background',
      name: 'uploadWillContinue',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInfo {
    return Intl.message(
      'Personal Information',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get subscription {
    return Intl.message(
      'Subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Activities`
  String get activities {
    return Intl.message('Activities', name: 'activities', desc: '', args: []);
  }

  /// `User Type`
  String get userType {
    return Intl.message('User Type', name: 'userType', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Manage Subscription`
  String get manageSubscription {
    return Intl.message(
      'Manage Subscription',
      name: 'manageSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Manage Posts`
  String get managePosts {
    return Intl.message(
      'Manage Posts',
      name: 'managePosts',
      desc: '',
      args: [],
    );
  }

  /// `Manage Opportunities`
  String get manageOpportunities {
    return Intl.message(
      'Manage Opportunities',
      name: 'manageOpportunities',
      desc: '',
      args: [],
    );
  }

  /// `Manage Course`
  String get manageCourse {
    return Intl.message(
      'Manage Course',
      name: 'manageCourse',
      desc: '',
      args: [],
    );
  }

  /// `Manage Video Analysis People`
  String get manageVideoAnalysis {
    return Intl.message(
      'Manage Video Analysis People',
      name: 'manageVideoAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Manage Advertisement`
  String get manageAdvertisement {
    return Intl.message(
      'Manage Advertisement',
      name: 'manageAdvertisement',
      desc: '',
      args: [],
    );
  }

  /// `Manage Achievement`
  String get manageAchievement {
    return Intl.message(
      'Manage Achievement',
      name: 'manageAchievement',
      desc: '',
      args: [],
    );
  }

  /// `Switch Account`
  String get switchAccount {
    return Intl.message(
      'Switch Account',
      name: 'switchAccount',
      desc: '',
      args: [],
    );
  }

  /// `Add Account`
  String get addAccount {
    return Intl.message('Add Account', name: 'addAccount', desc: '', args: []);
  }

  /// `Lesson order saved`
  String get lessonOrderSaved {
    return Intl.message(
      'Lesson order saved',
      name: 'lessonOrderSaved',
      desc: '',
      args: [],
    );
  }

  /// `No lessons available`
  String get noLessonsAvailable {
    return Intl.message(
      'No lessons available',
      name: 'noLessonsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Tap the + button to add your first lesson`
  String get tapToAddFirstLesson {
    return Intl.message(
      'Tap the + button to add your first lesson',
      name: 'tapToAddFirstLesson',
      desc: '',
      args: [],
    );
  }

  /// `Course Progress`
  String get courseProgress {
    return Intl.message(
      'Course Progress',
      name: 'courseProgress',
      desc: '',
      args: [],
    );
  }

  /// `Time Spent`
  String get timeSpent {
    return Intl.message('Time Spent', name: 'timeSpent', desc: '', args: []);
  }

  /// `No enrollees yet`
  String get noEnrolleesYet {
    return Intl.message(
      'No enrollees yet',
      name: 'noEnrolleesYet',
      desc: '',
      args: [],
    );
  }

  /// `Enrolled students will appear here`
  String get enrolleesWillAppear {
    return Intl.message(
      'Enrolled students will appear here',
      name: 'enrolleesWillAppear',
      desc: '',
      args: [],
    );
  }

  /// `Total Enrolled`
  String get totalEnrolled {
    return Intl.message(
      'Total Enrolled',
      name: 'totalEnrolled',
      desc: '',
      args: [],
    );
  }

  /// `Avg Progress`
  String get avgProgress {
    return Intl.message(
      'Avg Progress',
      name: 'avgProgress',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get progress {
    return Intl.message('Progress', name: 'progress', desc: '', args: []);
  }

  /// `Enrolled`
  String get enrolled {
    return Intl.message('Enrolled', name: 'enrolled', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `New Connection Requests`
  String get newConnectionRequests {
    return Intl.message(
      'New Connection Requests',
      name: 'newConnectionRequests',
      desc: '',
      args: [],
    );
  }

  /// `No Connection Requests`
  String get noConnectionRequests {
    return Intl.message(
      'No Connection Requests',
      name: 'noConnectionRequests',
      desc: '',
      args: [],
    );
  }

  /// `No More Requests`
  String get noMoreRequests {
    return Intl.message(
      'No More Requests',
      name: 'noMoreRequests',
      desc: '',
      args: [],
    );
  }

  /// `My Contacts`
  String get myContacts {
    return Intl.message('My Contacts', name: 'myContacts', desc: '', args: []);
  }

  /// `No contacts yet`
  String get noContactsYet {
    return Intl.message(
      'No contacts yet',
      name: 'noContactsYet',
      desc: '',
      args: [],
    );
  }

  /// `Wants to connect with you`
  String get wantsToConnect {
    return Intl.message(
      'Wants to connect with you',
      name: 'wantsToConnect',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Year`
  String get year {
    return Intl.message('Year', name: 'year', desc: '', args: []);
  }

  /// `All-Time Revenue`
  String get allTimeRevenue {
    return Intl.message(
      'All-Time Revenue',
      name: 'allTimeRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Breakdown`
  String get weeklyBreakdown {
    return Intl.message(
      'Weekly Breakdown',
      name: 'weeklyBreakdown',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Details`
  String get weeklyDetails {
    return Intl.message(
      'Weekly Details',
      name: 'weeklyDetails',
      desc: '',
      args: [],
    );
  }

  /// `No data available for {month}`
  String noDataForMonth(String month) {
    return Intl.message(
      'No data available for $month',
      name: 'noDataForMonth',
      desc: '',
      args: [month],
    );
  }

  /// `January`
  String get january {
    return Intl.message('January', name: 'january', desc: '', args: []);
  }

  /// `February`
  String get february {
    return Intl.message('February', name: 'february', desc: '', args: []);
  }

  /// `March`
  String get march {
    return Intl.message('March', name: 'march', desc: '', args: []);
  }

  /// `April`
  String get april {
    return Intl.message('April', name: 'april', desc: '', args: []);
  }

  /// `May`
  String get may {
    return Intl.message('May', name: 'may', desc: '', args: []);
  }

  /// `June`
  String get june {
    return Intl.message('June', name: 'june', desc: '', args: []);
  }

  /// `July`
  String get july {
    return Intl.message('July', name: 'july', desc: '', args: []);
  }

  /// `August`
  String get august {
    return Intl.message('August', name: 'august', desc: '', args: []);
  }

  /// `September`
  String get september {
    return Intl.message('September', name: 'september', desc: '', args: []);
  }

  /// `October`
  String get october {
    return Intl.message('October', name: 'october', desc: '', args: []);
  }

  /// `November`
  String get november {
    return Intl.message('November', name: 'november', desc: '', args: []);
  }

  /// `December`
  String get december {
    return Intl.message('December', name: 'december', desc: '', args: []);
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
