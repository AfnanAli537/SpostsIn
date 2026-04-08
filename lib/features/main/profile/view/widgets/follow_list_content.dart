// follow_list_content.dart (or inside each screen)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/widgets/connect_button.dart';
import 'package:sports_in/core/widgets/custom_avatar.dart';
import 'package:sports_in/core/widgets/follow_button.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_event.dart';
import 'package:sports_in/generated/l10n.dart';

class FollowListContent extends StatelessWidget {
  final List<UserContactItem> items;
  final bool hasNextPage;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final VoidCallback onRefresh;
  final String currentUserId;

  const FollowListContent({
    super.key,
    required this.items,
    required this.hasNextPage,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onRefresh,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: CustomScrollView(
        controller: null, // You'll pass controller from parent
        slivers: [
          if (items.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 80.h),
                child: Center(
                  child: Text(
                    strings.noFollowersYet, // or noFollowingYet – we'll pass externally
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ColorManager.hintTextColor,
                    ),
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
                    contact: items[index],
                    currentUserId: currentUserId,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.userProfile,
                      arguments: items[index].userId,
                    ),
                  ),
                  childCount: items.length,
                ),
              ),
            ),
          if (isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          if (!hasNextPage && !isLoadingMore && items.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Center(
                  child: Text(
                    S.of(context).noMoreContacts,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ColorManager.hintTextColor,
                    ),
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        ],
      ),
    );
  }
}

class _FollowCard extends StatelessWidget {
  final UserContactItem contact;
  final String currentUserId;
  final VoidCallback onTap;

  const _FollowCard({
    required this.contact,
    required this.currentUserId,
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
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (contact.bio != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            contact.bio!,
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: theme.colorScheme.onTertiaryContainer, size: 22.sp),
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
                            context.read<ProfileBloc>().add(
                                  SendConnectionRequest(receiverId: contact.userId),
                                );
                          } else if (status == 'Accepted') {
                            context.read<ProfileBloc>().add(
                                  RemoveContact(targetId: contact.userId),
                                );
                          }
                        },
                        connectText: strings.connect,
                        pendingText: strings.pending,
                        removeContactText: strings.remove,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: FollowButton(
                        isFollowing: contact.isFollowedByMe,
                        onPressed: () {
                          context.read<ProfileBloc>().add(
                                ToggleFollow(userId: contact.userId),
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