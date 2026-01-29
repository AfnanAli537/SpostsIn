import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/profile_bloc.dart';
import '../view_model/profile_event.dart';
import '../view_model/profile_state.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_description.dart';
import 'widgets/profile_stats_widget.dart';
import 'profile_section_factory.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({Key? key, this.userId}) : super(key: key);

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
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              _showMoreOptions(context);
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is ProfileActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
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
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
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

                    const SizedBox(height: 16),

                    ProfileStatsWidget(
                      stats: profile.stats,
                      onFollowersPressed: () {},
                      onFollowingPressed: () {},
                      onConnectionsPressed: () {},
                      onAnalyzedPeoplePressed: () {},
                    ),

                    const Divider(height: 1),
                    const SizedBox(height: 16),

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
                            context.read<ProfileBloc>().add(
                              FollowUser(interest.id),
                            );
                          } else {
                            context.read<ProfileBloc>().add(
                              UnfollowUser(interest.id),
                            );
                          }
                        },
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    // Navigate to edit profile screen
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share Profile'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Copy Profile Link'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('Show QR Code'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              if (widget.userId != null) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: const Text(
                    'Block User',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.report, color: Colors.red),
                  title: const Text(
                    'Report User',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
