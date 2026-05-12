import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/widgets/custom_avatar.dart';
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CustomAvatar(
                imageUrl: result.profileImage,
                name: result.name,
                radius: 32.r,
              ),
              SizedBox(width: 16.w),

              // Name + Role + Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      result.role,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (result.location != null) ...[
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14.sp,
                            color: theme.colorScheme.onTertiaryContainer,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            result.location!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onTertiaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

             // Replace the age badge at the end with this:
Column(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    if (result.age != null)
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          '${result.age}y',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    SizedBox(height: 8.h),
    Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16.sp,
      color: theme.colorScheme.onTertiaryContainer,
    ),
  ],
),
            ],
          ),
        ),
      ),
    );
  }
}