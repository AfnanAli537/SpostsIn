import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/features/main/profile/data/data_sources/mock_profile_data.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import '../../view_model/profile_bloc.dart';
import '../../view_model/profile_event.dart';
import 'profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(string.profile),
      ),
      body: BlocProvider(
        create: (context) => ProfileBloc(
          ProfileRepo(MockProfileData()), 
        )..add(LoadUserProfile(widget.userId)), 
        child: ProfileScreen(userId: widget.userId),
      ),
    );
  }
}