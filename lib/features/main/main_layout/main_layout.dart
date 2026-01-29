// import 'package:flutter/material.dart';
// import 'package:sports_in/features/main/home/view/presentation/home_screen.dart';

// class CustomBottomNav extends StatefulWidget {
//   const CustomBottomNav({super.key});

//   @override
//   State<CustomBottomNav> createState() => _CustomBottomNavState();
// }

// class _CustomBottomNavState extends State<CustomBottomNav> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = const [
//     HomePage(),
//     Center(child: Text("hello")),
//     Center(child: Text("hello")),
//     Center(child: Text("hello")),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   Color _iconColor(int index) {
//     return _currentIndex == index
//         ? const Color(0xFF1D2D3D)
//         : Colors.blueGrey;
//   }

//   /// 🔹 Bottom Sheet (لازم تكون هنا 👇)
//   void _openBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               ListTile(
//                 leading: const Icon(Icons.post_add),
//                 title: const Text("Create Post"),
//                 onTap: () {},
//               ),
//               ListTile(
//                 leading: const Icon(Icons.video_call),
//                 title: const Text("Upload Video"),
//                 onTap: () {},
//               ),
//               ListTile(
//                 leading: const Icon(Icons.event),
//                 title: const Text("Create Event"),
//                 onTap: () {},
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: _openBottomSheet,
//         backgroundColor: const Color(0xFF1D2D3D),
//         shape: const CircleBorder(),
//         child: const Icon(
//           Icons.add,
//           color: Color(0xFFD4E157),
//           size: 35,
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         height: 80,
//         color: Colors.white,
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8.0,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: Icon(Icons.home_filled,
//                   color: _iconColor(0), size: 30),
//               onPressed: () => _onItemTapped(0),
//             ),
//             IconButton(
//               icon: Icon(Icons.search,
//                   color: _iconColor(1), size: 30),
//               onPressed: () => _onItemTapped(1),
//             ),
//             const SizedBox(width: 40),
//             IconButton(
//               icon: Icon(Icons.chat_bubble_outline,
//                   color: _iconColor(2), size: 28),
//               onPressed: () => _onItemTapped(2),
//             ),
//             IconButton(
//               icon: Icon(Icons.person_pin_circle_outlined,
//                   color: _iconColor(3), size: 30),
//               onPressed: () => _onItemTapped(3),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:sports_in/features/main/home/view/presentation/home_screen.dart';
import 'package:sports_in/features/main/home/view/widgets/buttom_sheet.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
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
        ? const Color(0xFF1D2D3D)
        : const Color(0xFFB0BEC5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1D2D3D),
              Color(0xFF2C3E50),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF1D2D3D),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
           showCreateOptionsBottomSheet(context);
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
              color:
                  isSelected ? const Color(0xFF1D2D3D) : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
