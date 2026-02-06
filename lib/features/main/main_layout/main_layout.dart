import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/home/view/presentation/home_screen.dart';
import 'package:sports_in/features/main/home/view/widgets/buttom_sheet.dart';
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

  final List<Widget> _pages =  [
 

    HomePage(),
    Center(child: Text("Search")),
    Center(child: Text("Messages")),
    Center(child: Text("Profile")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Color _iconColor(int index) {
    return _currentIndex == index
        ? Theme.of(context).colorScheme.primary
        : const Color(0xFFB0BEC5);
  }
Widget _buildNavItem(IconData icon, int index) {
  final isSelected = _currentIndex == index;

  return InkWell(
    onTap: () => _onItemTapped(index),
    customBorder: const CircleBorder(), 
    child: Padding(
      padding: EdgeInsets.all(10.r), 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _iconColor(index), size: 26.r),
          SizedBox(height: 4.h),
          Container(
            width: 5.w,
            height: 5.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Colors.transparent,
            ),
          ),
        ],
      ),
    ),
  );
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    extendBody: true, 
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: IndexedStack(
      index: _currentIndex,
      children: _pages,
    ),

    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    floatingActionButton: Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary, 
      ),
      child: FloatingActionButton(
        shape: const CircleBorder(), 
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          showCreateOptionsBottomSheet(context);
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary, size: 32.r),
      ),
    ),

    bottomNavigationBar: BottomAppBar(
      clipBehavior: Clip.antiAlias, 
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.r,
      color: Theme.of(context).colorScheme.surface, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.search, 1),
           SizedBox(width: 60.w), 
          _buildNavItem(Icons.chat_bubble_outline, 2),
          _buildNavItem(Icons.person_outline, 3),
        ],
      ),
    ),
  );
}
}