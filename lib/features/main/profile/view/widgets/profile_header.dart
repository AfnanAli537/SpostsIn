import 'package:flutter/material.dart';
import '../../model/profile_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  final bool isOwnProfile;
  final VoidCallback? onEditPressed;
  final ThemeData theme;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.isOwnProfile,
    this.onEditPressed, 
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: profile.profileImage != null
                ? NetworkImage(profile.profileImage!)
                : null,
            child: profile.profileImage == null
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
                        onTap:
                            onEditPressed, 
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
                            mainAxisSize: MainAxisSize
                                .min, 
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: theme.colorScheme.surface,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ), // Adds a small gap between text and icon
                              Icon(
                                Icons.edit,
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
