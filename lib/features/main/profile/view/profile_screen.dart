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
            ProfileHeader(profile: fakeProfile, isOwnProfile: false),
            ProfileDescription(description: fakeProfile.description),
            const SizedBox(height: 16),
            ProfileStatsWidget(stats: fakeProfile.stats, theme: theme, string: S.of(context)),
            Divider(height: 1, color: theme.dividerColor),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 150,
                    color: theme.colorScheme.surfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 100,
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
            size: 60,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading profile',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
              profile: profile,
              isOwnProfile: isOwnProfile,
              onEditPressed: isOwnProfile ? () => _navigateToEditProfile(context) : null,
              // onProfileImageTap: widget.userId != null
              //     ? () => _navigateToUserProfile(context, profile.id)
              //     : null,
            ),
            ProfileDescription(description: profile.description),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else
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
                  // _navigateToUserProfile(context, interest.id);
                },
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    // Navigate to edit profile screen
  }

  // void _navigateToUserProfile(BuildContext context, String userId) {
  //   // Navigate to another user's profile
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Scaffold(
  //         appBar: AppBar(title: Text(S.of(context).profile)),
  //         body: BlocProvider(
  //           create: (context) => ProfileBloc(
  //             context.read<ProfileBloc>().profileRepo,
  //           ),
  //           child: ProfileScreen(userId: userId),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}