
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/generated/l10n.dart';

extension HomeTabLocalization on HomeTab {
  String getName(S strings) {
    return switch (this) {
      HomeTab.forYou => strings.forYou,
      HomeTab.posts => strings.posts,
      HomeTab.courses => strings.courses,
      HomeTab.opportunities => strings.opportunities,
    };
  }
}