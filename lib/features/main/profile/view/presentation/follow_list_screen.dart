import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/widgets/connect_button.dart';
import 'package:sports_in/core/widgets/custom_avatar.dart';
import 'package:sports_in/core/widgets/follow_button.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view/widgets/connections_shimmer.dart';
import 'package:sports_in/features/main/profile/view_model/follow_bloc/follow_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class FollowListScreen extends StatelessWidget {
  final String userId;
  final FollowListType type;

  const FollowListScreen({super.key, required this.userId, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FollowListBloc>()..add(LoadFollowList(userId, type)),
      child: FollowListView(userId: userId, type: type),
    );
  }
}

class FollowListView extends StatefulWidget {
  final String userId;
  final FollowListType type;
  const FollowListView({super.key, required this.userId, required this.type});

  @override
  State<FollowListView> createState() => _FollowListViewState();
}

class _FollowListViewState extends State<FollowListView> {
  final _scrollController = ScrollController();
  late final String currentUserId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final sharedPref = getIt<SharedPref>();
    currentUserId = sharedPref.getUserId() ?? '';
  }

  void _onScroll() {
    final pixels = _scrollController.position.pixels;
    final maxExtent = _scrollController.position.maxScrollExtent;
    if (pixels < maxExtent - 200) return;
    context.read<FollowListBloc>().add(LoadMoreFollowList());
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final title = widget.type == FollowListType.followers
        ? strings.followers
        : strings.following;
    final emptyMessage = widget.type == FollowListType.followers
        ? strings.noFollowersYet
        : strings.noFollowingYet;

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: BlocConsumer<FollowListBloc, FollowListState>(
        listener: (context, state) {
          if (state is FollowListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorManager.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FollowListLoading) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConnectionsShimmer(isOwner: false),
            );
          }
          if (state is FollowListError) {
            return _buildError(state.message);
          }
          if (state is FollowListLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FollowListBloc>().add(
                  LoadFollowList(widget.userId, widget.type),
                );
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  if (state.items.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 80.h),
                        child: Center(
                          child: Text(
                            emptyMessage,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: ColorManager.hintTextColor),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _FollowCard(
                            contact: state.items[index],
                            currentUserId: currentUserId,
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.userProfile,
                              arguments: state.items[index].userId,
                            ),
                            followText: widget.type == FollowListType.followers
                                ? strings.followBack
                                : strings.follow,
                          ),
                          childCount: state.items.length,
                        ),
                      ),
                    ),
                  if (state.isLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  if (!state.hasNextPage &&
                      !state.isLoadingMore &&
                      state.items.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Center(
                          child: Text(
                            strings.noMoreContacts,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: ColorManager.hintTextColor),
                          ),
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: ColorManager.error),
          SizedBox(height: 12.h),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<FollowListBloc>().add(
                LoadFollowList(widget.userId, widget.type),
              );
            },
            child: Text(S.of(context).retry),
          ),
        ],
      ),
    );
  }
}

// ── Card widget that uses FollowListBloc for actions ──────────────────────────
class _FollowCard extends StatelessWidget {
  final UserContactItem contact;
  final String currentUserId;
  final String? followText;
  final VoidCallback onTap;

  const _FollowCard({
    required this.contact,
    required this.currentUserId,
    this.followText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);
    final isCurrentUser = contact.userId == currentUserId;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomAvatar(
                    imageUrl: contact.profilePictureUrl,
                    name: contact.fullName,
                    radius: 32.r,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.fullName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (contact.bio != null) ...[
                          SizedBox(height: 4.h),
                          Text(contact.bio!, style: theme.textTheme.bodySmall),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onTertiaryContainer,
                    size: 22.sp,
                  ),
                ],
              ),
              if (!isCurrentUser) ...[
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: ConnectButton(
                        connectionStatus: contact.connectionStatus,
                        onPressed: () {
                          final status = contact.connectionStatus;
                          if (status == null) {
                            context.read<FollowListBloc>().add(
                              SendConnectionRequestOnItem(contact.userId),
                            );
                          } else if (status == 'Accepted') {
                            context.read<FollowListBloc>().add(
                              RemoveContactOnItem(contact.userId),
                            );
                          }
                        },
                        onAccept: () {
                          context.read<FollowListBloc>().add(
                            AcceptConnectionRequestOnItem(contact.userId),
                          );
                        },
                        onReject: () {
                          context.read<FollowListBloc>().add(
                            RejectConnectionRequestOnItem(contact.userId),
                          );
                        },
                        connectText: strings.connect,
                        pendingText: strings.pending,
                        removeContactText: strings.remove,
                        acceptText: strings
                            .accept, // optional, make sure strings.accept exists
                        rejectText: strings.reject, // optional
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: FollowButton(
                        isFollowing: contact.isFollowedByMe,
                        onPressed: () {
                          context.read<FollowListBloc>().add(
                            ToggleFollowOnItem(contact.userId),
                          );
                        },
                        followingText: strings.following,
                        followText: strings.follow,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
