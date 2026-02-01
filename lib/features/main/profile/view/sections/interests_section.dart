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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: interests.length > 6 ? 6 : interests.length,
          itemBuilder: (context, index) {
            final interest = interests[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => onInterestTap?.call(interest),
                    child: CircleAvatar(
                      radius: 24.r,
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
                                fontSize: 18.sp,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onInterestTap?.call(interest),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            interest.name,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            interest.role,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildActionButton(
                    label: interest.isConnected ? string.connected : string.connect,
                    isActive: interest.isConnected,
                    onPressed: () => onConnectToggle?.call(
                      interest,
                      !interest.isConnected,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _buildActionButton(
                    label: interest.isFollowing ? string.following : string.follow,
                    isActive: interest.isFollowing,
                    isPrimary: true,
                    onPressed: () => onFollowToggle?.call(
                      interest,
                      !interest.isFollowing,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: (isPrimary && !isActive)
            ? theme.colorScheme.primary
            : Colors.transparent,
        foregroundColor: (isPrimary && !isActive)
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.primary,
        side: BorderSide(
          color: theme.colorScheme.primary,
          width: 1.5.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        minimumSize: Size(80.w, 32.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}