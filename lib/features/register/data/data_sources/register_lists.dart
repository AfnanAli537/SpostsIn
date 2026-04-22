import 'package:sports_in/generated/l10n.dart';

class GovernorateEntry {
  final String displayAr;
  final String displayEn;
  final String apiValue; // always English, sent to backend

  const GovernorateEntry({
    required this.displayAr,
    required this.displayEn,
    required this.apiValue,
  });

  String display(S s) {
    // detect locale by checking a known Arabic string
    final isArabic = s.male == 'ذكر';
    return isArabic ? displayAr : displayEn;
  }
}

class PositionEntry {
  final String displayAr;
  final String displayEn;
  final String abbreviation; // sent to backend

  const PositionEntry({
    required this.displayAr,
    required this.displayEn,
    required this.abbreviation,
  });

  /// e.g.  "GK - Goalkeeper (حارس مرمى)"
  String display(S s) {
    final isArabic = s.male == 'ذكر';
    return isArabic? '$displayEn - $displayAr': displayEn; }
}

class RegisterLists {
  // ─── Governorates ────────────────────────────────────────────────────────────

  static const List<GovernorateEntry> _governorates = [
    GovernorateEntry(displayAr: 'القاهرة',        displayEn: 'Cairo',         apiValue: 'Cairo'),
    GovernorateEntry(displayAr: 'الجيزة',         displayEn: 'Giza',          apiValue: 'Giza'),
    GovernorateEntry(displayAr: 'الإسكندرية',     displayEn: 'Alexandria',    apiValue: 'Alexandria'),
    GovernorateEntry(displayAr: 'الدقهلية',       displayEn: 'Dakahlia',      apiValue: 'Dakahlia'),
    GovernorateEntry(displayAr: 'البحر الأحمر',   displayEn: 'Red Sea',       apiValue: 'Red Sea'),
    GovernorateEntry(displayAr: 'البحيرة',        displayEn: 'Beheira',       apiValue: 'Beheira'),
    GovernorateEntry(displayAr: 'الفيوم',         displayEn: 'Fayoum',        apiValue: 'Fayoum'),
    GovernorateEntry(displayAr: 'الغربية',        displayEn: 'Gharbia',       apiValue: 'Gharbia'),
    GovernorateEntry(displayAr: 'الإسماعيلية',    displayEn: 'Ismailia',      apiValue: 'Ismailia'),
    GovernorateEntry(displayAr: 'المنوفية',       displayEn: 'Monufia',       apiValue: 'Monufia'),
    GovernorateEntry(displayAr: 'المنيا',         displayEn: 'Minya',         apiValue: 'Minya'),
    GovernorateEntry(displayAr: 'القليوبية',      displayEn: 'Qalyubia',      apiValue: 'Qalyubia'),
    GovernorateEntry(displayAr: 'الوادي الجديد',  displayEn: 'New Valley',    apiValue: 'New Valley'),
    GovernorateEntry(displayAr: 'الشرقية',        displayEn: 'Sharqia',       apiValue: 'Sharqia'),
    GovernorateEntry(displayAr: 'السويس',         displayEn: 'Suez',          apiValue: 'Suez'),
    GovernorateEntry(displayAr: 'أسوان',          displayEn: 'Aswan',         apiValue: 'Aswan'),
    GovernorateEntry(displayAr: 'أسيوط',          displayEn: 'Asyut',         apiValue: 'Asyut'),
    GovernorateEntry(displayAr: 'بني سويف',       displayEn: 'Beni Suef',     apiValue: 'Beni Suef'),
    GovernorateEntry(displayAr: 'بورسعيد',        displayEn: 'Port Said',     apiValue: 'Port Said'),
    GovernorateEntry(displayAr: 'دمياط',          displayEn: 'Damietta',      apiValue: 'Damietta'),
    GovernorateEntry(displayAr: 'جنوب سيناء',     displayEn: 'South Sinai',   apiValue: 'South Sinai'),
    GovernorateEntry(displayAr: 'كفر الشيخ',      displayEn: 'Kafr El Sheikh', apiValue: 'Kafr El Sheikh'),
    GovernorateEntry(displayAr: 'مطروح',          displayEn: 'Matrouh',       apiValue: 'Matrouh'),
    GovernorateEntry(displayAr: 'الأقصر',         displayEn: 'Luxor',         apiValue: 'Luxor'),
    GovernorateEntry(displayAr: 'قنا',            displayEn: 'Qena',          apiValue: 'Qena'),
    GovernorateEntry(displayAr: 'شمال سيناء',     displayEn: 'North Sinai',   apiValue: 'North Sinai'),
    GovernorateEntry(displayAr: 'سوهاج',          displayEn: 'Sohag',         apiValue: 'Sohag'),
  ];

  /// Display strings shown in the dropdown (ar or en based on locale)
  static List<String> locationOptions(S s) =>
      _governorates.map((g) => g.display(s)).toList();

  /// Given a display string (ar or en), return the English API value
  static String? getLocationApiValue(S s, String displayValue) {
    try {
      return _governorates
          .firstWhere(
            (g) => g.display(s) == displayValue,
          )
          .apiValue;
    } catch (_) {
      return displayValue; // fallback: return as-is
    }
  }

  // ─── Gender ──────────────────────────────────────────────────────────────────

  static List<String> genderOptions(S s) => [s.male, s.female];

  // ─── Sports ───────────────────────────────────────────────────────────────────

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

  // ─── Positions ────────────────────────────────────────────────────────────────

  static const List<PositionEntry> _footballPositions = [
    PositionEntry(abbreviation: 'GK',  displayEn: 'Goalkeeper',                  displayAr: 'حارس مرمى'),
    PositionEntry(abbreviation: 'CB',  displayEn: 'Center Back',                 displayAr: 'قلب دفاع'),
    PositionEntry(abbreviation: 'LB',  displayEn: 'Left Back',                   displayAr: 'ظهير أيسر'),
    PositionEntry(abbreviation: 'RB',  displayEn: 'Right Back',                  displayAr: 'ظهير أيمن'),
    PositionEntry(abbreviation: 'CDM', displayEn: 'Central Defensive Midfielder', displayAr: 'خط وسط مدافع'),
    PositionEntry(abbreviation: 'CM',  displayEn: 'Central Midfielder',           displayAr: 'خط وسط'),
    PositionEntry(abbreviation: 'CAM', displayEn: 'Central Attacking Midfielder', displayAr: 'صانع ألعاب'),
    PositionEntry(abbreviation: 'RW',  displayEn: 'Right Wing',                  displayAr: 'جناح أيمن'),
    PositionEntry(abbreviation: 'LW',  displayEn: 'Left Wing',                   displayAr: 'جناح أيسر'),
    PositionEntry(abbreviation: 'ST',  displayEn: 'Striker',                     displayAr: 'مهاجم صريح'),
  ];

  static const List<PositionEntry> _basketballPositions = [
    PositionEntry(abbreviation: 'PG', displayEn: 'Point Guard',    displayAr: 'صانع اللعب'),
    PositionEntry(abbreviation: 'SG', displayEn: 'Shooting Guard', displayAr: 'المسدد'),
    PositionEntry(abbreviation: 'SF', displayEn: 'Small Forward',  displayAr: 'الجناح الصغير'),
    PositionEntry(abbreviation: 'PF', displayEn: 'Power Forward',  displayAr: 'الجناح القوي'),
    PositionEntry(abbreviation: 'C',  displayEn: 'Center',         displayAr: 'الارتكاز'),
  ];

  static const List<PositionEntry> _volleyballPositions = [
    PositionEntry(abbreviation: 'S',   displayEn: 'Setter',               displayAr: 'صانع اللعب'),
    PositionEntry(abbreviation: 'OH',  displayEn: 'Outside Hitter',       displayAr: 'ضارب خارجي'),
    PositionEntry(abbreviation: 'OPP', displayEn: 'Opposite Hitter',      displayAr: 'ضارب مقابل'),
    PositionEntry(abbreviation: 'MB',  displayEn: 'Middle Blocker',       displayAr: 'حائط صد'),
    PositionEntry(abbreviation: 'L',   displayEn: 'Libero',               displayAr: 'ليبرو'),
    PositionEntry(abbreviation: 'DS',  displayEn: 'Defensive Specialist', displayAr: 'متخصص دفاع'),
  ];

  static const List<PositionEntry> _handballPositions = [
    PositionEntry(abbreviation: 'GK', displayEn: 'Goalkeeper',  displayAr: 'حارس مرمى'),
    PositionEntry(abbreviation: 'LW', displayEn: 'Left Wing',   displayAr: 'جناح أيسر'),
    PositionEntry(abbreviation: 'RW', displayEn: 'Right Wing',  displayAr: 'جناح أيمن'),
    PositionEntry(abbreviation: 'CB', displayEn: 'Center Back', displayAr: 'صانع اللعب'),
    PositionEntry(abbreviation: 'LB', displayEn: 'Left Back',   displayAr: 'ظهير أيسر'),
    PositionEntry(abbreviation: 'RB', displayEn: 'Right Back',  displayAr: 'ظهير أيمن'),
    PositionEntry(abbreviation: 'P',  displayEn: 'Pivot',       displayAr: 'الدائرة'),
  ];

  /// Returns display strings like "GK - Goalkeeper (حارس مرمى)"
  static List<String> positionOptions(S s, String? sport) {
    if (sport == null) return [];
    final entries = _positionEntries(s, sport);
    return entries.map((e) => e.display(s)).toList();
  }

  /// Given a display string, returns just the abbreviation for the API
  static String? getPositionApiValue(S s, String? sport, String? displayValue) {
    if (sport == null || displayValue == null) return null;
    try {
      return _positionEntries(s, sport)
          .firstWhere((e) => e.display(s) == displayValue)
          .abbreviation;
    } catch (_) {
      return displayValue;
    }
  }

  static List<PositionEntry> _positionEntries(S s, String? sport) {
    if (sport == null) return [];
    if (sport == s.footballer || sport == s.football) return _footballPositions;
    if (sport == s.basketballer || sport == s.basketball) return _basketballPositions;
    if (sport == s.volleyballer || sport == s.volleyball) return _volleyballPositions;
    if (sport == s.handballPlayer || sport == s.handball) return _handballPositions;
    return [];
  }

  // ─── Team sport helpers ───────────────────────────────────────────────────────

  static bool sportHasPositions(String? sport) {
    if (sport == null) return false;
    final teamSportKeywords = [
      'football', 'footballer', 'basketball', 'basketballer',
      'volleyball', 'volleyballer', 'handball', 'handballplayer',
      'كرة القدم', 'كرة السلة', 'الكرة الطائرة', 'كرة اليد',
    ];
    final sportLower = sport.toLowerCase().replaceAll(' ', '');
    return teamSportKeywords.any(
      (k) => sportLower.contains(k.toLowerCase().replaceAll(' ', '')),
    );
  }

  static bool isTeamSport(S s, String? sportValue) {
    if (sportValue == null) return false;
    final teamSports = [
      s.footballer, s.basketballer, s.volleyballer, s.handballPlayer,
      s.football,   s.basketball,   s.volleyball,   s.handball,
    ];
    return teamSports.contains(sportValue);
  }
}