import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';

@lazySingleton
class SharedPref {
  final SharedPreferences _prefs;

  SharedPref(this._prefs);
  SharedPreferences get prefs => _prefs;

  /// onboarding
  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(StringKeys.onboardingKey, value);
  }

  bool getOnboardingCompleted() {
    return _prefs.getBool(StringKeys.onboardingKey) ?? false;
  }

  /// privacy policy
  Future<void> setPrivacySeen(bool value) async {
    await _prefs.setBool(StringKeys.privacyKey, value);
  }

  bool getPrivacySeen() {
    return _prefs.getBool(StringKeys.privacyKey) ?? false;
  }

  /// general
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// token
  Future<void> saveToken(String? token) async {
    await _prefs.setString(StringKeys.tokenKey, token!);
  }

  String? getToken() {
    return _prefs.getString(StringKeys.tokenKey);
  }

  Future<void> saveUserId(String? userId) async {
    await _prefs.setString(StringKeys.userIdKey, userId!);
  }

  String? getUserId() {
    return _prefs.getString(StringKeys.userIdKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(StringKeys.tokenKey);
    await _prefs.remove(StringKeys.expireData);
    await _prefs.remove(StringKeys.userId);
  }

  Future<void> saveExpiryDate(DateTime expiryDate) async {
    await _prefs.setString(
      StringKeys.expireData,
      expiryDate.toUtc().toIso8601String(),
    );
  }

  DateTime? getExpiryDate() {
    final value = _prefs.getString(StringKeys.expireData);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  bool isTokenValid() {
    final token = getToken();
    final expiryDate = getExpiryDate();

    if (token == null || token.isEmpty) return false;
    if (expiryDate == null) return false;

    return DateTime.now().toUtc().isBefore(expiryDate);
  }

  /// clear all
  Future<void> clear() async {
    await _prefs.clear();
  }

  ///user data

  Future<void> saveUserToPrefs(LoginResponse response) async {
    if (response.token != null)
      await _prefs.setString('Token', response.token!);
    if (response.userId != null)
      await _prefs.setString('userId', response.userId!);
    if (response.userType != null)
      await _prefs.setString('userType', response.userType!);
    if (response.email != null)
      await _prefs.setString('email', response.email!);
    if (response.name != null) {
      await _prefs.setString('name', jsonEncode(response.name!.toJson()));
    }
    if (response.expiresAt != null) {
      await _prefs.setString('expire', response.expiresAt!.toIso8601String());
    }
  }

  Future<LoginResponse?> getUserFromPrefs() async {
    final token = _prefs.getString('Token');
    final userId = _prefs.getString('userId');
    final userType = _prefs.getString('userType');
    final email = _prefs.getString('email');

    UserName? name;
    final nameStr = _prefs.getString('name');
    if (nameStr != null) {
      name = UserName.fromJson(jsonDecode(nameStr));
    }

    DateTime? expiresAt;
    final expiresAtStr = _prefs.getString('expire');
    if (expiresAtStr != null) {
      expiresAt = DateTime.tryParse(expiresAtStr);
    }

    return LoginResponse(
      isSuccess: true,
      message: "Welcome Back",
      token: token,
      userId: userId,
      userType: userType,
      email: email,
      name: name,
      expiresAt: expiresAt,
    );
  }
}
