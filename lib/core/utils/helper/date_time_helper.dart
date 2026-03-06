import 'package:intl/intl.dart';

class ChatTimeHelper {
  const ChatTimeHelper._();

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool _isYesterday(DateTime date, DateTime now) {
    final yesterday = now.subtract(const Duration(days: 1));
    return _isSameDay(date, yesterday);
  }

  /// Returns a formatted time string for chat list display
  /// Format: "10:45 PM" (today) | "Yesterday" | "Mon" | "12/03" | "12/03/2026"
  static String chatList(DateTime? dt) {
    if (dt == null) return '';

    final now = DateTime.now();
    // If server sent UTC, convert once to local to avoid 2h diff
    final date = dt.isUtc ? dt.toLocal() : dt;

    // Remove time component for accurate day comparisons
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);

    if (_isSameDay(compareDate, today)) {
      return DateFormat('hh:mm a').format(date);
    }

    if (_isYesterday(compareDate, today)) {
      return 'Yesterday';
    }

    final diffDays = today.difference(compareDate).inDays;

    if (diffDays < 7) {
      return DateFormat('EEE').format(date); // Mon, Tue, Wed, etc.
    }

    if (now.year == date.year) {
      return DateFormat('dd/MM').format(date); // Same year: show day/month
    }

    return DateFormat(
      'dd/MM/yyyy',
    ).format(date); // Different year: show full date
  }

  static String messageTime(DateTime? dt) {
    if (dt == null) return '';

    // If server sent UTC, convert once to local to avoid 2h diff; otherwise use as-is
    final date = dt.isUtc ? dt.toLocal() : dt;

    return DateFormat('hh:mm a').format(date);
  }
}
