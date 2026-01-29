import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

  
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/chat');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
   
  }

  Color _iconColor(int index) {
    return _currentIndex == index
        ? const Color(0xFF1D2D3D)
        : Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB0BEC5),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // action button click
        },
        backgroundColor: const Color(0xFF1D2D3D),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Color(0xFFD4E157), size: 35),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home_filled,
                  color: _iconColor(0), size: 30),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.search,
                  color: _iconColor(1), size: 30),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: Icon(Icons.chat_bubble_outline,
                  color: _iconColor(2), size: 28),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(Icons.person_pin_circle_outlined,
                  color: _iconColor(3), size: 30),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}
