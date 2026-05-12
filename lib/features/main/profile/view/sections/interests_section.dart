import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/widgets/interest_card.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InterestsSection extends StatelessWidget {
  final List<Interest> interests;
  final VoidCallback? onShowAll;
  final Function(Interest)? onFollowToggle;
  final Function(Interest)? onInterestTap;
  final ThemeData theme;
  final S string;

  const InterestsSection({
    Key? key,
    required this.interests,
    this.onShowAll,
    this.onFollowToggle,
    this.onInterestTap,
    required this.theme,
    required this.string,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (interests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: string.interests, onShowAllPressed: onShowAll),
        SizedBox(height: 16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: interests.length > 3 ? 3 : interests.length,
          itemBuilder: (context, index) {
            // final interest = interests[index];
            return InterestCard(
              interest: interests[index],
              onTap: () =>
              Navigator.pushNamed(context, AppRoutes.userProfile, arguments: interests[index].id),
            );
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
    
}
