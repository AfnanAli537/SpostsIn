import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        // elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu_rounded, color: Colors.black),
        //   onPressed: () => {},
        // ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.notifications, color: Colors.black),
        //     onPressed: () {
        //       //Todo notifications screen
        //     },
        //   ),
        // ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileActionSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.message),
            //     backgroundColor: Colors.green,
            //     duration: const Duration(seconds: 2),
            //   ),
            // );
          } else if (state is ProfileActionError) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.message),
            //     backgroundColor: Colors.red,
            //     duration: const Duration(seconds: 2),
            //   ),
            // );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return _buildShimmerLoading();
          } else if (state is ProfileError) {
            return _buildErrorState(state.message);
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

            final isOwnProfile = state is ProfileLoaded
                ? state.isOwnProfile
                : false;

            final isLoading = state is ProfileActionLoading;

            return _buildProfileContent(profile, isOwnProfile, isLoading);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    // Create a fake profile for shimmer
    final fakeProfile = ProfileModel(
      id: 'loading',
      name: 'Loading Name',
      role: 'Loading Role',
      description:
          'Loading description text that will be replaced with actual content',
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
            ProfileStatsWidget(stats: fakeProfile.stats),
            const Divider(height: 1,color: Colors.grey,),
            const SizedBox(height: 16),

            // Shimmer for sections
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20, width: 150, color: Colors.grey),
                  const SizedBox(height: 12),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 24),
                  Container(height: 20, width: 120, color: Colors.grey),
                  const SizedBox(height: 12),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Error loading profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _loadProfile, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildProfileContent(
    ProfileModel profile,
    bool isOwnProfile,
    bool isLoading,
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
              onEditPressed: isOwnProfile
                  ? () => _navigateToEditProfile(context)
                  : null,
            ),

            ProfileDescription(description: profile.description),


            // Show Connect and Follow buttons for other users
            // if (!isOwnProfile)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
            //     child: Row(
            //       children: [
            //         Expanded(
            //           child: OutlinedButton(
            //             onPressed: () {
            //               // Handle connect
            //             },
            //             style: OutlinedButton.styleFrom(
            //               side: const BorderSide(color: Color(0xFF1E3A5F)),
            //               padding: const EdgeInsets.symmetric(vertical: 12),
            //             ),
            //             child: const Text(
            //               'Connect',
            //               style: TextStyle(
            //                 color: Color(0xFF1E3A5F),
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //           ),
            //         ),
            //         const SizedBox(width: 12),
            //         Expanded(
            //           child: ElevatedButton(
            //             onPressed: () {
            //               // Handle follow
            //             },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: const Color(0xFF1E3A5F),
            //               padding: const EdgeInsets.symmetric(vertical: 12),
            //             ),
            //             child: const Text(
            //               'Follow',
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),

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
                isOwnProfile:isOwnProfile,
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
                onConnectToggle: (interest, shouldConnect) {
                  if (shouldConnect) {
                    context.read<ProfileBloc>().add(
                      ConnectWithUser(interest.id),
                    );
                  } else {
                    context.read<ProfileBloc>().add(
                      DisconnectFromUser(interest.id),
                    );
                  }
                },
                onFollowToggle: (interest, shouldFollow) {
                  if (shouldFollow) {
                    context.read<ProfileBloc>().add(FollowUser(interest.id));
                  } else {
                    context.read<ProfileBloc>().add(UnfollowUser(interest.id));
                  }
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
}