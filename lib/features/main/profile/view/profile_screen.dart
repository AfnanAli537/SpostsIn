import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/generated/l10n.dart';
import '../view_model/profile_bloc.dart';
import '../view_model/profile_event.dart';
import '../view_model/profile_state.dart';
import '../model/profile_model.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_description.dart';
import 'widgets/profile_stats_widget.dart';
import 'profile_section_factory.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    if (widget.userId == null) {
      context.read<ProfileBloc>().add(LoadMyProfile());
    } else {
      context.read<ProfileBloc>().add(LoadUserProfile(widget.userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileActionSuccess) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
          );
        } else if (state is ProfileActionError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return _buildShimmerLoading(theme);
        } else if (state is ProfileError) {
          return _buildErrorState(state.message, theme, string);
        } else if (state is ProfileLoaded ||
            state is ProfileActionLoading ||
            state is ProfileActionSuccess ||
            state is ProfileActionError) {
          final profile = state is ProfileLoaded
              ? state.profile
              : state is ProfileActionLoading
                  ? state.profile
                  : state is ProfileActionSuccess
                      ? state.profile
                      : (state as ProfileActionError).profile;

          final isOwnProfile = state is ProfileLoaded ? state.isOwnProfile : false;
          final isLoading = state is ProfileActionLoading;

          return _buildProfileContent(
            profile,
            isOwnProfile,
            isLoading,
            theme,
            string,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerLoading(ThemeData theme) {
    final fakeProfile = ProfileModel(
      id: 'loading',
      name: 'Loading Name',
      role: 'Loading Role',
      description: 'Loading description text that will be replaced with actual content',
      userType: UserType.player,
      stats: ProfileStats(
        followers: '0',
        following: '0',
        connections: '0',
        analyzedPeople: '0',
      ),
      posts: [],
      achievements: [],
      analyzedVideos: [],
      interests: [],
    );

    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(profile: fakeProfile, theme: theme, isOwnProfile: false),
            ProfileDescription(description: fakeProfile.description),
            SizedBox(height: 16.h),
            ProfileStatsWidget(stats: fakeProfile.stats, theme: theme, string: S.of(context)),
            Divider(height: 1, color: theme.dividerColor),
            SizedBox(height: 16.h),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20.h,
                    width: 150.w,
                    color: theme.colorScheme.surfaceVariant,
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 100.h,
                    width: double.infinity,
                    color: theme.colorScheme.surfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, ThemeData theme, S string) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60.sp,
            color: theme.colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error loading profile',
            style: theme.textTheme.headlineMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadProfile,
            child: Text(string.done),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(
    ProfileModel profile,
    bool isOwnProfile,
    bool isLoading,
    ThemeData theme,
    S string,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadProfile();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: isLoading
            ? _buildShimmerLoading(theme)
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
              profile: profile,
              isOwnProfile: isOwnProfile,
              theme: theme,
              onEditPressed: isOwnProfile ? () => _navigateToEditProfile(context) : null,
              // onProfileImageTap: widget.userId != null
              //     ? () => _navigateToUserProfile(context, profile.id)
              //     : null,
            ),
            ProfileDescription(description: profile.description),
            SizedBox(height: 8.h),
            
              ...ProfileSectionFactory.buildSections(
                profile: profile,
                isOwnProfile: isOwnProfile,
                theme: theme,
                string: string,
                onPostsShowAll: () {},
                onOpportunitiesShowAll: () {},
                onCoursesShowAll: () {},
                onAchievementsShowAll: () {},
                onVideosShowAll: () {},
                onInterestsShowAll: () {},
                onPostTap: (post) {},
                onOpportunityTap: (opportunity) {},
                onCourseTap: (course) {},
                onAchievementTap: (achievement) {},
                onVideoTap: (video) {},
                onConnectPressed: () {
                  context.read<ProfileBloc>().add(ConnectWithUser(profile.id));
                },
                onFollowPressed: () {
                  context.read<ProfileBloc>().add(FollowUser(profile.id));
                },
                onConnectToggle: (interest, shouldConnect) {
                  if (shouldConnect) {
                    context.read<ProfileBloc>().add(ConnectWithUser(interest.id));
                  } else {
                    context.read<ProfileBloc>().add(DisconnectFromUser(interest.id));
                  }
                },
                onFollowToggle: (interest, shouldFollow) {
                  if (shouldFollow) {
                    context.read<ProfileBloc>().add(FollowUser(interest.id));
                  } else {
                    context.read<ProfileBloc>().add(UnfollowUser(interest.id));
                  }
                },
                onInterestTap: (interest) {
                  _navigateToUserProfile(context, interest.id);
                },
              ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    // Navigate to edit profile screen
  }

  void _navigateToUserProfile(BuildContext context, String userId) {
    // // Navigate using named route
    // Navigator.pushNamed(
    //   context,
    //   AppRoutes.userProfile,
    //   arguments: userId,
    // );
  }

}