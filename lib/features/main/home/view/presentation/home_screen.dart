import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/network/api_client.dart'; // ✅ Import ApiClient
import 'package:sports_in/features/main/home/data/data_sources/posts_remote_data_sources.dart';
import 'package:sports_in/features/main/home/data/interface/home_tap_enums.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
import 'package:sports_in/features/main/home/view/presentation/content.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeTab _currentTab = HomeTab.forYou;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        // Show loading while SharedPreferences is being initialized
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final prefs = snapshot.data!;
        final apiClient = ApiClient(prefs); // ✅ Create ApiClient with token support

        return BlocProvider(
          create: (_) => PostsBloc(
            postRepo: PostsRepositoryImpl(
              PostsRemoteDataSourceImpl(apiClient: apiClient), // ✅ Pass ApiClient
            ),
          )..add(const FetchPosts()),
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  floating: true,
                  snap: true,
                  leading: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {},
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, Sana',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.yellow,
                              ),
                            ),
                            const Text(
                              'Happy to see you today',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, bottom: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: HomeTab.values.map((tab) {
                          final isSelected = _currentTab == tab;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(tab.name),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  _currentTab = tab;
                                });
                              },
                              selectedColor: ColorManager.lightPrimary,
                              checkmarkColor:
                                  Theme.of(context).colorScheme.secondary,
                              labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.black,
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
          ),
        );
      },
    );
  }
}