import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
import 'package:sports_in/features/main/home/view/presentation/uploadposts.dart';
import 'package:sports_in/features/main/home/view/widgets/option_card.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/upload_opportunity.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/features/main/profile/view/presentation/achievement/achievement_edit_screen.dart';
import 'package:sports_in/generated/l10n.dart';

class CreateOptionsBottomSheet extends StatelessWidget {
  const CreateOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                buildOptionCard(
                  icon: Icons.edit_note,
                  iconColor: const Color(0xFFFFA726),
                  title: strings.createPost,
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) => PostsBloc(postRepo: getIt<PostsRepositoryImpl>()),
                          child: const UploadContentScreen(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                buildOptionCard(
                  icon: Icons.star,
                  iconColor: const Color(0xFFFFEE58),
                  title: strings.createAchievement,
                  onTap: () async {
                    final sharedPref = getIt<SharedPref>();
                    // final result =
                      await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AchievementEditScreen(userId: sharedPref.getUserId()!),
                      ),
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(height: 16.h),
                FutureBuilder(
                  future: getIt<SharedPref>().getUserFromPrefs(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();

                    final userType = snapshot.data!.userType?.toLowerCase();
                    final canCreateOpportunity = userType == 'coach' ||
                        userType == 'scout' ||
                        userType == 'club';

                    return Visibility(
                      visible: canCreateOpportunity,
                      child: buildOptionCard(
                        icon: Icons.campaign,
                        iconColor: const Color(0xFF90CAF9),
                        title: strings.createOpportunity,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (_) => OpportunityBloc(
                                  opportunityRepo: getIt<OpportunityReposatory>(),
                                ),
                                child: const AddOpportunityScreen(),
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
                    final canCreateOpportunity = userType == 'coach' ||
                        userType == 'scout' ||
                        userType == 'club';

                    return Visibility(
                      visible: canCreateOpportunity,
                      child: SizedBox(height: 16.h),
                    );
                  },
                ),
                buildOptionCard(
                  icon: Icons.work_outline,
                  iconColor: const Color(0xFFBCAAA4),
                  title: strings.createAdvertisement,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 16.h),
                buildOptionCard(
                  icon: Icons.play_arrow,
                  iconColor: const Color(0xFF9CCC65),
                  title: strings.makeVideoAnalysis,
                  onTap: () {
                    Navigator.pop(context);
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

}

void showCreateOptionsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const CreateOptionsBottomSheet(),
  );
}