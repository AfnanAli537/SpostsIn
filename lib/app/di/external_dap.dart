import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/network/api_client.dart';
@module
abstract class AppModule {
  @lazySingleton
   ApiClient apiClient(SharedPreferences prefs) =>
      ApiClient(prefs);
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
