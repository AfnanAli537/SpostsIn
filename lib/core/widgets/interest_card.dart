import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/widgets/connect_button.dart';
import 'package:sports_in/core/widgets/custom_avatar.dart';
import 'package:sports_in/core/widgets/follow_button.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_event.dart';
import 'package:sports_in/generated/l10n.dart';

class InterestCard extends StatelessWidget {
  final Interest interest;
  final Function(Interest)? onFollowToggle;
  final Function(Interest)? onInterestTap;

  const InterestCard({
    super.key,
    required this.interest,
    this.onFollowToggle,
    this.onInterestTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return Container(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => onInterestTap?.call(interest),
              child: CustomAvatar(
                imageUrl: interest.profileImage,
                name: interest.name,
                radius: 32.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => onInterestTap?.call(interest),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          interest.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          interest.role,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: ConnectButton(
                          connectionStatus: interest.connectionStatus,
                          onPressed: () {
                            final status = interest.connectionStatus;
                            if (status == null) {
                              context.read<ProfileBloc>().add(
                                    SendConnectionRequest(receiverId: interest.id),
                                  );
                            } else if (status == 'Accepted') {
                              context.read<ProfileBloc>().add(
                                    RemoveContact(targetId: interest.id),
                                  );
                            }
                          },
                          connectText: string.connect,
                          pendingText: string.pending,
                          removeContactText: string.remove,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FollowButton(
                          isFollowing: interest.isFollowing,
                          onPressed: () => onFollowToggle?.call(interest),
                          followingText: string.following,
                          followText: string.follow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}