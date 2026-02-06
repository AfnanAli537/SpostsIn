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

// class _AchievementDetailView extends StatelessWidget {
//   final Achievement achievement;
//   final bool isCurrentUser;
//   final String userId;

//   const _AchievementDetailView({
//     required this.achievement,
//     required this.isCurrentUser,
//     required this.userId,
//   });

//   void _showDeleteConfirmation(BuildContext context) {
//     final strings = S.of(context);

//     ConfirmationDialog.show(
//       context: context,
//       title: 'Delete Achievement',
//       message: 'Are you sure you want to delete this achievement? This action cannot be undone.',
//       confirmText: 'Delete',
//       cancelText: 'Cancel',
//       icon: Icons.delete_outline,
//       isDestructive: true,
//       onConfirm: () {
//         context.read<ProfileBloc>().add(
//               DeleteAchievement(achievementId: achievement.id),
//             );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final strings = S.of(context);

//     return BlocListener<ProfileBloc, ProfileState>(
//       listener: (context, state) {
//         if (state is AchievementDeleted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text('Achievement deleted successfully'),
//               backgroundColor: theme.colorScheme.primary,
//             ),
//           );
//           Navigator.pop(context, true);
//         } else if (state is ProfileError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message),
//               backgroundColor: theme.colorScheme.error,
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           actions: isCurrentUser
//               ? [
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.white),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => AchievementEditScreen(
//                             achievement: achievement,
//                             userId: userId,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete_outline, color: Colors.white),
//                     onPressed: () => _showDeleteConfirmation(context),
//                   ),
//                 ]
//               : null,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // --- Header Image ---
//               Stack(
//                 children: [
//                   Container(
//                     height: 350.h,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: theme.colorScheme.surfaceVariant,
//                     ),
//                     child: Image.network(
//                       achievement.imageUrl,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Center(
//                           child: Icon(
//                             Icons.emoji_events,
//                             size: 100.sp,
//                             color: theme.colorScheme.primary,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   // Bottom gradient overlay for readability
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       height: 100.h,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Colors.black.withOpacity(0.7),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               // --- Content Card ---
//               Transform.translate(
//                 offset: Offset(0, -30.h), // Pull content up over the image
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.surface,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30.r),
//                       topRight: Radius.circular(30.r),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Date Badge & Year
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             if (achievement.date != null)
//                               Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
//                                 decoration: BoxDecoration(
//                                   color: theme.colorScheme.primary.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(12.r),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.calendar_month_outlined, 
//                                       size: 18.sp, 
//                                       color: theme.colorScheme.primary
//                                     ),
//                                     SizedBox(width: 8.w),
//                                     Text(
//                                       _formatDate(achievement.date!),
//                                       style: theme.textTheme.labelLarge?.copyWith(
//                                         color: theme.colorScheme.primary,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
                            
//                             // Year Indicator
//                             Text(
//                               achievement.date?.year.toString() ?? "",
//                               style: theme.textTheme.titleMedium?.copyWith(
//                                 color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 24.sp,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20.h),

//                         // Title
//                         Text(
//                           achievement.title,
//                           style: theme.textTheme.headlineMedium?.copyWith(
//                             fontWeight: FontWeight.w800,
//                             color: theme.colorScheme.onSurface,
//                             letterSpacing: -0.5,
//                           ),
//                         ),
//                         SizedBox(height: 12.h),

//                         // Subtitle/Highlight Line
//                         Container(
//                           width: 40.w,
//                           height: 4.h,
//                           decoration: BoxDecoration(
//                             color: theme.colorScheme.primary,
//                             borderRadius: BorderRadius.circular(2.r),
//                           ),
//                         ),
//                         SizedBox(height: 24.h),

//                         // Description Heading
//                         Text(
//                           "About this Achievement",
//                           style: theme.textTheme.titleSmall?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: theme.colorScheme.primary,
//                             textBaseline: TextBaseline.alphabetic,
//                           ),
//                         ),
//                         SizedBox(height: 12.h),

//                         // Main Description text
//                         Text(
//                           achievement.subtitle,
//                           style: theme.textTheme.bodyLarge?.copyWith(
//                             color: theme.colorScheme.onSurfaceVariant,
//                             height: 1.6,
//                             fontSize: 16.sp,
//                           ),
//                         ),
                        
//                         SizedBox(height: 40.h),
                        
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     final months = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December'
//     ];
//     return '${months[date.month - 1]} ${date.day}, ${date.year}';
//   }
// }
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

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is AchievementDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Achievement deleted successfully')),
          );
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Achievements",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: isCurrentUser
              ? [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.black),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AchievementEditScreen(achievement: achievement, userId: userId),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.black),
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
              // --- Image Header ---
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2B3D), // Dark blue from image
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    achievement.imageUrl,
                    fit: BoxFit.contain, // Matches the logo style in image
                    errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.sports_football, size: 80.sp, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // --- Date Field ---
              _buildLabel("Date"),
              _buildInfoContainer(achievement.date?.year.toString() ?? "N/A"),
              SizedBox(height: 16.h),

              // --- Title Field ---
              _buildLabel("Title"),
              _buildInfoContainer(achievement.title),
              SizedBox(height: 16.h),

              // --- Description Field ---
              _buildLabel("Description"),
              _buildInfoContainer(
                achievement.subtitle, // Assuming subtitle holds the long text
                isDescription: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build the "Title", "Description" text labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Helper to build the grey rounded boxes
  Widget _buildInfoContainer(String text, {bool isDescription = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2), // Light grey background
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey[700],
          height: isDescription ? 1.5 : 1.0,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: 'Delete Achievement',
      message: 'Are you sure you want to delete this?',
      onConfirm: () => context.read<ProfileBloc>().add(DeleteAchievement(achievementId: achievement.id)),
       confirmText: 'Delete', 
       cancelText: 'Cancel',
        icon: Icons.delete_outline,
         isDestructive: true,
    );
  }
}