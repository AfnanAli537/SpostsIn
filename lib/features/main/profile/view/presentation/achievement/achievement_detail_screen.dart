import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_event.dart';
import 'package:sports_in/features/main/profile/view_model/profile_state.dart';
import 'package:sports_in/generated/l10n.dart';
import 'achievement_edit_screen.dart';

class AchievementDetailScreen extends StatelessWidget {
  final Achievement achievement;
  final bool isCurrentUser;
  final String userId;

  const AchievementDetailScreen({
    super.key,
    required this.achievement,
    required this.isCurrentUser,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>(),
      child: _AchievementDetailView(
        achievement: achievement,
        isCurrentUser: isCurrentUser,
        userId: userId,
      ),
    );
  }
}

class _AchievementDetailView extends StatelessWidget {
  final Achievement achievement;
  final bool isCurrentUser;
  final String userId;

  const _AchievementDetailView({
    required this.achievement,
    required this.isCurrentUser,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is AchievementDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Achievement deleted successfully'),
              backgroundColor: colorScheme.primary,
            ),
          );
          // Pop back to list/profile with refresh flag
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Achievements",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          actions: isCurrentUser
              ? [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: colorScheme.onSurface),
                    onPressed: () async {
                      // Navigate to edit screen
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileBloc>(),
                            child: AchievementEditScreen(
                              achievement: achievement,
                              userId: userId,
                            ),
                          ),
                        ),
                      );
                      
                      // If edit screen returns true (deleted or updated), pop detail screen too
                      if (result == true && context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: colorScheme.onSurface),
                    onPressed: () => _showDeleteConfirmation(context),
                  ),
                ]
              : null,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    achievement.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.sports_football,
                      size: 80.sp,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              _buildField(
                context,
                label: "Date",
                content: _formatDate(achievement.date),
              ),

              _buildField(
                context,
                label: "Title",
                content: achievement.title,
              ),

              _buildField(
                context,
                label: "Description",
                content: achievement.subtitle,
                isLongText: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String label,
    required String content,
    bool isLongText = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              content.isEmpty ? "No $label provided" : content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: isLongText ? 1.5 : 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "No date set";
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showDeleteConfirmation(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: 'Delete Achievement',
      message: 'Are you sure you want to delete this achievement?',
      onConfirm: () {
        context.read<ProfileBloc>().add(
          DeleteAchievement(achievementId: achievement.id),
        );
      },
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }
}