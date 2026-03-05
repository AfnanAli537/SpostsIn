import 'package:intl/intl.dart';

/// Helper utilities for displaying human‑friendly DateTime values.
class DateTimeHelper {
  const DateTimeHelper._();

  /// Short relative label used in chat lists, e.g. `2m`, `3h`, `5d`, `12/3`.
  static String formatShortRelative(DateTime? dt) {
    if (dt == null) return '';

    final diff = DateTime.now().difference(dt);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';

    // Fallback to day/month for older messages
    return DateFormat('d/M').format(dt);
  }
}

