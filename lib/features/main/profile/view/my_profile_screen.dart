import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/profile/data/data_sources/mock_profile_data.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'package:sports_in/features/main/profile/view/profile_screen.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart'; 
class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurface),
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
