import 'package:sports_in/generated/l10n.dart';

enum HomeTab { forYou, posts, courses, opportunities }

enum CommentAction {
  none,
  added,
  edited,
  deleted,
}

extension HomeTabExtension on HomeTab {
  String getName(S strings) {
    switch (this) {
      case HomeTab.forYou:
        return strings.forYou;
      case HomeTab.posts:
        return strings.posts;
      case HomeTab.courses:
        return strings.courses;
      case HomeTab.opportunities:
        return strings.opportunities;
    }
  }
}