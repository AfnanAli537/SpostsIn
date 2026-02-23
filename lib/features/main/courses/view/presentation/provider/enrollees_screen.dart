import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/view/widgets/enrollee_card.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class EnrolleesScreen extends StatefulWidget {
  final String courseId;

  const EnrolleesScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<EnrolleesScreen> createState() => _EnrolleesScreenState();
}

class _EnrolleesScreenState extends State<EnrolleesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(FetchEnrolledUsers(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state is CoursesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EnrolleesLoaded) {
          if (state.enrollees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    // string.noEnrollees ?? 
                    'No enrollees yet',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    // string.enrolleesWillAppear ?? 
                    'Enrolled students will appear here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CoursesBloc>().add(
                    FetchEnrolledUsers(courseId: widget.courseId),
                  );
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Column(
              children: [
                // Stats header
                Container(
                  padding: EdgeInsets.all(16.r),
                  margin: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        // string.totalEnrolled ?? 
                        'Total Enrolled',
                        '${state.enrollees.length}',
                        Icons.people,
                        theme,
                      ),
                      Container(
                        width: 1,
                        height: 40.h,
                        color: theme.colorScheme.onPrimaryContainer.withOpacity(0.2),
                      ),
                      _buildStat(
                        // string.avgProgress ??
                         'Avg Progress',
                        '${_calculateAverageProgress(state.enrollees)}%',
                        Icons.trending_up,
                        theme,
                      ),
                    ],
                  ),
                ),

                // Enrollees list
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: state.enrollees.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final enrollee = state.enrollees[index];
                      return EnrolleeCard(
                        enrollee: enrollee,
                        onTap: () {
                          // Could navigate to detailed progress screen
                          _showEnrolleeDetails(enrollee);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        if (state is CoursesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: theme.colorScheme.error,
                ),
                SizedBox(height: 16.h),
                Text(
                  state.message,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<CoursesBloc>().add(
                          FetchEnrolledUsers(courseId: widget.courseId),
                        );
                  },
                  child: Text(string.retry),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildStat(String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32.sp,
          color: theme.colorScheme.onPrimaryContainer,
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  int _calculateAverageProgress(List enrollees) {
    if (enrollees.isEmpty) return 0;
    final total = enrollees.fold<int>(0, (sum, e) => sum + (e.progress as int));
    return (total / enrollees.length).round();
  }

  void _showEnrolleeDetails(enrollee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(enrollee.fullName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress: ${enrollee.progress}%'),
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: enrollee.progress / 100,
            ),
            SizedBox(height: 16.h),
            Text('Enrolled: ${_formatDate(enrollee.enrolledAt)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}