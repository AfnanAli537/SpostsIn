import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/my_ads_screen.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
import 'package:sports_in/features/main/chat/presentation/view/chat_view.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_detail_screen.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_list_screen.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/my_opportunity_list_screen.dart';
import 'package:sports_in/features/main/profile/view/presentation/connections_screen.dart';
import 'package:sports_in/features/main/profile/view/profile_section_factory.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../view_model/profile bloc/profile_bloc.dart';
import '../../view_model/profile bloc/profile_event.dart';
import '../../view_model/profile bloc/profile_state.dart';
import '../../model/profile_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_description.dart';
import '../widgets/profile_stats_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      context.read<ProfileBloc>().add(LoadUserProfile(userId: widget.userId!));
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
            backgroundColor: ColorManager.success,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
          );
        } else if (state is ProfileActionError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: ColorManager.error,
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
        } else if (state is ProfileLoaded) {
          return _buildProfileContent(
            state.profile,
            state.isOwnProfile,
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
      description: 'Loading description text that will be replaced',
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
      ads: [],
    );

    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
              profile: fakeProfile,
              theme: theme,
              isOwnProfile: false,
            ),
            ProfileDescription(description: fakeProfile.description),
            SizedBox(height: 16.h),
            ProfileStatsWidget(
              stats: fakeProfile.stats,
              theme: theme,
              string: S.of(context),
            ),
            Divider(height: 1, color: theme.colorScheme.onError),
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
          Icon(Icons.error_outline,
              size: 60.sp, color: theme.colorScheme.error),
          SizedBox(height: 16.h),
          Text(string.profileLoadFailed, textAlign: TextAlign.center),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.primary),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadProfile,
            child: Text(
              string.retry,
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(
    ProfileModel profile,
    bool isOwnProfile,
    ThemeData theme,
    S string,
  ) {
    return RefreshIndicator(
      onRefresh: () async => _loadProfile(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
  profile: profile,
  isOwnProfile: profile.isOwner,
  theme: theme,
  onEditPressed: profile.isOwner
      ? () => _navigateToEditProfile(context)
      : null,
      onchat: !profile.isOwner
    ? () async {
        final sharedPref = SharedPref(await SharedPreferences.getInstance());
        final currentUserId = sharedPref.getUserId();
        if (currentUserId == null) return;

        final chatModel = ChatModel(
          id: profile.id,
          title: profile.name,
          isGroup: false,
          members: [],
          lastMessage: null,
          lastMessageTime: null,
          unreadCount: 0,
          isOnline: false,
          groupPhoto: profile.profileImage,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(         
              create: (_) => getIt<ChatBloc>(),    
              child: ChatView(
                chat: chatModel,
                currentUserId: currentUserId,
              ),
            ),
          ),
        );
      }
    : null,
),
            ProfileDescription(description: profile.description),
            SizedBox(height: 8.h),
            ...ProfileSectionFactory.buildSections(
              profile: profile,
              isOwnProfile: isOwnProfile,
              theme: theme,
              string: string,
              isFollowing: profile.isFollowing,

              // ── Connections ───────────────────────────────────────────────
              onConnectionsPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConnectionsScreen(
                      isOwner: isOwnProfile,
                      userId: isOwnProfile ? null : profile.id,
                    ),
                  ),
                );
              },

              // ── Connect button ────────────────────────────────────────────
              onConnectPressed: () {
                final status = profile.connectionStatus;
                if (status == null) {
                  context.read<ProfileBloc>().add(
                        SendConnectionRequest(receiverId: profile.id),
                      );
                } else if (status == 'Accepted') {
                  context.read<ProfileBloc>().add(
                        RemoveContact(targetId: profile.id),
                      );
                }
              },

              // ── Follow button ─────────────────────────────────────────────
              onFollowPressed: () {
                context.read<ProfileBloc>().add(
                      ToggleFollow(userId: profile.id),
                    );
              },

              // ── Posts ─────────────────────────────────────────────────────
              onPostsShowAll: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.profilePostsListScreen,
                  arguments: {
                    'userId': profile.id,
                    'isCurrentUser': profile.isOwner,
                  },
                );
              },
              onPostTap: (post) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.profilePostsListScreen,
                  arguments: {
                    'userId': profile.id,
                    'isCurrentUser': profile.isOwner,
                  },
                );
              },

              // ── Opportunities ─────────────────────────────────────────────
              onOpportunitiesShowAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyOpportunitiesListScreen(
                      showActiveOnly: true,
                      isCurrentUser: profile.isOwner,
                    ),
                  ),
                );
              },
              onOpportunityTap: (opportunity) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyOpportunitiesListScreen(
                        showActiveOnly: true),
                  ),
                );
              },

              // ── Courses ───────────────────────────────────────────────────
              onCoursesShowAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => getIt<CoursesBloc>(),
                      child: const CourseListScreen(
                        listType: CourseListType.created,
                      ),
                    ),
                  ),
                );
              },
              onCourseTap: (course) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => getIt<CoursesBloc>(),
                      child: CourseDetailScreen(courseId: course.id),
                    ),
                  ),
                );
              },

              // ── Advertisements ────────────────────────────────────────────
              // "Show All" navigates to MyAdsScreen — only shown for owner
              // (AdsSection handles the isOwner check internally)
              onAdsShowAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyAdsScreen(
                      userId: profile.id,
                      isOwner: profile.isOwner,
                    ),
                  ),
                );
              },
              // Tapping a single ad thumbnail also goes to MyAdsScreen
              onAdTap: (ProfileAd ad) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyAdsScreen(
                      userId: profile.id,
                      isOwner: profile.isOwner,
                    ),
                  ),
                );
              },

              // ── Achievements ──────────────────────────────────────────────
              onAchievementsShowAll: () {},
              onAchievementTap: (achievement) {},

              // ── Videos ────────────────────────────────────────────────────
              onVideosShowAll: () {},
              onVideoTap: (video) {},

              // ── Interests ─────────────────────────────────────────────────
              onInterestsShowAll: () {},
              onConnectToggle: (interest) {},
              onFollowToggle: (interest) {
                context.read<ProfileBloc>().add(
                      ToggleFollow(userId: interest.id),
                    );
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
    Navigator.pushNamed(context, AppRoutes.editProfile);
  }

  void _navigateToUserProfile(BuildContext context, String userId) {
    Navigator.pushNamed(context, AppRoutes.userProfile, arguments: userId);
  }
}