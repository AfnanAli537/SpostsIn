import 'package:sports_in/core/enums/register_enums.dart';
import 'package:sports_in/generated/l10n.dart';

/// Centralized enum ↔ label ↔ id mapping.
class EnumMapper {
  // ---- Gender ----
  static Map<Gender, String> genderLabels(S s) => {
        Gender.male: s.male,
        Gender.female: s.female,
      };

  static int getGenderId(Gender type) {
    switch (type) {
      case Gender.male:
        return 1;
      case Gender.female:
        return 2;
    }
  }

  // ---- Sports ----
  static Map<SportType, String> sportLabels(S s) => {
        SportType.football: s.football,
        SportType.basketball: s.basketball,
        SportType.volleyball: s.volleyball,
        SportType.handball: s.handball,
        SportType.teakwando: s.teakwando,
        SportType.gymnastics: s.gymnastics,
      };

  static int getSportId(SportType type) {
    switch (type) {
      case SportType.football:
        return 1;
      case SportType.basketball:
        return 2;
      case SportType.volleyball:
        return 3;
      case SportType.handball:
        return 4;
      case SportType.teakwando:
        return 5;
      case SportType.gymnastics:
        return 6;
    }
  }
  // ---- Generic label → enum lookup ----
  static T? fromLabel<T>(Map<T, String> map, String label) {
    try {
      return map.entries
          .firstWhere((entry) => entry.value == label)
          .key;
    } catch (_) {
      return null;
    }
  }
}
