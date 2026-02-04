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
  Future<void> saveToken(String? token) async {
    await _prefs.setString(StringKeys.tokenKey, token!);
  }

  String? getToken() {
    return _prefs.getString(StringKeys.tokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(StringKeys.tokenKey);
    await _prefs.remove(StringKeys.expireData);
    await _prefs.remove(StringKeys.userId);
  }

  // Future<void> saveExpiryDate(String expiryDate) async {
  //   await _prefs.setString(StringKeys.expireData, expiryDate);
  // }

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

//user id
Future<void> saveUserId(String? userId) async {
    await _prefs.setString(StringKeys.userId, userId!);
}
String? getUserId() {
    return _prefs.getString(StringKeys.userId);
}
  // Future<void> saveExpiryDate(DateTime? expiryDate) async {
  //   if (expiryDate == null) return;
  //   await _prefs.setString(StringKeys.expireData, expiryDate.toIso8601String());
  // }

  // String? getExpiryDate() {
  //   return _prefs.getString(StringKeys.expireData);
  // }

//   bool isTokenValid() {
//     final token = getToken();
//     final expiryString = getExpiryDate();

//     if (token == null || token.isEmpty) {
//       print ('token ===========null');
//       return false;
//       }
//     if (expiryString == null || expiryString.isEmpty) 
//    { 
//     print('exp==========null');
//     return false;}

//     final expiryDate = DateTime.tryParse(expiryString);
//     if (expiryDate == null){   print('expD==========null');
//       return false;}
// print('Token: $token');
// print('Expiry: $expiryString');
// print('Token valid? ${DateTime.now().isBefore(DateTime.tryParse(expiryString)!)}');

//     return DateTime.now().isBefore(expiryDate);
//   }
   
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
}
