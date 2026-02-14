import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/home/view/presentation/home_screen.dart';
import 'package:sports_in/features/main/home/view/widgets/buttom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/widgets/app_drawer.dart';
import 'package:sports_in/features/main/profile/view/presentation/my_profile_screen.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_event.dart';
import 'package:sports_in/features/main/search/view/presentation/search_screen.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const HomePage(),
    const SearchScreen(),
    const Center(child: Text("Messages")),
    const MyProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadMyProfile());
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.h,
          ), // Reduced vertical padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : const Color(0xFFB0BEC5),
                size: 24.r,
              ),
              SizedBox(height: 2.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 5.w,
                height: 5.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      drawer: const AppDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    ImageAssets.logo,
                    height: 32.h,
                    width: 32.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "SportsIn",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ];
        },
        body: IndexedStack(index: _currentIndex, children: _pages),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 60.w,
        height: 60.h,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: theme.colorScheme.primary,
          elevation: 4,
          onPressed: () => showCreateOptionsBottomSheet(context),
          child: Icon(
            Icons.add,
            color: theme.colorScheme.onPrimary,
            size: 32.r,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.r,
        padding: EdgeInsets.zero, // Important to remove default padding
        child: SizedBox(
          height: 65.h, // Explicit height helps prevent vertical overflow
          child: Row(
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.search, 1),
              SizedBox(width: 60.w), // Space for FAB
              _buildNavItem(Icons.chat_bubble_outline, 2),
              _buildNavItem(Icons.person_outline, 3),
            ],
          ),
        ),
      ),
    );
  }
}
