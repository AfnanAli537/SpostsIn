import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        // ✅ Add height constraint for landscape
        constraints: BoxConstraints(
          maxHeight: isLandscape ? 200.h : double.infinity,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLandscape
            ? _buildLandscapeLayout(theme) // ✅ Horizontal layout for landscape
            : _buildPortraitLayout(theme), // ✅ Vertical layout for portrait
      ),
    );
  }

  // ✅ Portrait layout (vertical)
  Widget _buildPortraitLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ✅ Smaller thumbnail (120h instead of 160h)
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          child: Image.network(
            course.thumbnailUrl ?? '',
            height: 120.h, // ✅ Reduced from 160h
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 120.h,
              color: Colors.grey[300],
              child: Icon(Icons.image_not_supported, size: 40.sp), // ✅ Smaller icon too
            ),
          ),
        ),

        // Content
        Flexible(
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: _buildCardContent(theme),
          ),
        ),
      ],
    );
  }

  // ✅ Landscape layout (horizontal)
  Widget _buildLandscapeLayout(ThemeData theme) {
    return Row(
      children: [
        // ✅ Smaller thumbnail (150w instead of 200w)
        ClipRRect(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
          child: Image.network(
            course.thumbnailUrl ?? '',
            width: 150.w, // ✅ Reduced from 200w
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 150.w,
              color: Colors.grey[300],
              child: Icon(Icons.image_not_supported, size: 40.sp), // ✅ Smaller icon too
            ),
          ),
        ),

        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: _buildCardContent(theme),
          ),
        ),
      ],
    );
  }

  // ✅ Shared card content
  Widget _buildCardContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          course.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),

        // Description
        if (course.description != null && course.description!.isNotEmpty)
          Text(
            course.description!,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

        SizedBox(height: 8.h),

        // Progress bar (if enrolled)
        if (course.isEnrolled) ...[
          LinearProgressIndicator(
            value: course.progress / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorManager.warning,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${course.progress}% complete',
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 8.h),
        ],

        // Price or controls (no Spacer)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!course.isEnrolled)
              Flexible(
                child: Text(
                  course.isFree ? 'FREE' : '${course.price} EGP',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: course.isFree ? Colors.green : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Provider controls
            if (course.isOwner && (onEdit != null || onDelete != null))
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      iconSize: 20.sp,
                      onPressed: onEdit,
                      padding: EdgeInsets.all(4.w),
                      constraints: const BoxConstraints(),
                      tooltip: 'Edit',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[700],
                      ),
                      iconSize: 20.sp,
                      onPressed: onDelete,
                      padding: EdgeInsets.all(4.w),
                      constraints: const BoxConstraints(),
                      tooltip: 'Delete',
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}