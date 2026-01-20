// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:sports_in/app/di/external_dap.dart' as _i687;
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart' as _i414;
import 'package:sports_in/core/network/api_client.dart' as _i694;
import 'package:sports_in/data/data_sources/auth_api_data_source.dart' as _i172;
import 'package:sports_in/data/interfaces/i_auth_data_source.dart' as _i470;
import 'package:sports_in/data/repo/auth_repo.dart' as _i472;
import 'package:sports_in/core/config/language_cubit/language_cubit.dart'
    as _i632;
import 'package:sports_in/core/config/theme_cubit/theme_cubit.dart' as _i1015;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i694.ApiClient>(() => appModule.apiClient());
    gh.lazySingleton<_i414.SharedPref>(
      () => _i414.SharedPref(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i470.IAuthDataSource>(
      () => _i172.AuthApiDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i472.AuthRepo>(
      () => _i472.AuthRepo(gh<_i470.IAuthDataSource>()),
    );
    gh.factory<_i632.LocaleCubit>(
      () => _i632.LocaleCubit(gh<_i414.SharedPref>()),
    );
    gh.factory<_i1015.ThemeCubit>(
      () => _i1015.ThemeCubit(gh<_i414.SharedPref>()),
    );
    return this;
  }
}

class _$AppModule extends _i687.AppModule {}
