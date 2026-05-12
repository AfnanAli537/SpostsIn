import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/courses_tab.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/features/main/home/data/data_sources/posts_remote_data_sources.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
import 'package:sports_in/features/main/home/view/presentation/content.dart';
import 'package:sports_in/features/main/home/view/presentation/home_tab.dart';
import 'package:sports_in/features/main/home/view/presentation/posts_tab.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/main/opportunity/data/data_source/opportunity_remote_data_source.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/opportunity_list.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/features/main/profile/data/interface/i_profile_data_source.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_state.dart';
import 'package:sports_in/generated/l10n.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeTab _currentTab = HomeTab.forYou;
  late SharedPref sharedPref;
  late Future<LoginResponse?> _userFuture;
  late Future<SharedPreferences> _prefsFuture;

  final _forYouKey = GlobalKey<ForYouTabState>();
  final _postsKey = GlobalKey<PostsTabState>();
  final _coursesKey = GlobalKey<CoursesTabState>();
  final _opportunitiesKey = GlobalKey<OpportunitiesContentState>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _prefsFuture = SharedPreferences.getInstance();
    _userFuture = _prefsFuture
        .then((prefsInstance) {
          sharedPref = SharedPref(prefsInstance);
          log('📱 Prefs loaded, fetching user...');
          return sharedPref.getUserFromPrefs();
        })
        .then((user) {
          log('👤 User loaded: ${user?.name?.firstName ?? 'null'}');
          return user;
        })
        .catchError((error) {
          log('❌ Error loading user: $error');
          return null;
        });
  }

  void _onTabTapped(HomeTab tab) {
    if (_currentTab == tab) {
      _reloadCurrentTab(tab);
    } else {
      setState(() => _currentTab = tab);
    }
  }

  void _reloadCurrentTab(HomeTab tab) {
    switch (tab) {
      case HomeTab.forYou:
        _forYouKey.currentState?.reload();
        break;
      case HomeTab.posts:
        _postsKey.currentState?.reload();
        break;
      case HomeTab.courses:
        _coursesKey.currentState?.reload();
        break;
      case HomeTab.opportunities:
        _opportunitiesKey.currentState?.reload();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    return FutureBuilder<LoginResponse?>(
      future: _userFuture,
      builder: (context, snapshot) {
        log('📊 FutureBuilder state: ${snapshot.connectionState}');
        log('📊 Has data: ${snapshot.hasData}');
        log('📊 Has error: ${snapshot.hasError}');

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.red[300],
                  ),
                  SizedBox(height: 16.h),
                  Text('${strings.error}: ${snapshot.error}'),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => setState(() => _initializeData()),
                    child: Text(strings.retry),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  Text(strings.loadingUserData),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64.sp),
                  SizedBox(height: 16.h),
                  Text(strings.noUserDataFound),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => setState(() => _initializeData()),
                    child: Text(strings.retry),
                  ),
                ],
              ),
            ),
          );
        }

        final user = snapshot.data!;
        final apiClient = ApiClient(sharedPref);

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => PostsBloc(
                postRepo: PostsRepositoryImpl(
                  PostsRemoteDataSourceImpl(apiClient: apiClient),
                ),
              )..add(const FetchPosts()),
            ),
            BlocProvider(
              create: (_) =>
                  AdsBloc(adsRepo: getIt<AdsRepositoryImpl>())
                    ..add(const FetchAdsFeed()),
            ),
            BlocProvider(
              create: (_) => OpportunityBloc(
                opportunityRepo: OpportunityReposatory(
                  OpportunityRemoteDataSourceImpl(apiClient: apiClient),
                ),
                profileRepo: getIt<IProfileDataSource>(),
              ),
            ),
            BlocProvider(create: (_) => getIt<CoursesBloc>()),
          ],
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                _reloadCurrentTab(_currentTab);
                await Future.delayed(const Duration(milliseconds: 600));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ── Greeting ──────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          BlocBuilder<ProfileBloc, ProfileState>(
                            buildWhen: (prev, curr) =>
                                curr is ProfileLoaded || curr is ProfileLoading,
                            builder: (context, state) {
                              String? imageUrl;
                              if (state is ProfileLoaded) {
                                imageUrl = state.profile.profileImage;
                              }

                              return CircleAvatar(
                                radius: 22.r,
                                backgroundColor:
                                    theme.colorScheme.onError,
                                backgroundImage:
                                    (imageUrl != null && imageUrl.isNotEmpty)
                                    ? NetworkImage(imageUrl)
                                    : null,
                                child: (imageUrl == null || imageUrl.isEmpty)
                                    ? Icon(
                                        Icons.person,
                                        size: 24.r,
                                        color: theme.colorScheme.primary,
                                      )
                                    : null,
                              );
                            },
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${strings.hi}, ${user.name?.firstName ?? strings.guest}",
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorManager.yellow,
                                ),
                              ),
                              Text(
                                strings.happyToSeeYouToday,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Tab chips ─────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: HomeTab.values.map((tab) {
                            final isSelected = _currentTab == tab;
                            return Padding(
                              padding: EdgeInsets.only(right: 6.w),
                              child: ChoiceChip(
                                label: Text(tab.getName(strings)),
                                selected: isSelected,
                                onSelected: (_) => _onTabTapped(tab),
                                selectedColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                checkmarkColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                                labelStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  // ── Tab content ───────────────────────────────────────────
                  BuildContent(
                    currentTab: _currentTab,
                    onTabChange: (tab) => setState(() => _currentTab = tab),
                    forYouKey: _forYouKey,
                    postsKey: _postsKey,
                    coursesKey: _coursesKey,
                    opportunitiesKey: _opportunitiesKey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}