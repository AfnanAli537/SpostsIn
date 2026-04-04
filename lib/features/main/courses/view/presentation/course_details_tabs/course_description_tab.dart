// widgets/course_description_tab.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/generated/l10n.dart';

class CourseDescriptionTab extends StatelessWidget {
  final CourseModel course;
  final bool isEditMode;
  final bool hasUnsavedChanges;
  final File? newThumbnail;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final bool isFree;
  final VoidCallback onPickThumbnail;
  final VoidCallback onCancelEdit;
  final VoidCallback onSaveChanges;
  final ValueChanged<bool> onFreeChanged;
  final VoidCallback onFieldChanged;

  const CourseDescriptionTab({
    super.key,
    required this.course,
    required this.isEditMode,
    required this.hasUnsavedChanges,
    this.newThumbnail,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.isFree,
    required this.onPickThumbnail,
    required this.onCancelEdit,
    required this.onSaveChanges,
    required this.onFreeChanged,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEditMode) _buildThumbnailEditor(theme, string),
          _buildTitle(theme, string),
          SizedBox(height: 16.h),
          _buildOwnerInfo(theme, context),
          SizedBox(height: 16.h),
          _buildStats(theme, string),
          SizedBox(height: 16.h),
          _buildPriceSection(theme, string),
          SizedBox(height: 24.h),
          _buildDescriptionSection(theme, string),
          if (isEditMode) _buildEditButtons(theme, string),
        ],
      ),
    );
  }

  Widget _buildThumbnailEditor(ThemeData theme, S string) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          string.courseThumbnail,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onPickThumbnail,
          child: Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: newThumbnail != null ? Colors.green : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: newThumbnail != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.file(
                          newThumbnail!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  )
                : course.thumbnailUrl != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          course.thumbnailUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black26,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 40.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  string.tapToChange,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 48.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          string.uploadCourseThumbnail,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildTitle(ThemeData theme, S string) {
    if (isEditMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            string.courseTitleHint,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: titleController,
            onChanged: (_) => onFieldChanged(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              hintText: string.enterCourseTitleHint,
            ),
            style: theme.textTheme.titleLarge,
          ),
        ],
      );
    } else {
      return Text(
        course.title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget _buildOwnerInfo(ThemeData theme, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.userProfile,
          arguments: course.owner.userId,
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: course.owner.profilePictureUrl != null
                ? NetworkImage(course.owner.profilePictureUrl!)
                : null,
            child: course.owner.profilePictureUrl == null
                ? const Icon(Icons.person)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              course.owner.fullName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(ThemeData theme, S string) {
    return Row(
      children: [
        Icon(
          Icons.play_circle_outline,
          size: 16.sp,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: 4.w),
        Text(
          string.lessonsCount(course.lessonsCount),
          style: theme.textTheme.bodyMedium,
        ),
        SizedBox(width: 16.w),
        Icon(Icons.access_time, size: 16.sp, color: theme.colorScheme.primary),
        SizedBox(width: 4.w),
        Text(course.formattedDuration, style: theme.textTheme.bodyMedium),
        SizedBox(width: 16.w),
        Icon(Icons.person, size: 16.sp, color: theme.colorScheme.primary),
        SizedBox(width: 4.w),
        Text(
          string.enrolledCount(course.enrolledUsersCount),
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildPriceSection(ThemeData theme, S string) {
    if (isEditMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            string.price,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Checkbox(
                value: isFree,
                onChanged: (v) {
                  onFreeChanged(v!);
                  onFieldChanged();
                },
              ),
              Text(string.freeCourse),
              SizedBox(width: 16.w),
              if (!isFree)
                Expanded(
                  child: TextField(
                    controller: priceController,
                    onChanged: (_) => onFieldChanged(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      hintText: 'Price',
                      suffixText: 'EGP',
                    ),
                  ),
                ),
            ],
          ),
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: course.isFree
              ? Colors.green.withOpacity(0.1)
              : theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          course.isFree ? 'FREE' : '${course.price} EGP',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: course.isFree
                ? Colors.green
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
      );
    }
  }

  Widget _buildDescriptionSection(ThemeData theme, S string) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          string.description,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        if (isEditMode)
          TextField(
            controller: descriptionController,
            onChanged: (_) => onFieldChanged(),
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              hintText: string.enterCourseDescriptionHint,
            ),
          )
        else if (course.description?.isNotEmpty == true)
          Text(course.description!, style: theme.textTheme.bodyMedium)
        else
          Text(
            string.noDescriptionAvailable,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }

  Widget _buildEditButtons(ThemeData theme, S string) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancelEdit,
              child: Text(string.cancel),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: ElevatedButton(
              onPressed: hasUnsavedChanges ? onSaveChanges : null,
              child: Text(string.save),
            ),
          ),
        ],
      ),
    );
  }
}
