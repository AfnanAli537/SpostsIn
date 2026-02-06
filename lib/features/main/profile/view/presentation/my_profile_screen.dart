import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sports_in/core/widgets/app_drawer.dart';
import 'package:sports_in/features/main/profile/data/data_sources/mock_profile_data.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'package:sports_in/features/main/profile/view/presentation/profile_screen.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart'; 
class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ProfileBloc(
          ProfileRepo(MockProfileData()),
        ),
        child: const ProfileScreen(),
      ),
    );
  }
}
