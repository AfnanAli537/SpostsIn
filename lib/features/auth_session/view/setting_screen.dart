import 'package:flutter/cupertino.dart';
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
import 'package:sports_in/features/main/advertisement/view/presentation/my_ads_screen.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_list_screen.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/my_opportunity_list_screen.dart';
import 'package:sports_in/features/main/profile/view/presentation/achievement/achievements_list_screen.dart';
import 'package:sports_in/features/main/video_analysis/view/presentation/analyzed_users_screen.dart';
import 'package:sports_in/features/main/video_analysis/view_model/video_analysis_bloc/analysis_bloc.dart';
import 'package:sports_in/features/payment/presentation/subscription_screen.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
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
  String? get _currentUserId => sharedPref.getUserId();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await getIt<SharedPref>().getUserFromPrefs();
    setState(() => _currentUser = user);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text(string.settings)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(string.settings), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildSectionTitle(string.selectLanguage, theme),
          SizedBox(height: 8.h),
          _buildLanguageCard(theme, string),
          SizedBox(height: 48.h),
          _buildSectionTitle(string.personalInfo, theme),
          SizedBox(height: 8.h),
          _buildPersonalInfoCards(theme, string),
          SizedBox(height: 48.h),
          _buildSectionTitle(string.account, theme),
          SizedBox(height: 8.h),
          _buildAccountCard(theme, string),
          SizedBox(height: 48.h),
          _buildSectionTitle(string.subscription, theme),
          SizedBox(height: 8.h),
          _buildSubscriptionCard(theme, string),
          SizedBox(height: 48.h),
          _buildSectionTitle(string.activities, theme),
          SizedBox(height: 8.h),
          _buildActivitiesCards(theme, string),
          SizedBox(height: 48.h),
          _buildSwitchAccountButton(theme, string),
        ],
      ),
    );
  }

  // ─── Section title ──────────────────────────────────────────────────────

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  // ─── Language ───────────────────────────────────────────────────────────

  Widget _buildLanguageCard(ThemeData theme, S string) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            string.selectLanguage,
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
                      border: Border.all(color: borderColor, width: 1.w),
                    ),
                    child: Image.asset(imagePath, width: 20.w, height: 20.h),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Personal info ──────────────────────────────────────────────────────

  Widget _buildPersonalInfoCards(ThemeData theme, S string) {
    return Column(
      children: [
        _buildInfoCard(
          label: string.email,
          value: _currentUser?.email ?? 'email@example.com',
          icon: Icons.email_outlined,
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildInfoCard(
          label: string.password,
          value: '••••••••',
          icon: Icons.lock_outline,
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildInfoCard(
          label: string.userType,
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
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
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
          // if (label == 'Password')
          //   Icon(Icons.chevron_right,
          //       color: Colors.grey[400], size: 20.sp),
        ],
      ),
    );
  }

  // ─── Account ────────────────────────────────────────────────────────────

  Widget _buildAccountCard(ThemeData theme, S string) {
    return _buildNavigationCard(
      title: string.changePassword,
      icon: Icons.key_outlined,
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.otp,
        arguments: _currentUser?.email,
      ),
      theme: theme,
    );
  }

  // ─── Subscription ────────────────────────────────────────────────────────
  // Navigates to SubscriptionScreen with its required PaymentBloc.
  // showCloseButton: false  →  no X button; the AppBar back arrow is enough.

  Widget _buildSubscriptionCard(ThemeData theme, S string) {
    return _buildNavigationCard(
      title: string.manageSubscription,
      icon: Icons.card_membership_outlined,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => getIt<PaymentBloc>(),
              child: const SubscriptionScreen(
                showCloseButton: false, // Back arrow handles dismissal
              ),
            ),
          ),
        );
      },
      theme: theme,
    );
  }

  // ─── Activities ──────────────────────────────────────────────────────────

  Widget _buildActivitiesCards(ThemeData theme, S string) {
    return Column(
      children: [
        _buildNavigationCard(
          title: string.managePosts,
          icon: Icons.article_outlined,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.profilePostsListScreen,
            arguments: {'userId': _currentUserId, 'isCurrentUser': true},
          ),
          theme: theme,
        ),
        SizedBox(height: 12.h),
        if (_currentUser!.userType == 'Coach' ||
            _currentUser!.userType == 'Scout' ||
            _currentUser!.userType == 'Club') ...[
          _buildNavigationCard(
            title: string.manageOpportunities,
            icon: Icons.work_outline,
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => MyOpportunitiesListScreen(showActiveOnly: true),
              ),
            ),
            theme: theme,
          ),
          SizedBox(height: 12.h),
        ],
        _buildNavigationCard(
          title: string.manageCourse,
          icon: Icons.school_outlined,
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => getIt<CoursesBloc>(),
                child: CourseListScreen(
                  listType:
                      (_currentUser!.userType == 'Coach' ||
                          // _currentUser!.userType == 'Scout' ||
                          _currentUser!.userType == 'Club')
                      ? CourseListType.created
                      : CourseListType.enrolled,
                ),
              ),
            ),
          ),
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildNavigationCard(
          title: string.manageAdvertisement,
          icon: Icons.campaign_outlined,
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => const MyAdsScreen()),
          ),
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildNavigationCard(
          title: string.manageVideoAnalysis,
          icon: Icons.video_library_outlined,
          onTap: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => getIt<AnalysisBloc>()
                        ..add(const LoadAnalyzedUsers()),
                      child: const AnalyzedUsersScreen(),
                    ),
                  ),
                );
          },
          theme: theme,
        ),
        SizedBox(height: 12.h),
        _buildNavigationCard(
          title: string.manageAchievement,
          icon: Icons.emoji_events_outlined,
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AchievementsListScreen(
                userId: _currentUser!.userId!,
                isCurrentUser: true,
              ),
            ),
          ),
          theme: theme,
        ),
      ],
    );
  }

  // ─── Reusable nav card ───────────────────────────────────────────────────

  Widget _buildNavigationCard({
    required String title,
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
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
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
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20.sp),
          ],
        ),
      ),
    );
  }

  // ─── Switch account ──────────────────────────────────────────────────────

  Widget _buildSwitchAccountButton(ThemeData theme, S string) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: OutlinedButton.icon(
        onPressed: () => AccountSwitcherBottomSheet.show(context),
        icon: Icon(Icons.swap_horiz, size: 20.sp),
        label: Text(string.switchAccount),
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
