import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoursesSection extends StatelessWidget {
  final List<Course> courses;
  final VoidCallback? onShowAll;
  final Function(Course)? onCourseTap;
  final ThemeData theme;
  final S string;

  const CoursesSection({
    super.key,
    required this.courses,
    this.onShowAll,
    this.onCourseTap,
    required this.theme,
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: string.courses,
          onShowAllPressed: onShowAll,
        ),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: courses.length > 3 ? 3 : courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: GestureDetector(
                  onTap: () => onCourseTap?.call(course),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                      ),
                      child: Image.network(
                        course.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.school,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}