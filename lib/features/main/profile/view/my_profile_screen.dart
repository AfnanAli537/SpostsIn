import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/profile/data/data_sources/mock_profile_data.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'package:sports_in/features/main/profile/view/profile_screen.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart'; // ✅ Import ApiClient
class My_ProfileScreen extends StatelessWidget {
  const My_ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => ProfileBloc(
          ProfileRepo(MockProfileData()),
        ),
        child: const ProfileScreen(), // 👈 clean reuse
      ),
    );
  }
}
