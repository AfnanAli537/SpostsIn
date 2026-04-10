// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_state.dart';
import 'package:sports_in/features/notitification/presentation/notifi_screen.dart';
import 'package:sports_in/features/notitification/presentation/view_model/bloc/notification_bloc.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/core/config/theme_cubit/theme_cubit.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/widgets/custom_toggle_switch.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/login/model/login_response_model.dart'; // Ensure this is imported

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          _buildProfileHeader(theme, string),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                _buildMenuItem(
                  icon: Icons.notifications_none_rounded,
                  title: string.notifications,
                  onTap: () {
                    Navigator.pop(context);
                    _openNotifications(context);
                  },
                  theme: theme,
                ),
                SizedBox(height: 12.h),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: string.settings,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },
                  theme: theme,
                ),
                SizedBox(height: 12.h),
                _buildThemeToggle(theme, string),
                SizedBox(height: 12.h),
                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: string.aboutUs,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.about);
                  },
                  theme: theme,
                ),
                SizedBox(height: 12.h),
                _buildMenuItem(
                  icon: Icons.call_outlined,
                  title: string.contactUs,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.contactUs);
                  },
                  theme: theme,
                ),
              ],
            ),
          ),
          _buildLogoutButton(context, theme, string),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, S string) {
    return FutureBuilder<LoginResponse?>(
      future: getIt<SharedPref>().getUserFromPrefs(),
      builder: (context, snapshot) {
        final bool isLoading =
            snapshot.connectionState == ConnectionState.waiting;
        final user = snapshot.data;
        String name = user?.name != null
            ? user!.name!.firstName
            : (isLoading ? "Loading Name..." : "Guest User");

        String role =
            user?.userType ?? (isLoading ? "Loading Role..." : "No Role");

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(80.r)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
              child: Skeletonizer(
                enabled: isLoading,
                containersColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (prev, curr) =>
                          curr is ProfileLoaded || curr is ProfileLoading,
                      builder: (context, state) {
                        String? imageUrl;
                        if (state is ProfileLoaded) {
                          imageUrl = state.profile.profileImage;
                        }

                        return CircleAvatar(
                          radius: 35.r,
                          backgroundColor: theme.colorScheme.onPrimary
                              .withOpacity(0.2),
                          backgroundImage:
                              (imageUrl != null && imageUrl.isNotEmpty)
                              ? NetworkImage(imageUrl)
                              : null,
                          child: (imageUrl == null || imageUrl.isEmpty)
                              ? Icon(
                                  Icons.person,
                                  size: 40.r,
                                  color: theme.colorScheme.onPrimary,
                                )
                              : null,
                        );
                      },
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      role,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  // ... rest of the helper methods (_buildMenuItem, _buildThemeToggle, etc. remain the same)

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.onError.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurface, size: 22.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(ThemeData theme, S string) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onError.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.dark_mode_outlined,
            color: theme.colorScheme.onSurface,
            size: 22.sp,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              string.theme,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                ThemeMode activeMode = themeMode;
                if (themeMode == ThemeMode.system) {
                  activeMode =
                      MediaQuery.platformBrightnessOf(context) ==
                          Brightness.dark
                      ? ThemeMode.dark
                      : ThemeMode.light;
                }

                return CustomAnimatedToggle<ThemeMode>(
                  values: const [ThemeMode.dark, ThemeMode.light],
                  initialValue: activeMode,
                  onChanged: (mode) =>
                      context.read<ThemeCubit>().setTheme(mode),
                  height: 36,
                  indicatorWidth: 45,
                  iconBuilder: (mode, isSelected) {
                    return Icon(
                      mode == ThemeMode.light
                          ? Icons.wb_sunny_rounded
                          : Icons.dark_mode_rounded,
                      color: isSelected
                          ? theme.colorScheme.onTertiaryContainer
                          : theme.colorScheme.onSurface,
                      size: 18.sp,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ThemeData theme, S string) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        onTap: () async {
          Navigator.pop(context);
          await Future.delayed(const Duration(milliseconds: 250));
          if (context.mounted) {
            _showLogoutDialog(context, theme, string);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                string.logout,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: ColorManager.lightSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.logout_rounded,
                color: ColorManager.lightSurface,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ThemeData theme, S string) {
    final rootNavigator = Navigator.of(context, rootNavigator: true);

    ConfirmationDialog.show(
      context: context,
      title: string.logout,
      message: string.logoutConfirmation,
      confirmText: string.confirm,
      cancelText: string.cancel,
      icon: Icons.logout_rounded,
      iconColor: theme.colorScheme.error,
      isDestructive: true,
      onConfirm: () async {
        // await getIt<SharedPref>().clear(); // Use clear() to wipe all user data
        await getIt<SharedPref>()
            .clearToken(); // Use clear() to wipe all user data
        rootNavigator.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      },
    );
  }

  void _openNotifications(BuildContext context) {
    final bloc = context.read<NotificationBloc>();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => NotificationScreen(notificationBloc: bloc),
      ),
    );
  }
}
