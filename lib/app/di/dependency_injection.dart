import 'package:get_it/get_it.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/data/data_sources/auth_api_data_source.dart';
import 'package:sports_in/data/interfaces/i_auth_data_source.dart';
import 'package:sports_in/data/repo/auth_repo.dart';

final sl = GetIt.instance;

void initDependencies() {
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<IAuthDataSource>(
    () => AuthApiDataSource(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AuthRepo>(() => AuthRepo(sl<IAuthDataSource>()));
}
