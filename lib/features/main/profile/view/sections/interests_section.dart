import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_event.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';
import '../../../../../core/widgets/connect_button.dart';
import '../../../../../core/widgets/follow_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InterestsSection extends StatelessWidget {
  final List<Interest> interests;
  final VoidCallback? onShowAll;
  final Function(Interest)? onFollowToggle;
  final Function(Interest)? onInterestTap;
  final ThemeData theme;
  final S string;

  const InterestsSection({
    Key? key,
    required this.interests,
    this.onShowAll,
    this.onFollowToggle,
    this.onInterestTap,
    required this.theme,
    required this.string,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (interests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: string.interests,
          onShowAllPressed: onShowAll,
        ),
        SizedBox(height: 16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: interests.length > 3 ? 3 : interests.length,
          itemBuilder: (context, index) {
            final interest = interests[index];
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
                      child: CircleAvatar(
                        radius: 32.r,
                        backgroundImage: interest.profileImage.isNotEmpty
                            ? NetworkImage(interest.profileImage)
                            : null,
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        child: interest.profileImage.isEmpty
                            ? Text(
                                interest.name.isNotEmpty
                                    ? interest.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              )
                            : null,
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
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  interest.role,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        theme.colorScheme.onTertiaryContainer,
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
                                      // Not connected → send request
                                      context.read<ProfileBloc>().add(
                                            SendConnectionRequest(
                                                receiverId: interest.id),
                                          );
                                    } else if (status == 'Accepted') {
                                      // Accepted → remove contact
                                      context.read<ProfileBloc>().add(
                                            RemoveContact(
                                                targetId: interest.id),
                                          );
                                    }
                                    // "Pending" → tap does nothing
                                  },
                                  connectText: string.connect,
                                  pendingText: 'Pending',
                                  removeContactText: 'Remove',
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: FollowButton(
                                  isFollowing: interest.isFollowing,
                                  onPressed: () =>
                                      onFollowToggle?.call(interest),
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
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}