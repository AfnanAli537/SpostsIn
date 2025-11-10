import 'package:sports_in/core/enums/register_enums.dart';
import 'package:sports_in/generated/l10n.dart';

class EnumMapper {
  static Map<Gender, String> genderLabels([S? s]) => {
        Gender.male: s?.male ?? 'Male',
        Gender.female: s?.female ?? 'Female',
      };

  static int getGenderId(Gender type) {
    switch (type) {
      case Gender.male:
        return 1;
      case Gender.female:
        return 2;
    }
  }

  static Map<SportType, String> sportLabels([S? s]) => {
        SportType.football: s?.football ?? 'Football',
        SportType.basketball: s?.basketball ?? 'Basketball',
        SportType.volleyball: s?.volleyball ?? 'Volleyball',
        SportType.handball: s?.handball ?? 'Handball',
        SportType.teakwando: s?.teakwando ?? 'Teakwando',
        SportType.gymnastics: s?.gymnastics ?? 'Gymnastics',
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

  static T? fromLabel<T>(Map<T, String> map, String label) {
    try {
      return map.entries.firstWhere(
        (entry) => entry.value.toLowerCase() == label.toLowerCase(),
      ).key;
    } catch (_) {
      return null;
    }
  }
}
