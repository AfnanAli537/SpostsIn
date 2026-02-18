import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OpportunitiesSection extends StatelessWidget {
  final List<Opportunity> opportunities;
  final VoidCallback? onShowAll;
  final Function(Opportunity)? onOpportunityTap;
  final ThemeData theme;
  final S string;

  const OpportunitiesSection({
    super.key,
    required this.opportunities,
    this.onShowAll,
    this.onOpportunityTap,
    required this.theme,
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    if (opportunities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: string.opportunities,
          onShowAllPressed: onShowAll,
        ),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: opportunities.length > 6 ? 6 : opportunities.length,
            itemBuilder: (context, index) {
              final opportunity = opportunities[index];
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: GestureDetector(
                  onTap: () => onOpportunityTap?.call(opportunity),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onError.withOpacity(0.1),
                      ),
                      child: Image.network(
                        opportunity.mediaUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                            Icons.event_available_outlined,
                            size: 40.sp,
                            color: Theme.of(context).colorScheme.primary,
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