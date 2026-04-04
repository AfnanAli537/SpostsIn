import 'package:flutter/material.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/courses_tab.dart';
import 'package:sports_in/features/main/home/view/presentation/home_tab.dart';
import 'package:sports_in/features/main/home/view/presentation/posts_tab.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/opportunity_list.dart';

class BuildContent extends StatelessWidget {
  final HomeTab currentTab;
  final void Function(HomeTab) onTabChange;
  final GlobalKey<ForYouTabState> forYouKey;
  final GlobalKey<PostsTabState> postsKey;
  final GlobalKey<CoursesTabState> coursesKey;
  final GlobalKey<OpportunitiesContentState> opportunitiesKey;

  const BuildContent({
    super.key,
    required this.currentTab,
    required this.onTabChange,
    required this.forYouKey,
    required this.postsKey,
    required this.coursesKey,
    required this.opportunitiesKey,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ForYouTab(key: forYouKey, onTabChange: onTabChange),
      PostsTab(key: postsKey),
      CoursesTab(key: coursesKey),
      OpportunitiesContent(key: opportunitiesKey),
    ];
    final activeIndex = HomeTab.values.indexOf(currentTab);

    return SliverToBoxAdapter(
      child: Stack(
        children: List.generate(tabs.length, (i) {
          return Offstage(
            offstage: i != activeIndex,
            child: TickerMode(
              enabled: i == activeIndex,
              child: tabs[i],
            ),
          );
        }),
      ),
    );
  }
}