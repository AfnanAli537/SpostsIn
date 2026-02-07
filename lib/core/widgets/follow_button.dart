import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onPressed;
  final String followingText;
  final String followText;

  const FollowButton({
    Key? key,
    required this.isFollowing,
    required this.onPressed,
    this.followingText = 'Following',
    this.followText = 'Follow',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isFollowing
            ? Colors.transparent
            : theme.colorScheme.primary,
        foregroundColor: isFollowing
            ? theme.colorScheme.primary
            : theme.colorScheme.onPrimary,
        side: isFollowing
            ? BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5.w,
              )
            : null,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        isFollowing ? followingText : followText,
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