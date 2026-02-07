// /// Helper function to format time ago 
// String formatTimeAgo(DateTime dateTime) {
//   final now = DateTime.now();
//   final difference = now.difference(dateTime);

//   if (difference.inDays > 365) {
//     final years = (difference.inDays / 365).floor();
//     return '$years ${years == 1 ? 'year' : 'years'} ago';
//   } else if (difference.inDays > 30) {
//     final months = (difference.inDays / 30).floor();
//     return '$months ${months == 1 ? 'month' : 'months'} ago';
//   } else if (difference.inDays > 0) {
//     return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
//   } else if (difference.inHours > 0) {
//     return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
//   } else if (difference.inMinutes > 0) {
//     return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
//   } else {
//     return 'Just now';
//   }
// }



String formatTimeAgo(DateTime dateTime) {
  // 1. Convert both to UTC to remove timezone offsets from the math
  final now = DateTime.now().toUtc();
  final date = dateTime.toUtc();

  final difference = now.difference(date);

  // 2. Handle potential clock skew (if post time is slightly in the future)
  if (difference.inSeconds < 5) return 'Just now';

  // 3. Logic for time units
  if (difference.inDays >= 365) {
    final years = difference.inDays ~/ 365;
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }

  if (difference.inDays >= 30) {
    final months = difference.inDays ~/ 30;
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  }

  if (difference.inDays >= 1) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  }

  if (difference.inHours >= 1) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  }

  if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  }

  return '${difference.inSeconds} seconds ago';
}
 