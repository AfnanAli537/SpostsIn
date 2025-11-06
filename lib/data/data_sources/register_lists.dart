import 'package:sports_in/generated/l10n.dart';

/// Provides static dropdown data for the Player Registration screen.
class RegisterLists {
    // Gender options list
  static List<String> genderOptions(S s) => [
        s.male,
        s.female,
      ];

  static List<String> locationOptions(S s) => [
        s.algeria,
        s.egypt,
        s.morocco,
        s.tunisia,
        s.sudan,
      ];

  // Years of experience options list
  static List<String> yearsOfExperienceOptions (S s) => [
        s.yearsOfExperience0to2,
        s.yearsOfExperience3to5,
        s.yearsOfExperience5to10,
        s.yearsOfExperience10Plus,
      ];

  // Sport name options list
  static List<String> sportNameOptions (S s) => [
        s.football,
        s.basketball,
        s.volleyball,
        s.handball,
        s.teakwando,
        s.gymnastics,

      ];

  // Sport Profession list
  static List<String> sportProfessionOptions(S s) => [
        s.footballer,
        s.basketballer,
        s.volleyballer,
        s.handballPlayer,
        s.teakwandoPlayer,
        s.gymnast,
      ];

  static List<String> positionOptions(S s, String? sport) {
    if (sport == null) return [];
    
    // Football positions
    if (sport == s.footballer) {
      return [
        s.goalkeeper,
        s.defender,
        s.midfielder,
        s.forward,
      ];
    }
    
    // Basketball positions
    if (sport == s.basketballer) {
      return [
        s.pointGuard,
        s.shootingGuard,
        s.smallForward,
        s.powerForward,
        s.center,
      ];
    }
    
    // Volleyball positions
    if (sport == s.volleyballer) {
      return [
        s.setter,
        s.outsideHitter,
        s.oppositeHitter,
        s.middleBlocker,
        s.libero,
      ];
    }
    
    // Handball positions
    if (sport == s.handballPlayer) {
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
    return teamSportKeywords.any((keyword) => 
      sportLower.contains(keyword.toLowerCase().replaceAll(' ', ''))
    );
  }
   
  static bool isTeamSport(S s,String? sportValue) {
    if (sportValue == null) return false;
    
    final teamSports = [
      s.footballer,
      s.basketballer,
      s.volleyballer,
      s.handballPlayer,
    ];
    
    return teamSports.contains(sportValue);
  }
}