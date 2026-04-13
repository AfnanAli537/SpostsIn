import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_list_item_card.dart';
import '../widgets/section_header.dart';

class AnalyzedVideosSection extends StatelessWidget {
  final List<AnalysisListItemModel> videos;
  final VoidCallback? onShowAll;
  // Use the ? here for the function
  final Function(AnalysisListItemModel)? onVideoTap; 
  final String title;

  const AnalyzedVideosSection({
    super.key,
    required this.videos,
    this.onShowAll,
    this.onVideoTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          onShowAllPressed: onShowAll,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
          itemCount: videos.length > 2 ? 2 : videos.length,
          itemBuilder: (context, index) {
            final item = videos[index];
            return AnalysisListItemCard(
              item: item,
              // Use ?.call here too
              onTap: () => onVideoTap?.call(item), 
            );
          },
        ),
      ],
    );
  }
}
