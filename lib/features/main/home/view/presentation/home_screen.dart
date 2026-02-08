import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';
import 'package:sports_in/features/main/home/data/data_sources/posts_remote_data_sources.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
import 'package:sports_in/features/main/home/view/presentation/content.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/main/opportunity/data/data_source/opportunity_remote_data_source.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/opportunity/view_model/ooprtunity_bloc/opportunity_bloc.dart';

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
          print('📱 Prefs loaded, fetching user...');
          return sharedPref.getUserFromPrefs();
        })
        .then((user) {
          print('👤 User loaded: ${user?.name?.firstName ?? 'null'}');
          return user;
        })
        .catchError((error) {
          print('❌ Error loading user: $error');
          return null;
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginResponse?>(
      future: _userFuture,
      builder: (context, snapshot) {
        // Add detailed logging
        print('📊 FutureBuilder state: ${snapshot.connectionState}');
        print('📊 Has data: ${snapshot.hasData}');
        print('📊 Has error: ${snapshot.hasError}');

        // Handle error state
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
                  Text('Error: ${snapshot.error}'),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initializeData();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  const Text('Loading user data...'),
                ],
              ),
            ),
          );
        }

        // Handle case where user is null
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64.sp),
                  SizedBox(height: 16.h),
                  const Text('No user data found'),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to login or retry
                      setState(() {
                        _initializeData();
                      });
                    },
                    child: const Text('Retry'),
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
            BlocProvider(create: (context) => OpportunityBloc(opportunityRepo:
             OpportunityReposatory(OpportunityRemoteDataSourceImpl(apiClient: apiClient)), prefs:sharedPref.prefs)),
             

          ],
          child: Scaffold(
            body: BlocBuilder<PostsBloc, PostsState>(
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<PostsBloc>().add(const FetchPosts(page: 1));
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // SliverAppBar(
                      //   backgroundColor: Theme.of(context).colorScheme.surface,
                      //   elevation: 0,
                      //   floating: true,
                      //   snap: true,
                      //   leading: IconButton(
                      //     icon: Icon(
                      //       Icons.menu,
                      //       color: Theme.of(context).colorScheme.onSurface,
                      //     ),
                      //     onPressed: () {},
                      //   ),
                      //   actions: [
                      //     IconButton(
                      //       icon: Icon(
                      //         Icons.notifications_outlined,
                      //         color: Theme.of(context).colorScheme.onSurface,
                      //       ),
                      //       onPressed: () {},
                      //     ),
                      //   ],
                      // ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi, //${user.name?.firstName ?? 'Guest'}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ColorManager.yellow,
                                    ),
                                  ),
                                  Text(
                                    'Happy to see you today',
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
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(left: 14.w, bottom: 10.h),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: HomeTab.values.map((tab) {
                                final isSelected = _currentTab == tab;
                                return Padding(
                                  padding: EdgeInsets.only(right: 6.w),
                                  child: ChoiceChip(
                                    label: Text(tab.name),
                                    selected: isSelected,
                                    onSelected: (_) {
                                      setState(() {
                                        _currentTab = tab;
                                      });
                                    },
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
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.secondary
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      BuildContent(
                        currentTab: _currentTab,
                        onTabChange: (tab) {
                          setState(() {
                            _currentTab = tab;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
