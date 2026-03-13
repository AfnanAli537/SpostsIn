import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final S string; 

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    required this.string, 
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth;
        final bool useHorizontalLayout = cardWidth > 400.w;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            constraints: BoxConstraints(
              maxHeight: useHorizontalLayout ? 200.h : double.infinity,
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
            child: useHorizontalLayout
                ? _buildHorizontalLayout(theme)
                : _buildVerticalLayout(theme),
          ),
        );
      },
    );
  }

  Widget _buildVerticalLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          child: _buildThumbnailImage(
            height: 120.h,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.r),
          child: _buildCardContent(theme, isHorizontal: false),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(ThemeData theme) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
          child: _buildThumbnailImage(
            width: 120.w,
            height: double.infinity,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: _buildCardContent(theme, isHorizontal: true),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailImage({
    required double? width,
    required double? height,
  }) {
    if (course.thumbnailUrl == null || course.thumbnailUrl!.isEmpty) {
      return _buildPlaceholder(width: width, height: height);
    }

    return Image.network(
      course.thumbnailUrl!,
      width: width,
      height: height,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[300],
          width: width,
          height: height,
          child: Center(
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) =>
          _buildPlaceholder(width: width, height: height),
    );
  }

  Widget _buildPlaceholder({
    required double? width,
    required double? height,
  }) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: 40.sp,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildCardContent(ThemeData theme, {required bool isHorizontal}) {
    final topContent = Column(
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
        if (course.description?.isNotEmpty == true)
          SizedBox(
            height: 12.sp * 1.6 * 2,
            child: Text(
              course.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        SizedBox(height: 8.h),

        // Author info
        _buildAuthorInfo(theme),
        SizedBox(height: 8.h),

        // Progress bar (if enrolled)
        if (course.isEnrolled) ...[
          LinearProgressIndicator(
            value: course.progress / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(ColorManager.warning),
          ),
          SizedBox(height: 4.h),
          Text(
            string.completePercentage(_formatProgress(course.progress)),
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 8.h),
        ],

        // Stats row
        _buildStatsRow(theme),
      ],
    );

    final bottomRow = _buildBottomRow(theme);

    if (isHorizontal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [topContent, bottomRow],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          topContent,
          SizedBox(height: 8.h),
          bottomRow,
        ],
      );
    }
  }

  Widget _buildAuthorInfo(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14.r,
          backgroundImage: course.owner.profilePictureUrl != null
              ? NetworkImage(course.owner.profilePictureUrl!)
              : null,
          child: course.owner.profilePictureUrl == null
              ? Icon(Icons.person, size: 14.sp)
              : null,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            course.owner.fullName,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Wrap(
      spacing: 14.w,
      runSpacing: 4.h,
      children: [
        _buildStatItem(
          Icons.play_circle_outline,
          string.lessonsCount(course.lessonsCount), 
          theme,
        ),
        _buildStatItem(
          Icons.access_time, 
          course.formattedDuration, 
          theme,
        ),
        _buildStatItem(
          Icons.person,
          string.enrolledCount(course.enrolledUsersCount), 
          theme,
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: theme.colorScheme.primary),
        SizedBox(width: 2.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp),
        ),
      ],
    );
  }

  Widget _buildBottomRow(ThemeData theme) {
    if (course.isEnrolled) {
      return const SizedBox.shrink();
    }

    if (course.isOwner) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              iconSize: 20.sp,
              onPressed: onEdit,
              padding: EdgeInsets.all(4.w),
              constraints: const BoxConstraints(),
              tooltip: string.edit, 
            ),
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[700]),
              iconSize: 20.sp,
              onPressed: onDelete,
              padding: EdgeInsets.all(4.w),
              constraints: const BoxConstraints(),
              tooltip: string.delete, 
            ),
        ],
      );
    }

    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        final isLoading =
            state is EnrollmentLoading && state.courseId == course.id;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                course.isFree ? string.free : '${course.price} ${string.egp}', 
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: course.isFree ? Colors.green : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 30.h,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<CoursesBloc>().add(
                          EnrollInCourse(courseId: course.id),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size(70.w, 28.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(string.enroll, style: TextStyle(fontSize: 12.sp, color: theme.colorScheme.onPrimary)), 
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatProgress(num value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }
}