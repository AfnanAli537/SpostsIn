import 'package:flutter/material.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/features/main/home/view/presentation/courses_tab.dart';
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
    switch (currentTab) {
      case HomeTab.forYou:
        return ForYouTab(onTabChange: onTabChange);
      
      case HomeTab.posts:
        return PostsTab();
      
      case HomeTab.courses:
        return const CoursesTab();
      
      case HomeTab.opportunities:
        return const OpportunitiesContent();
    }
  }
}