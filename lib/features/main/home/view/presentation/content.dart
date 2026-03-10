import 'package:flutter/material.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/courses_tab.dart';
import 'package:sports_in/features/main/home/view/presentation/home_tab.dart';
import 'package:sports_in/features/main/home/view/presentation/posts_tab.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/opportunity_list.dart';

class BuildContent extends StatelessWidget {
  final HomeTab currentTab;
  final void Function(HomeTab) onTabChange;

  const BuildContent({
    super.key,
    required this.currentTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    // IndexedStack keeps every tab widget alive in the tree so state is
    // preserved across tab switches — only the visible index is rendered
    // on screen, but none of the others are disposed.
    return SliverToBoxAdapter(
      child: IndexedStack(
        index: HomeTab.values.indexOf(currentTab),
        children: [
          ForYouTab(onTabChange: onTabChange),
          const PostsTab(),
          const CoursesTab(),
          const OpportunitiesContent(),
        ],
      ),
    );
  }
}