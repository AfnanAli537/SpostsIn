import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/search_result_model.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResultModel result;
  final VoidCallback onTap;

  const SearchResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 24.r,
              backgroundColor: theme.colorScheme.surfaceVariant,
              backgroundImage: NetworkImage(result.profileImage),
              onBackgroundImageError: (_, __) {},
              child: result.profileImage.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 24.sp,
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            
            // Name and Role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    result.role,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _getRoleColor(theme),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Arrow Icon
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(ThemeData theme) {
    switch (result.userType) {
      case UserType.athlete:
        return theme.colorScheme.primary;
      case UserType.coach:
        return theme.colorScheme.secondary;
      case UserType.agent:
        return theme.colorScheme.tertiary;
      case UserType.scout:
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
}