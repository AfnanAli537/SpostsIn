import 'package:flutter/material.dart';
import 'package:sports_in/features/main/home/data/interface/home_tap_enums.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';

class BuildContent extends StatelessWidget {
  final HomeTab currentTab;

  const BuildContent({
    super.key,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentTab) {
      case HomeTab.forYou:
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const PostWidget(
              userName: 'User Dronkins',
              timeAgo: '2 months ago',
              desc: 'Volunteering with the sports team...',
              mediaUrl: null,
              title: "any",
              likes: 143,
              comments: 34,
            ),
            childCount: 1,
          ),
        );

      case HomeTab.posts:
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const PostWidget(
              userName: 'User Dronkins',
              timeAgo: '2 months ago',
              desc: 'Volunteering with the sports team...',
              mediaUrl: null,
              title: "any",
              likes: 143,
              comments: 34,
            ),
            childCount: 5,
          ),
        );

      case HomeTab.courses:
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text("Courses tab content")),
          ),
        );

      case HomeTab.opportunities:
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text("Opportunities tab content")),
          ),
        );
    }
  }
}
