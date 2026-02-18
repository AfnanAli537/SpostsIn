// String formatTimeAgo(DateTime dateTime) {
//   final now = DateTime.now().toUtc();
//   final date = dateTime.toUtc();

//   final difference = now.difference(date);
//   if (difference.inSeconds < 5) return 'Just now';
//   if (difference.inDays >= 365) {
//     final years = difference.inDays ~/ 365;
//     return '$years ${years == 1 ? 'year' : 'years'} ago';
//   }

//   if (difference.inDays >= 30) {
//     final months = difference.inDays ~/ 30;
//     return '$months ${months == 1 ? 'month' : 'months'} ago';
//   }

//   if (difference.inDays >= 1) {
//     return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
//   }

//   if (difference.inHours >= 1) {
//     return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
//   }

//   if (difference.inMinutes >= 1) {
//     return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
//   }

//   return '${difference.inSeconds} seconds ago';
// }
 

 import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';

String formatTimeAgo(BuildContext context, DateTime dateTime) {
  final strings = S.of(context);

  final now = DateTime.now().toUtc();
  final date = dateTime.toUtc();
  final difference = now.difference(date);

  if (difference.inSeconds < 5) {
    return strings.justNow;
  }

  if (difference.inDays >= 365) {
    final years = difference.inDays ~/ 365;
    return strings.yearsAgo(years);
  }

  if (difference.inDays >= 30) {
    final months = difference.inDays ~/ 30;
    return strings.monthsAgo(months);
  }

  if (difference.inDays >= 1) {
    return strings.daysAgo(difference.inDays);
  }

  if (difference.inHours >= 1) {
    return strings.hoursAgo(difference.inHours);
  }

  if (difference.inMinutes >= 1) {
    return strings.minutesAgo(difference.inMinutes);
  }

  return strings.secondsAgo(difference.inSeconds);
}
