import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/widgets/enrollee_card.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class EnrolleesTab extends StatefulWidget {
  final String courseId;

  const EnrolleesTab({
    super.key,
    required this.courseId,
  });

  @override
  State<EnrolleesTab> createState() => _EnrolleesTabState();
}

class _EnrolleesTabState extends State<EnrolleesTab> {
  List<EnrolledUserModel>? _enrollees; // null = loading, [] = empty
  String? _error;

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(FetchEnrolledUsers(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return BlocListener<CoursesBloc, CoursesState>(
      listenWhen: (_, current) =>
          current is EnrolleesLoaded || current is CoursesError,
      listener: (context, state) {
        if (state is EnrolleesLoaded) {
          setState(() {
            _enrollees = state.enrollees;
            _error = null;
          });
        } else if (state is CoursesError && _enrollees == null) {
          setState(() => _error = state.message);
        }
      },
      child: _buildContent(theme, string),
    );
  }

  Widget _buildContent(ThemeData theme, S string) {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: theme.colorScheme.error),
            SizedBox(height: 16.h),
            Text(
              _error!,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                setState(() => _error = null);
                context
                    .read<CoursesBloc>()
                    .add(FetchEnrolledUsers(courseId: widget.courseId));
              },
              child: Text(string.retry),
            ),
          ],
        ),
      );
    }

    if (_enrollees == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_enrollees!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              string.noEnrolleesYet,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              string.enrolleesWillAppear,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<CoursesBloc>()
            .add(FetchEnrolledUsers(courseId: widget.courseId));
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: Column(
        children: [
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
                  string.totalEnrolled,
                  '${_enrollees!.length}',
                  Icons.people,
                  theme,
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.2),
                ),
                _buildStat(
                  string.avgProgress,
                  '${_calculateAverageProgress(_enrollees!)}%',
                  Icons.trending_up,
                  theme,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: _enrollees!.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final enrollee = _enrollees![index];
                return EnrolleeCard(
                  enrollee: enrollee,
                  onTap: () => _showEnrolleeDetails(enrollee, string),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, size: 32.sp, color: theme.colorScheme.onPrimaryContainer),
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

  num _calculateAverageProgress(List<EnrolledUserModel> enrollees) {
    if (enrollees.isEmpty) return 0;
    final total = enrollees.fold<num>(0, (sum, e) => sum + e.progress);
    return (total / enrollees.length).round();
  }

  void _showEnrolleeDetails(EnrolledUserModel enrollee, S string) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(enrollee.fullName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${string.progress}: ${_formatProgress(enrollee.progress)}%'),
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: enrollee.progress / 100,
            ),
            SizedBox(height: 16.h),
            Text('${string.enrolled}: ${_formatDate(enrollee.enrolledAt)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(string.close),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatProgress(num value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}