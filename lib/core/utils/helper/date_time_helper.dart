import 'dart:developer';
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

  /// 10:45 PM | Yesterday | Mon | 12/03/2026
  static String chatList(DateTime? dt) {
    if (dt == null) return '';

    final now = DateTime.now().toUtc();
    final date = dt.toUtc();

    log('now: $now');
    log('date: $date');

    if (_isSameDay(date, now)) {
      log('isToday: true');
      return DateFormat('hh:mm a').format(date.add(const Duration(hours: 2)));
    }

    if (_isYesterday(date, now)) {
      log('isYesterday: true');
      return 'Yesterday';
    }

    final diffDays = now.difference(date).inDays;

    if (diffDays < 7) {
      log('within 7 days: $diffDays');
      return DateFormat('EEE').format(date); // Mon Tue Wed
    }

    if (now.year == date.year) {
      log('same year');
      return DateFormat('dd/MM').format(date);
    }

    log('different year');
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Message bubble time
  static String messageTime(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('hh:mm a').format(dt.toLocal());
  }

  /// Date separator between messages
  static String messageDate(DateTime? dt) {
    if (dt == null) return '';

    final now = DateTime.now();
    final date = dt.toLocal();

    if (_isSameDay(date, now)) return 'Today';
    if (_isYesterday(date, now)) return 'Yesterday';

    final diffDays = now.difference(date).inDays;

    if (diffDays < 7) {
      return DateFormat('EEEE').format(date);
    }

    if (now.year == date.year) {
      return DateFormat('MMMM d').format(date);
    }

    return DateFormat('MMMM d, yyyy').format(date);
  }
}
