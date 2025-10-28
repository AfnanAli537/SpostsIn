import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/constants/strings_keys.dart';

class SharedPref {
  final SharedPreferences _prefs;

  SharedPref(this._prefs);
  ///onboarding
 static Future<SharedPref> init() async {
  final prefs = await SharedPreferences.getInstance();
  return SharedPref(prefs);
}
  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(StringKeys.onboardingKey, value);
  }

  bool getOnboardingCompleted() {
    return _prefs.getBool(StringKeys.onboardingKey) ?? false;
  }
 
 ///privacy policy
 Future<void> setPrivacySeen(bool value) async {
    await _prefs.setBool(StringKeys.privacyKey, value);
  }

  bool getPrivacySeen() {
    return _prefs.getBool(StringKeys.privacyKey) ?? false;
  }


/// general for theme & localization

   Future setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

   String? getString(String key) {
    return _prefs.getString(key);
  }


/// general clear 
   Future clear() async {
    await _prefs.clear();
  }


}

