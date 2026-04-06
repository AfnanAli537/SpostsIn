import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/profile/view/presentation/profile_screen.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<ProfileBloc>(),
        child: const ProfileScreen(),
      ),
    );
  }
}