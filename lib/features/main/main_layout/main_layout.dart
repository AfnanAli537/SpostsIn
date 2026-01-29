import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB0BEC5), // Match background gray
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1D2D3D), // Dark navy circle
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Color(0xFFD4E157), size: 35), // Lime green plus
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        color: Colors.white,
        shape: const CircularNotchedRectangle(), // Creates the "dip"
        notchMargin: 8.0, // Space between FAB and bar
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home_filled, color: Color(0xFF1D2D3D), size: 30),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.blueGrey, size: 30),
              onPressed: () {},
            ),
            const SizedBox(width: 40), // Spacer for the FAB location
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.blueGrey, size: 28),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_pin_circle_outlined, color: Colors.blueGrey, size: 30),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}