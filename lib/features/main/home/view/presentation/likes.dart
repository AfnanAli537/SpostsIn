import 'package:flutter/material.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Sample users list
  List<UserModel> users = [
    UserModel(
      username: 'alex_j',
      fullName: 'Alex Johnson',
      isFollowing: false,
    ),
    UserModel(
      username: 'sam_design',
      fullName: 'Sam Designer',
      isFollowing: true,
    ),
    UserModel(
      username: 'photography_pro',
      fullName: 'Chris Evans',
      isFollowing: false,
    ),
    UserModel(
      username: 'daily_vlog',
      fullName: 'Sarah Jenkins',
      isFollowing: true,
    ),
    UserModel(
      username: 'tech_guru_99',
      fullName: 'Marcus Wright',
      isFollowing: false,
    ),
    UserModel(
      username: 'foodie_adventures',
      fullName: 'Elena Gomez',
      isFollowing: true,
    ),
    UserModel(
      username: 'creative_mind',
      fullName: 'James Taylor',
      isFollowing: false,
    ),
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
          return user.username
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              user.fullName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Likes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                    size: 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Users List
          Expanded(
            child: filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No users found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return _buildUserItem(filteredUsers[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[300],
            child: Text(
              user.username[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Username and Full Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Follow/Following Button
          SizedBox(
            width: 110,
            height: 38,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  user.isFollowing = !user.isFollowing;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    user.isFollowing ? Colors.grey[200] : const Color(0xFF0095F6),
                foregroundColor: user.isFollowing ? Colors.black : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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

// User Model
class UserModel {
  final String username;
  final String fullName;
  bool isFollowing;

  UserModel({
    required this.username,
    required this.fullName,
    required this.isFollowing,
  });
}