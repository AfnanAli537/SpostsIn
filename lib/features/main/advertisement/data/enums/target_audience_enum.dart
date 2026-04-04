/// Mirrors the backend enum values 1–6 for TargetAudience.
/// The raw int value is what gets sent to the API (e.g. targetAudiences: [1, 3]).
enum TargetAudience {
  player,    // 1
  coach,     // 2
  scout,     // 3
  club,      // 4
  institute, // 5
  other,     // 6
}

class TargetAudienceMapper {
  // enum → backend int  (1-based)
  static int toId(TargetAudience audience) {
    return audience.index + 1;
  }

  // backend int → enum
  static TargetAudience? fromId(int id) {
    final index = id - 1;
    if (index < 0 || index >= TargetAudience.values.length) return null;
    return TargetAudience.values[index];
  }

  // enum → human-readable label
  static String toLabel(TargetAudience audience) {
    switch (audience) {
      case TargetAudience.player:
        return 'Player';
      case TargetAudience.coach:
        return 'Coach';
      case TargetAudience.scout:
        return 'Scout';
      case TargetAudience.club:
        return 'Club';
      case TargetAudience.institute:
        return 'Institute';
      case TargetAudience.other:
        return 'Other';
    }
  }

  // human-readable label → enum
  static TargetAudience? fromLabel(String label) {
    for (final a in TargetAudience.values) {
      if (toLabel(a).toLowerCase() == label.toLowerCase()) return a;
    }
    return null;
  }

  // All display labels (used to populate the CheckboxDropdownOverlay)
  static List<String> allLabels() =>
      TargetAudience.values.map(toLabel).toList();

  // Convert a list of labels (from the checkbox widget) → list of ints (for API)
  static List<int> labelsToIds(List<String> labels) {
    return labels
        .map(fromLabel)
        .whereType<TargetAudience>()
        .map(toId)
        .toList();
  }

  // Convert a list of ints (from API) → list of labels (for the checkbox widget)
  static List<String> idsToLabels(List<int> ids) {
    return ids
        .map(fromId)
        .whereType<TargetAudience>()
        .map(toLabel)
        .toList();
  }
}