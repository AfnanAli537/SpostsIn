import 'package:flutter/material.dart';

class LikesBottomSheet extends StatefulWidget {
  const LikesBottomSheet({super.key});

  @override
  State<LikesBottomSheet> createState() => _LikesBottomSheetState();
}

class _LikesBottomSheetState extends State<LikesBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  List<UserModel> users = [
    UserModel(username: 'alex_j', fullName: 'Alex Johnson', isFollowing: false),
    UserModel(username: 'sam_design', fullName: 'Sam Designer', isFollowing: true),
    UserModel(username: 'photography_pro', fullName: 'Chris Evans', isFollowing: false),
    UserModel(username: 'daily_vlog', fullName: 'Sarah Jenkins', isFollowing: true),
    UserModel(username: 'tech_guru_99', fullName: 'Marcus Wright', isFollowing: false),
    UserModel(username: 'foodie_adventures', fullName: 'Elena Gomez', isFollowing: true),
    UserModel(username: 'creative_mind', fullName: 'James Taylor', isFollowing: false),
  ];

  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = users;
    _searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredUsers = users;
      } else {
        filteredUsers = users.where((user) {
          return user.username.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              user.fullName.toLowerCase().contains(_searchController.text.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 🔘 Handle bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // 📝 Title
              const Text(
                'Likes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // 🔍 Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 👥 Users list
              Expanded(
                child: filteredUsers.isEmpty
                    ? const Center(
                        child: Text('No users found', style: TextStyle(color: Colors.grey)),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          return _buildUserItem(filteredUsers[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserItem(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey[300],
            child: Text(
              user.username[0].toUpperCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.username,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(user.fullName, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  user.isFollowing = !user.isFollowing;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: user.isFollowing ? Colors.grey[200] : const Color(0xFF0095F6),
                foregroundColor: user.isFollowing ? Colors.black : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                user.isFollowing ? 'Following' : 'Follow',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: user.isFollowing ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// 📦 Model
class UserModel {
  final String username;
  final String fullName;
  bool isFollowing;

  UserModel({required this.username, required this.fullName, required this.isFollowing});
}
