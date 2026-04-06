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

  static int? sportLabelToId(String label) {
    final map = sportLabels();
    final enum_ = fromLabel(map, label);
    return enum_ != null ? getSportId(enum_) : null;
  }

  static List<int> sportLabelsToIds(List<String> labels) {
    return labels
        .map((label) => sportLabelToId(label))
        .whereType<int>()
        .toList();
  }

  static int? genderLabelToId(String label) {
    final map = genderLabels();
    final enum_ = fromLabel(map, label);
    if (enum_ == Gender.male) return 1;
    if (enum_ == Gender.female) return 2;
    return null;
  }

  static String? sportIdToLabel(int id, [S? s]) {
    switch (id) {
      case 1:
        return s?.football ?? 'Football';
      case 2:
        return s?.basketball ?? 'Basketball';
      case 3:
        return s?.volleyball ?? 'Volleyball';
      case 4:
        return s?.handball ?? 'Handball';
      case 5:
        return s?.teakwando ?? 'Teakwando';
      case 6:
        return s?.gymnastics ?? 'Gymnastics';
      default:
        return null;
    }
  }

  static List<String> sportIdsToLabels(List<int> ids, [S? s]) {
    return ids
        .map((id) => sportIdToLabel(id, s))
        .whereType<String>()
        .toList();
  }

  static String? genderIdToLabel(int id, [S? s]) {
    switch (id) {
      case 1:
        return s?.male ?? 'Male';
      case 2:
        return s?.female ?? 'Female';
      default:
        return null;
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

  static T? fromEnum<T>(Map<T, String> map, String label) {
    try {
      return map.entries.firstWhere(
        (entry) => entry.value.toLowerCase() == label.toLowerCase(),
      ).key;
    } catch (_) {
      return null;
    }
  }
}
