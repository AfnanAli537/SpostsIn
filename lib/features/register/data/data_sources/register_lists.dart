import 'package:sports_in/generated/l10n.dart';

class RegisterLists {
  static List<String> genderOptions(S s) => [s.male, s.female];

  static List<String> locationOptions(S s) => [
    s.cairo,
    s.giza,
    s.alexandria,
    s.dakahlia,
    s.redSea,
    s.beheira,
    s.fayoum,
    s.gharbia,
    s.ismailia,
    s.monufia,
    s.minya,
    s.qalyubia,
    s.newValley,
    s.sharqia,
    s.suez,
    s.aswan,
    s.asyut,
    s.beniSuef,
    s.portSaid,
    s.damietta,
    s.southSinai,
    s.kafrElSheikh,
    s.matrouh,
    s.luxor,
    s.qena,
    s.northSinai,
    s.sohag,
  ];
  static List<String> sportNameOptions(S s) => [
    s.football,
    s.basketball,
    s.volleyball,
    s.handball,
    s.teakwando,
  ];

  static List<String> sportProfessionOptions(S s) => [
    s.footballer,
    s.basketballer,
    s.volleyballer,
    s.handballPlayer,
    s.teakwandoPlayer,
  ];

  static List<String> positionOptions(S s, String? sport) {
    if (sport == null) return [];

    if (sport == s.footballer || sport == s.football) {
      return [s.goalkeeper, s.defender, s.midfielder, s.forward];
    }

    if (sport == s.basketballer || sport == s.basketball) {
      return [
        s.pointGuard,
        s.shootingGuard,
        s.smallForward,
        s.powerForward,
        s.center,
      ];
    }

    if (sport == s.volleyballer || sport == s.volleyball) {
      return [
        s.setter,
        s.outsideHitter,
        s.oppositeHitter,
        s.middleBlocker,
        s.libero,
      ];
    }

    if (sport == s.handballPlayer || sport == s.handball) {
      return [
        s.goalkeeper,
        s.leftWing,
        s.rightWing,
        s.leftBack,
        s.centerBack,
        s.rightBack,
        s.pivot,
      ];
    }

    return [];
  }

  static bool sportHasPositions(String? sport) {
    if (sport == null) return false;

    final teamSportKeywords = [
      'football',
      'footballer',
      'basketball',
      'basketballer',
      'volleyball',
      'volleyballer',
      'handball',
      'handballplayer',
      'كرة القدم',
      'كرة السلة',
      'الكرة الطائرة',
      'كرة اليد',
    ];

    final sportLower = sport.toLowerCase().replaceAll(' ', '');
    return teamSportKeywords.any(
      (keyword) =>
          sportLower.contains(keyword.toLowerCase().replaceAll(' ', '')),
    );
  }

  static bool isTeamSport(S s, String? sportValue) {
    if (sportValue == null) return false;

    final teamSports = [
      s.footballer,
      s.basketballer,
      s.volleyballer,
      s.handballPlayer,
      s.football,
      s.basketball,
      s.volleyball,
      s.handball,
    ];

    return teamSports.contains(sportValue);
  }
}
