import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/constants/strings_keys.dart';

class SharedPref {
  static  late SharedPreferences _prefs;


  ///onboarding
 static Future<void> init() async {
   _prefs = await SharedPreferences.getInstance();
}
  static Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(StringKeys.onboardingKey, value);
  }

 static bool getOnboardingCompleted() {
    return _prefs.getBool(StringKeys.onboardingKey) ?? false;
  }
 
 ///privacy policy
 static Future<void> setPrivacySeen(bool value) async {
    await _prefs.setBool(StringKeys.privacyKey, value);
  }

  static bool getPrivacySeen() {
    return _prefs.getBool(StringKeys.privacyKey) ?? false;
  }


/// general for theme & localization

  static Future setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

 static  String? getString(String key) {
    return _prefs.getString(key);
  }


/// general clear 
 static  Future clear() async {
    await _prefs.clear();
  }

///token
  static Future<void> saveToken(String token) async {
    await _prefs.setString(StringKeys.tokenKey, token);
  }
  static Future<String?> getToken() async {
    return _prefs.getString(StringKeys.tokenKey);
  }
  static Future<void> clearToken() async {
    await _prefs.remove(StringKeys.tokenKey);
    await _prefs.remove(StringKeys.expireData);
  }
  static Future<void> saveExpiryDate(String expiryDate) async {
    await _prefs.setString(StringKeys.expireData, expiryDate);
  }
  static Future<String?> getExpiryDate() async {
    return _prefs.getString(StringKeys.expireData);
  }
}

