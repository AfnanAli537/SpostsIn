import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_event.dart';
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
      listener: (context, state) {
        if (state is ProfileUpdated) {
          Fluttertoast.showToast(
            msg: string.editProfileSuccess,
            backgroundColor: ColorManager.success,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        // Show loading only when ProfileLoading
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
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 250.w),
                        child: Text(
                          string.loading,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.onSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        //Get profile from state
        ProfileModel? profile;
        if (state is ProfileLoaded) {
          profile = state.profile;
        } else if (state is ProfileUpdated) {
          profile = state.profile;
        } else if (state is ProfileError) {
          //Show error screen with retry button
          return Scaffold(
            appBar: AppBar(
              title: Text(string.editProfile),
              leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Theme.of(context).colorScheme.onError,
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
              ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64.sp, color: ColorManager.error),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        // Retry loading the profile
                        context.read<ProfileBloc>().add(LoadMyProfile());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                      ),
                      child: Text(
                        string.retry,
                        style: TextStyle(color: theme.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // If no profile, show error (fallback)
        if (profile == null) {
          return Scaffold(
            appBar: AppBar(title: Text(string.editProfile)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(string.noProfileData),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileBloc>().add(LoadMyProfile()),
                    child: Text(string.retry),
                  ),
                ],
              ),
            ),
          );
        }

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