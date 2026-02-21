// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
import 'package:sports_in/features/main/home/view/presentation/uploadposts.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/upload_opportunity.dart';
import 'package:sports_in/features/main/opportunity/view_model/ooprtunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/features/main/profile/view/presentation/achievement/achievement_edit_screen.dart';

class CreateOptionsBottomSheet extends StatelessWidget {
  const CreateOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.h, bottom: 20.h),
            child: Container(
              width: 100.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1D2D3D),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),

          /// Options List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                _buildOptionCard(
                  icon: Icons.edit_note,
                  iconColor: const Color(0xFFFFA726),
                  title: 'Create Post',
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) =>
                              PostsBloc(postRepo: getIt<PostsRepositoryImpl>()),
                          child: UploadContentScreen(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                _buildOptionCard(
                  icon: Icons.star,
                  iconColor: const Color(0xFFFFEE58),
                  title: 'Create Achievement',
                  onTap: () async {
                    final sharedPref = getIt<SharedPref>();
                    // final result =
                      await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AchievementEditScreen(userId: sharedPref.getUserId()!),
                      ),
                    );
                    Navigator.pop(context);
                    // Navigate to create achievement
                  },
                ),
                SizedBox(height: 16.h),
                FutureBuilder(
                  future: getIt<SharedPref>().getUserFromPrefs(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();

                    final userType = snapshot.data!.userType?.toLowerCase();

                    final canCreateOpportunity =
                        userType == 'coach' ||
                        userType == 'scout' ||
                        userType == 'club';

                    return Visibility(
                      visible: canCreateOpportunity,
                      child: _buildOptionCard(
                        icon: Icons.campaign,
                        iconColor: const Color(0xFF90CAF9),
                        title: 'Create opportunity',
                        onTap: () {
                          Navigator.pop(context);
                          
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) =>
                            OpportunityBloc(opportunityRepo: getIt<OpportunityReposatory>() ),
                          child: AddOpportunityScreen(),
                        ),
                      ),
                    );
                     
                        },
                      ),
                    );
                  },
                ),
   FutureBuilder(
                  future: getIt<SharedPref>().getUserFromPrefs(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();

                    final userType = snapshot.data!.userType?.toLowerCase();

                    final canCreateOpportunity =
                        userType == 'coach' ||
                        userType == 'scout' ||
                        userType == 'club';

                    return    Visibility(
                      visible:canCreateOpportunity ,
                      child: SizedBox(height: 16.h));
                  },
                ),

     
             
                _buildOptionCard(
                  icon: Icons.work_outline,
                  iconColor: const Color(0xFFBCAAA4),
                  title: 'Create Advertisement',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to create advertisement
                  },
                ),
                SizedBox(height: 16.h),
                _buildOptionCard(
                  icon: Icons.play_arrow,
                  iconColor: const Color(0xFF9CCC65),
                  title: 'Make Video Analysis',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to video analysis
                  },
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: ThemeData().colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1D2D3D),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 26.sp),
            ),
            SizedBox(width: 20.w),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,

                  color: const Color(0xFF1D2D3D),
                ),
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF1D2D3D),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

void showCreateOptionsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const CreateOptionsBottomSheet(),
  );
}
