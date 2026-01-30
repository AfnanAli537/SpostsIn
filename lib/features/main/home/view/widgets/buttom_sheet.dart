import 'package:flutter/material.dart';
import 'package:sports_in/features/main/home/view/presentation/uploadposts.dart';

class CreateOptionsBottomSheet extends StatelessWidget {
  const CreateOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            child: Container(
              width: 100,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFF1D2D3D),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Options List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildOptionCard(
                  icon: Icons.edit_note,
                  iconColor: const Color(0xFFFFA726),
                  title: 'Create Post',
                  onTap: () {
  Navigator.of(context, rootNavigator: true).pop();
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute(
      builder: (_) => const UploadContentScreen(),
    ),
  );
},

//                   onTap: () {
                  
//                     // Navigate to create post
// Navigator.of(context).push(
//   MaterialPageRoute(
//     builder: (context) => const UploadContentScreen(),

//   ),
// );
//     //  Navigator.pop(context);


//                   },
                ),
                const SizedBox(height: 16),
                _buildOptionCard(
                  icon: Icons.star,
                  iconColor: const Color(0xFFFFEE58),
                  title: 'Create Achievement',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to create achievement
                  },
                ),
                const SizedBox(height: 16),
                _buildOptionCard(
                  icon: Icons.campaign,
                  iconColor: const Color(0xFF90CAF9),
                  title: 'Create opportunity',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to create opportunity
                  },
                ),
                const SizedBox(height: 16),
                _buildOptionCard(
                  icon: Icons.work_outline,
                  iconColor: const Color(0xFFBCAAA4),
                  title: 'Create Advertisement',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to create advertisement
                  },
                ),
                const SizedBox(height: 16),
                _buildOptionCard(
                  icon: Icons.play_arrow,
                  iconColor: const Color(0xFF9CCC65),
                  title: 'Make Video Analysis',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to video analysis
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Circle
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1D2D3D),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 20),
            
            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D2D3D),
                ),
              ),
            ),
            
            // Arrow
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF1D2D3D),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// Example of how to show the bottom sheet
void showCreateOptionsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const CreateOptionsBottomSheet(),
  );
}

// // Full example with demo button
// class CreateOptionsDemo extends StatelessWidget {
//   const CreateOptionsDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text('Create Options Demo'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => showCreateOptionsBottomSheet(context),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF1D2D3D),
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           child: const Text(
//             'Open Bottom Sheet',
//             style: TextStyle(fontSize: 16, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }