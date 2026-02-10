import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_state.dart';
import 'package:sports_in/generated/l10n.dart';
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
    final string = S.of(context);
    final theme = Theme.of(context).colorScheme;
    
    return BlocConsumer<ProfileBloc, ProfileState>(
      // ✅ Listen for ProfileUpdated to navigate back
      listener: (context, state) {
        if (state is ProfileUpdated) {
          Fluttertoast.showToast(
              msg: 'Profile updated successfully',
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        // ✅ Show loading only when ProfileLoading
        if (state is ProfileLoading) {
          return Scaffold(
            body: Container(
              color: Colors.black26,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(height: 16.h),
                      Text(
                        string.updatingPost ?? 'Updating...',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // ✅ Get profile from state
        ProfileModel? profile;
        if (state is ProfileLoaded) {
          profile = state.profile;
        } else if (state is ProfileUpdated) {
          profile = state.profile;
        } else if (state is ProfileError) {
          // ✅ Show error screen
          return Scaffold(
            appBar: AppBar(title: Text(string.editProfile ?? 'Edit Profile')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ If no profile, show error
        if (profile == null) {
          return Scaffold(
            appBar: AppBar(title: Text(string.editProfile ?? 'Edit Profile')),
            body: Center(
              child: Text('No profile data available'),
            ),
          );
        }

        // ✅ Route to correct edit screen based on user type
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