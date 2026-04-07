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
import 'package:sports_in/features/main/advertisement/data/data_sources/ad_remote_data_source.dart'
    as _i823;
import 'package:sports_in/features/main/advertisement/data/interface/i_ads_data_source.dart'
    as _i658;
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart'
    as _i277;
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart'
    as _i259;
import 'package:sports_in/features/main/chat/data/data_sources/chat_remote_data_source.dart'
    as _i661;
import 'package:sports_in/features/main/chat/data/data_sources/chat_remote_data_source_impl.dart'
    as _i436;
import 'package:sports_in/features/main/chat/data/repo/chat_repo.dart' as _i503;
import 'package:sports_in/features/main/chat/data/service/chat_hub_service.dart'
    as _i679;
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart'
    as _i324;
import 'package:sports_in/features/main/chat_bot/data/data_source/chatbot_remote_data_source.dart'
    as _i82;
import 'package:sports_in/features/main/chat_bot/data/interface/chatbot_interface.dart'
    as _i130;
import 'package:sports_in/features/main/chat_bot/data/repo/chatbot_repo.dart'
    as _i1050;
import 'package:sports_in/features/main/chat_bot/presentation/view_model.dart/bloc/chatbot_bloc.dart'
    as _i982;
import 'package:sports_in/features/main/courses/data/data_sources/course_remote_data_source.dart'
    as _i8;
import 'package:sports_in/features/main/courses/data/interface/i_course_data_source.dart'
    as _i592;
import 'package:sports_in/features/main/courses/data/repo/course_repository.dart'
    as _i674;
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart'
    as _i567;
import 'package:sports_in/features/main/home/data/data_sources/posts_remote_data_sources.dart'
    as _i833;
import 'package:sports_in/features/main/home/data/interface/post_interface.dart'
    as _i423;
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart'
    as _i651;
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart'
    as _i45;
import 'package:sports_in/features/main/opportunity/data/data_source/opportunity_remote_data_source.dart'
    as _i78;
import 'package:sports_in/features/main/opportunity/data/interface/opportunity_interface.dart'
    as _i709;
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart'
    as _i294;
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart'
    as _i1047;
import 'package:sports_in/features/main/profile/data/data_sources/profile_api_data_source.dart'
    as _i505;
import 'package:sports_in/features/main/profile/data/interface/i_profile_data_source.dart'
    as _i544;
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart'
    as _i752;
import 'package:sports_in/features/main/profile/view_model/connection%20bloc/connections_bloc.dart'
    as _i691;
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart'
    as _i86;
import 'package:sports_in/features/main/search/data/data_sources/mock_search_data_source.dart'
    as _i1019;
import 'package:sports_in/features/main/search/data/interface/i_search_data_source.dart'
    as _i109;
import 'package:sports_in/features/main/search/data/repo/search_repo.dart'
    as _i514;
import 'package:sports_in/features/main/search/view_model/search_bloc.dart'
    as _i803;
import 'package:sports_in/features/notitification/data/data_source/notifi_data_source_impl.dart'
    as _i577;
import 'package:sports_in/features/notitification/data/interface/notifi_interface.dart'
    as _i102;
import 'package:sports_in/features/notitification/data/repo/notifi_repo.dart'
    as _i62;
import 'package:sports_in/features/notitification/data/service/notifaction_service.dart'
    as _i700;
import 'package:sports_in/features/notitification/presentation/view_model/bloc/notification_bloc.dart'
    as _i987;
import 'package:sports_in/features/payment/data/data_source/payment_remote_data_source.dart'
    as _i505;
import 'package:sports_in/features/payment/data/interface/payment_interface.dart'
    as _i802;
import 'package:sports_in/features/payment/data/repo/payment_repo.dart'
    as _i221;
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart'
    as _i971;
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
    gh.lazySingleton<_i679.ChatHubService>(() => _i679.ChatHubService());
    gh.lazySingleton<_i700.NotificationHubService>(
      () => _i700.NotificationHubService(),
    );
    gh.lazySingleton<_i414.SharedPref>(
      () => _i414.SharedPref(gh<_i460.SharedPreferences>()),
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
    gh.lazySingleton<_i802.PaymentInterface>(
      () => _i505.PaymentRemoteDataSourceImpl(apiClient: gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i661.ChatRemoteDataSource>(
      () => _i436.ChatRemoteDataSourceImpl(apiClient: gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i712.ILoginDataSource>(
      () => _i964.LoginApiDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i544.IProfileDataSource>(
      () => _i505.ApiProfileDataSource(
        gh<_i694.ApiClient>(),
        gh<_i414.SharedPref>(),
      ),
    );
    gh.lazySingleton<_i709.OpportunityInterface>(
      () => _i78.OpportunityRemoteDataSourceImpl(
        apiClient: gh<_i694.ApiClient>(),
      ),
    );
    gh.lazySingleton<_i130.ChatbotRemoteDataSource>(
      () => _i82.ChatbotRemoteDataSourceImpl(apiClient: gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i470.IAuthDataSource>(
      () => _i172.AuthApiDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i705.IForgetPasswordDataSource>(
      () => _i701.ForgetPasswordApiDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i294.OpportunityReposatory>(
      () => _i294.OpportunityReposatory(gh<_i709.OpportunityInterface>()),
    );
    gh.lazySingleton<_i102.NotificationRemoteDataSource>(
      () => _i577.NotificationRemoteDataSourceImpl(
        apiClient: gh<_i694.ApiClient>(),
      ),
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
    gh.lazySingleton<_i221.PaymentRepository>(
      () =>
          _i221.PaymentRepositoryImpl(dataSource: gh<_i802.PaymentInterface>()),
    );
    gh.factory<_i971.PaymentBloc>(
      () => _i971.PaymentBloc(repository: gh<_i221.PaymentRepository>()),
    );
    gh.factory<_i1047.OpportunityBloc>(
      () => _i1047.OpportunityBloc(
        opportunityRepo: gh<_i294.OpportunityReposatory>(),
      ),
    );
    gh.lazySingleton<_i658.IAdsDataSource>(
      () => _i823.AdRemoteDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i109.ISearchDataSource>(
      () => _i1019.SearchDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i592.ICourseDataSource>(
      () => _i8.CourseRemoteDataSource(gh<_i694.ApiClient>()),
    );
    gh.lazySingleton<_i651.PostsRepositoryImpl>(
      () => _i651.PostsRepositoryImpl(gh<_i423.PostsRepository>()),
    );
    gh.factory<_i752.ProfileRepo>(
      () => _i752.ProfileRepo(gh<_i544.IProfileDataSource>()),
    );
    gh.lazySingleton<_i62.NotificationRepository>(
      () => _i62.NotificationRepository(
        remoteDataSource: gh<_i102.NotificationRemoteDataSource>(),
      ),
    );
    gh.factory<_i277.AdsRepositoryImpl>(
      () => _i277.AdsRepositoryImpl(gh<_i658.IAdsDataSource>()),
    );
    gh.lazySingleton<_i503.ChatRepository>(
      () => _i503.ChatRepository(
        remoteDataSource: gh<_i661.ChatRemoteDataSource>(),
      ),
    );
    gh.factory<_i691.ConnectionsBloc>(
      () => _i691.ConnectionsBloc(gh<_i752.ProfileRepo>()),
    );
    gh.factory<_i86.ProfileBloc>(
      () => _i86.ProfileBloc(gh<_i752.ProfileRepo>()),
    );
    gh.factory<_i45.PostsBloc>(
      () => _i45.PostsBloc(postRepo: gh<_i651.PostsRepositoryImpl>()),
    );
    gh.lazySingleton<_i1050.ChatbotRepository>(
      () => _i1050.ChatbotRepository(
        remoteDataSource: gh<_i130.ChatbotRemoteDataSource>(),
      ),
    );
    gh.factory<_i987.NotificationBloc>(
      () =>
          _i987.NotificationBloc(repository: gh<_i62.NotificationRepository>()),
    );
    gh.lazySingleton<_i707.ForgetPasswordRepo>(
      () => _i707.ForgetPasswordRepo(gh<_i705.IForgetPasswordDataSource>()),
    );
    gh.factory<_i259.AdsBloc>(
      () => _i259.AdsBloc(adsRepo: gh<_i277.AdsRepositoryImpl>()),
    );
    gh.factory<_i982.ChatbotBloc>(
      () => _i982.ChatbotBloc(repository: gh<_i1050.ChatbotRepository>()),
    );
    gh.lazySingleton<_i917.RegisterRepo>(
      () => _i917.RegisterRepo(gh<_i65.IRegisterDataSource>()),
    );
    gh.factory<_i514.SearchRepo>(
      () => _i514.SearchRepo(gh<_i109.ISearchDataSource>()),
    );
    gh.factory<_i674.CourseRepository>(
      () => _i674.CourseRepository(gh<_i592.ICourseDataSource>()),
    );
    gh.factory<_i567.CoursesBloc>(
      () => _i567.CoursesBloc(gh<_i674.CourseRepository>()),
    );
    gh.factory<_i324.ChatBloc>(
      () => _i324.ChatBloc(
        repo: gh<_i503.ChatRepository>(),
        hub: gh<_i679.ChatHubService>(),
      ),
    );
    gh.factory<_i803.SearchBloc>(
      () => _i803.SearchBloc(gh<_i514.SearchRepo>()),
    );
    return this;
  }
}

class _$AppModule extends _i687.AppModule {}
