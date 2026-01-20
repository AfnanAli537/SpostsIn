import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/constants/strings_keys.dart';

@lazySingleton
class SharedPref {
  final SharedPreferences _prefs;

  SharedPref(this._prefs);

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
  Future<void> saveToken(String token) async {
    await _prefs.setString(StringKeys.tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(StringKeys.tokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(StringKeys.tokenKey);
    await _prefs.remove(StringKeys.expireData);
  }

  Future<void> saveExpiryDate(String expiryDate) async {
    await _prefs.setString(StringKeys.expireData, expiryDate);
  }

  String? getExpiryDate() {
    return _prefs.getString(StringKeys.expireData);
  }

  /// clear all
  Future<void> clear() async {
    await _prefs.clear();
  }
}
