import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_state.dart';
import 'edit_profile/player_edit_screen.dart';
import 'edit_profile/coach_edit_screen.dart';
import 'edit_profile/scout_edit_screen.dart';
import 'edit_profile/club_edit_screen.dart';
import 'edit_profile/institute_edit_screen.dart';
import 'edit_profile/other_edit_screen.dart';

class EditProfileRouterScreen extends StatelessWidget {
  const EditProfileRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is! ProfileLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = state.profile;

        switch (profile.userType) {
          case UserType.player:
            return PlayerEditScreen(profile: profile);
          case UserType.coach:
            return CoachEditScreen(profile: profile);
          case UserType.scout:
            return ScoutEditScreen(profile: profile);
          case UserType.club:
            return ClubEditScreen(profile: profile);
          case UserType.institute:
            return InstituteEditScreen(profile: profile);
          case UserType.other:
            return OtherEditScreen(profile: profile);
        }
      },
    );
  }
}