import 'package:get_it/get_it.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/data_sources/auth_api_data_source.dart';
import 'package:sports_in/core/network/interfaces/i_auth_data_source.dart';
import 'package:sports_in/data/services/services.dart';


final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<IAuthDataSource>(
    () => AuthApiDataSource(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AuthService>(
    () => AuthService(sl<IAuthDataSource>()),
  );
}
