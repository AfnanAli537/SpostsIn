import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InterestsSection extends StatelessWidget {
  final List<Interest> interests;
  final VoidCallback? onShowAll;
  final Function(Interest, bool)? onConnectToggle;
  final Function(Interest, bool)? onFollowToggle;
  final Function(Interest)? onInterestTap;
  final ThemeData theme;
  final S string;

  const InterestsSection({
    Key? key,
    required this.interests,
    this.onShowAll,
    this.onConnectToggle,
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
                                    color: theme.colorScheme.onTertiary,
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
                                child: _buildConnectButton(
                                  isConnected: interest.isConnected,
                                  onPressed: () => onConnectToggle?.call(
                                    interest,
                                    !interest.isConnected,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _buildFollowButton(
                                  isFollowing: interest.isFollowing,
                                  onPressed: () => onFollowToggle?.call(
                                    interest,
                                    !interest.isFollowing,
                                  ),
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

  Widget _buildConnectButton({
    required bool isConnected,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: isConnected
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.primary,
        side: BorderSide(
          color: isConnected
              ? theme.colorScheme.outline
              : theme.colorScheme.primary,
          width: 1.w,
        ),
        padding: EdgeInsets.symmetric(vertical: 6.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        isConnected ? string.connected : string.connect,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color:isConnected
            ? theme.colorScheme.outline
            : theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildFollowButton({
    required bool isFollowing,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isFollowing
            ? Colors.transparent
            : theme.colorScheme.primary,
        foregroundColor: isFollowing
            ? theme.colorScheme.primary
            : theme.colorScheme.onTertiary,
        side: isFollowing
            ? BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5.w,
              )
            : null,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        isFollowing ? string.following : string.follow,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isFollowing
            ? theme.colorScheme.primary
            : theme.colorScheme.onSecondaryFixed,
        ),
      ),
    );
  }
}