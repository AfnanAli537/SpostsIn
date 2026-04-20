import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/home/view/widgets/full_screen_image.dart'; // ← import full-screen viewer

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  final bool isOwnProfile;
  final VoidCallback? onEditPressed;
  final VoidCallback? onchat;
  final ThemeData theme;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.isOwnProfile,
    this.onEditPressed,
    this.onchat,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = profile.profileImage != null && profile.profileImage!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.all(16.0.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: hasImage
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewer(
                          imageUrl: profile.profileImage!,
                        ),
                      ),
                    );
                  }
                : null, // no action when no image
            child: CircleAvatar(
              radius: 32,
              backgroundImage: hasImage
                  ? NetworkImage(profile.profileImage!)
                  : null,
              child: !hasImage
                  ? Text(
                      profile.name.isNotEmpty
                          ? profile.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        profile.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isOwnProfile && onEditPressed != null)
                      GestureDetector(
                        onTap: onEditPressed,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).edit,
                                style: TextStyle(
                                  color: theme.colorScheme.surface,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.edit,
                                color: theme.colorScheme.surface,
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!isOwnProfile && onchat != null)
                      GestureDetector(
                        onTap: onchat,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).chat,
                                style: TextStyle(
                                  color: theme.colorScheme.surface,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.chat,
                                color: theme.colorScheme.surface,
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.sports, size: 14.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      profile.role,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}