import 'package:sports_in/generated/l10n.dart';

/// Mirrors the backend enum values 1–6 for TargetAudience.
/// The raw int value is what gets sent to the API (e.g. targetAudiences: [1, 3]).
enum TargetAudience {
  player,    
  coach,     
  scout,     
  club,      
  institute, 
  other,  
}

class TargetAudienceMapper {
  static int toId(TargetAudience audience) {
    return audience.index + 1;
  }

  static TargetAudience? fromId(int id) {
    final index = id - 1;
    if (index < 0 || index >= TargetAudience.values.length) return null;
    return TargetAudience.values[index];
  }

  static String toLabel(TargetAudience audience, S string) {
    switch (audience) {
      case TargetAudience.player:
        return string.player;
      case TargetAudience.coach:
        return string.coach;
      case TargetAudience.scout:
        return string.scout;
      case TargetAudience.club:
        return string.club;
      case TargetAudience.institute:
        return string.institute;
      case TargetAudience.other:
        return string.other;
    }
  }

  // human-readable label → enum
  static TargetAudience? fromLabel(String label, S string) {
    for (final a in TargetAudience.values) {
      if (toLabel(a, string).toLowerCase() == label.toLowerCase()) return a;
    }
    return null;
  }

  static List<String> allLabels(S string) =>
      TargetAudience.values.map((a) => toLabel(a, string)).toList();

  static List<int> labelsToIds(List<String> labels, S string) {
    return labels
        .map((label) => fromLabel(label, string))
        .whereType<TargetAudience>()
        .map(toId)
        .toList();
  }

  static List<String> idsToLabels(List<int> ids, S string) {
    return ids
        .map(fromId)
        .whereType<TargetAudience>()
        .map((a) => toLabel(a, string))
        .toList();
  }
}