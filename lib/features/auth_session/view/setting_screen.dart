import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/config/language_cubit/language_cubit.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/widgets/custom_toggle_switch.dart';
import 'package:sports_in/features/auth_session/view/account_switcher_screen.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/my_opportunity_list_screen.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  LoginResponse? _currentUser;
    final sharedPref = getIt<SharedPref>();
  bool _pushNotifications = false;
  String? get _currentUserId => sharedPref.getUserId();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await getIt<SharedPref>().getUserFromPrefs();
    setState(() {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(string.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Language Section
          _buildSectionTitle('Language', theme),
          SizedBox(height: 8.h),
          _buildLanguageCard(theme, string),
          SizedBox(height: 48.h),

          // // Notifications Section
          // _buildSectionTitle(string.notifications, theme),
          // SizedBox(height: 8.h),
          // _buildNotificationCard(theme, string),
          // SizedBox(height: 24.h),

          // Personal Info Section
          _buildSectionTitle('Personal Info', theme),
          SizedBox(height: 8.h),
          _buildPersonalInfoCards(theme, string),
          SizedBox(height: 48.h),

          // Account Section
          _buildSectionTitle('Account', theme),
          SizedBox(height: 8.h),
          _buildAccountCard(theme, string),
          SizedBox(height: 48.h),

          // Subscription Section
          _buildSectionTitle('Subscription', theme),
          SizedBox(height: 8.h),
          _buildSubscriptionCard(theme, string),
          SizedBox(height: 48.h),

          // Activities Section
          _buildSectionTitle('Activities', theme),
          SizedBox(height: 8.h),
          _buildActivitiesCards(theme, string),
          SizedBox(height: 48.h),

          // Switch Account Button
          _buildSwitchAccountButton(theme, string),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildLanguageCard(ThemeData theme, S string) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'English',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return CustomAnimatedToggle<String>(
                values: const ["en", "ar"],
                initialValue: locale.languageCode,
                onChanged: (lang) {
                  context.read<LocaleCubit>().setLocale(Locale(lang));
                },
                height: 36.h,
                indicatorWidth: 45.w,
                iconBuilder: (value, isSelected) {
                  final borderColor = isSelected
                      ? ColorManager.borderCircular
                      : Colors.transparent;
                  final imagePath = value == "en"
                      ? IconAssets.us
                      : IconAssets.eg;

                  return Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor,
                        width: 1.w,
                      ),
                    ),
                    child: Image.asset(
                      imagePath,
                      width: 20.w,
                      height: 20.h,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildNotificationCard(ThemeData theme, S string) {
  //   return Container(
  //     padding: EdgeInsets.all(16.r),
  //     decoration: BoxDecoration(
  //       color: theme.colorScheme.surface,
  //       borderRadius: BorderRadius.circular(12.r),
  //       border: Border.all(
  //         color: theme.colorScheme.outline.withOpacity(0.2),
  //       ),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Push Notifications',
  //               style: theme.textTheme.bodyLarge?.copyWith(
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             SizedBox(height: 4.h),
  //             Text(
  //               'Receive push notifications for new\nmessages, match updates and more',
  //               style: theme.textTheme.bodySmall?.copyWith(
  //                 color: Colors.grey[600],
  //               ),
  //             ),
  //           ],
  //         ),
  //         Switch(
  //           value: _pushNotifications,
  //           onChanged: (value) {
  //             setState(() => _pushNotifications = value);
  //             // TODO: Implement notification toggle logic
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPersonalInfoCards(ThemeData theme, S string) {
    return Column(
      children: [
        _buildInfoCard(
          label: 'Email',
          value: _currentUser?.email ?? 'email@example.com',
          icon: Icons.email_outlined,
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildInfoCard(
          label: 'Password',
          value: '••••••••',
          icon: Icons.lock_outline,
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildInfoCard(
          label: 'User Type',
          value: _currentUser?.userType ?? 'Other',
          icon: Icons.person_outline,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (label == 'Password')
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20.sp,
            ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(ThemeData theme, S string) {
    return _buildNavigationCard(
      title: 'Change Password',
      subtitle: 'Update your current password for enhanced\nsecurity',
      icon: Icons.key_outlined,
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.otp, arguments: _currentUser?.email);
      },
      theme: theme,
    );
  }

  Widget _buildSubscriptionCard(ThemeData theme, S string) {
    return _buildNavigationCard(
      title: 'Manage Subscription',
      subtitle: 'Update your current password for enhanced\nsecurity',
      icon: Icons.card_membership_outlined,
      onTap: () {
        // TODO: Navigate to subscription screen
      },
      theme: theme,
    );
  }

  Widget _buildActivitiesCards(ThemeData theme, S string) {
    return Column(
      children: [
        _buildNavigationCard(
          title: 'Manage Posts',
          subtitle: 'Update your current password for enhanced\nsecurity',
          icon: Icons.article_outlined,
          onTap: () {
            // Navigator.pushNamed(context, AppRoutes.managePosts);
            Navigator.pushNamed(
                  context,
                  AppRoutes.profilePostsListScreen,
                  arguments: {
                    'userId':_currentUserId,
                    'isCurrentUser': true,
                  },
                );
          },
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildNavigationCard(
          title: 'Manage Opportunity',
          subtitle: 'Update your current password for enhanced\nsecurity',
          icon: Icons.work_outline,
          onTap: () {
            // Navigator.pushNamed(context, AppRoutes.manageOpportunities);
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyOpportunitiesListScreen(
                      showActiveOnly: true, // or false for inactive
                    ),
                  ),
                );
          },
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildNavigationCard(
          title: 'Manage course',
          subtitle: 'Update your current password for enhanced\nsecurity',
          icon: Icons.school_outlined,
          onTap: () {
            // Navigator.pushNamed(context, AppRoutes.manageCourses);
          },
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildNavigationCard(
          title: 'Manage video analysis people',
          subtitle: 'Update your current password for enhanced\nsecurity',
          icon: Icons.video_library_outlined,
          onTap: () {
            // TODO: Navigate to video analysis screen
          },
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildNavigationCard(
          title: 'Manage advertisement',
          subtitle: 'Update your current password for enhanced\nsecurity',
          icon: Icons.campaign_outlined,
          onTap: () {
            // TODO: Navigate to advertisement screen
          },
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildNavigationCard(
          title: 'Manage achievement',
          subtitle: 'Update your current password for enhanced\nsecurity',
          icon: Icons.emoji_events_outlined,
          onTap: () {
            // Navigator.pushNamed(context, AppRoutes.manageAchievements);
          },
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildNavigationCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchAccountButton(ThemeData theme, S string) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: OutlinedButton.icon(
      onPressed: () {
        AccountSwitcherBottomSheet.show(context);
      },
      icon: Icon(Icons.swap_horiz, size: 20.sp),
      label: const Text('Switch account'),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        side: BorderSide(color: theme.colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
  );
}
}