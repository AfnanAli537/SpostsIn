import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/widgets/app_drawer.dart';
import 'package:sports_in/features/main/profile/view/presentation/my_profile_screen.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_event.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const Center(child: Text("Home")),
    const Center(child: Text("Search")),
    const Center(child: Text("Messages")),

    MyProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
    // Load profile ONCE when the main layout is created
    context.read<ProfileBloc>().add(LoadMyProfile());
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Color _iconColor(int index) {
    return _currentIndex == index
        ? const Color(0xFF1D2D3D)
        : const Color(0xFFB0BEC5);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () =>
              _scaffoldKey.currentState?.openDrawer(), // Open drawer
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Logo from Assets
            Image.asset(
              ImageAssets.logo,
              height: 32.h, // Scaled height
              width: 32.w,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8.w),
            // App Name
            Text(
              "SportsIn",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),

      drawer: const AppDrawer(),
      body: IndexedStack(index: _currentIndex, children: _pages),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF1D2D3D), Color(0xFF2C3E50)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF1D2D3D),
              blurRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            //  showCreateOptionsBottomSheet(context);
          },
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 0),
            _buildNavItem(Icons.search, 1),
            const SizedBox(width: 60),
            _buildNavItem(Icons.chat_bubble_outline, 2),
            _buildNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _iconColor(index), size: 26),
          const SizedBox(height: 4),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF1D2D3D) : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
