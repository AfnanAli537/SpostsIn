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
import 'package:sports_in/core/config/language_cubit/language_cubit.dart'
    as _i185;
import 'package:sports_in/core/config/theme_cubit/theme_cubit.dart' as _i934;
import 'package:sports_in/core/network/api_client.dart' as _i694;
import 'package:sports_in/data/data_sources/auth_api_data_source.dart' as _i172;
import 'package:sports_in/data/interfaces/i_auth_data_source.dart' as _i470;
import 'package:sports_in/data/repo/auth_repo.dart' as _i472;
import 'package:sports_in/features/forget_password/data/data_sources/forget_password_api_data_source.dart'
    as _i701;
import 'package:sports_in/features/forget_password/data/interface/i_forget_password_data_source.dart'
    as _i705;
import 'package:sports_in/features/forget_password/data/repo/forget_password_repo.dart'
    as _i707;
import 'package:sports_in/features/login/data/data_sources/login_api_data_source.dart'
    as _i964;
import 'package:sports_in/features/login/data/interface/i_login_data_source.dart'
    as _i712;
import 'package:sports_in/features/login/data/repo/login_repo.dart' as _i257;
import 'package:sports_in/features/main/home/data/data_sources/posts_remote_data_sources.dart'
    as _i833;
import 'package:sports_in/features/main/home/data/interface/post_interface.dart'
    as _i423;
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart'
    as _i651;
import 'package:sports_in/features/main/profile/data/data_sources/mock_profile_data.dart'
    as _i13;
import 'package:sports_in/features/main/profile/data/interface/i_profile_data_source.dart'
    as _i544;
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart'
    as _i752;
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart'
    as _i939;
import 'package:sports_in/features/register/data/data_sources/register_api_data_source.dart'
    as _i569;
import 'package:sports_in/features/register/data/interface/i_register_data_source.dart'
    as _i65;
import 'package:sports_in/features/register/data/repo/register_repo.dart'
    as _i917;

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
    gh.lazySingleton<_i414.SharedPref>(
      () => _i414.SharedPref(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i544.IProfileDataSource>(() => _i13.MockProfileData());
    gh.factory<_i752.ProfileRepo>(
      () => _i752.ProfileRepo(gh<_i544.IProfileDataSource>()),
    );
    gh.lazySingleton<_i414.SharedPref>(
      () => _i414.SharedPref(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i939.ProfileBloc>(
      () => _i939.ProfileBloc(gh<_i752.ProfileRepo>()),
    );
    gh.lazySingleton<_i694.ApiClient>(
      () => appModule.apiClient(gh<_i414.SharedPref>()),
    );
    gh.factory<_i185.LocaleCubit>(
      () => _i185.LocaleCubit(gh<_i414.SharedPref>()),
    );
    gh.factory<_i934.ThemeCubit>(
      () => _i934.ThemeCubit(gh<_i414.SharedPref>()),
    );
    gh.lazySingleton<_i423.PostsRepository>(
      () => _i833.PostsRemoteDataSourceImpl(apiClient: gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i712.ILoginDataSource>(
      () => _i964.LoginApiDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i470.IAuthDataSource>(
      () => _i172.AuthApiDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i705.IForgetPasswordDataSource>(
      () => _i701.ForgetPasswordApiDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i65.IRegisterDataSource>(
      () => _i569.RegisterApiDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i472.AuthRepo>(
      () => _i472.AuthRepo(gh<_i470.IAuthDataSource>()),
    );
    gh.lazySingleton<_i257.LoginRepo>(
      () =>
          _i257.LoginRepo(gh<_i712.ILoginDataSource>(), gh<_i414.SharedPref>()),
    );
    gh.lazySingleton<_i651.PostsRepositoryImpl>(
      () => _i651.PostsRepositoryImpl(gh<_i423.PostsRepository>()),
    );
    gh.lazySingleton<_i707.ForgetPasswordRepo>(
      () => _i707.ForgetPasswordRepo(gh<_i705.IForgetPasswordDataSource>()),
    );
    gh.lazySingleton<_i917.RegisterRepo>(
      () => _i917.RegisterRepo(gh<_i65.IRegisterDataSource>()),
    );
    return this;
  }
}

class _$AppModule extends _i687.AppModule {}
