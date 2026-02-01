String formatDecisionDate(String? isoString) {
  if (isoString == null || isoString.trim().isEmpty) return '';
  try {
    final date = DateTime.parse(isoString).toLocal();
    final weekday = _weekdayName(date.weekday).toUpperCase();
    final month = _monthName(date.month);
    final dayOrdinal = _ordinal(date.day);
    final time = _formatTime12h(date);
    return '$weekday ${date.day}$dayOrdinal $month ${date.year} · $time';
  } catch (_) {
    return isoString;
  }
}

String _weekdayName(int weekday) {
  const names = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return names[(weekday - 1).clamp(0, 6)];
}

String _monthName(int month) {
  const names = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return names[(month - 1).clamp(0, 11)];
}

String _ordinal(int day) {
  if (day >= 11 && day <= 13) return 'th';
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String _formatTime12h(DateTime date) {
  var hour = date.hour;
  final minute = date.minute;
  final period = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  if (hour == 0) hour = 12;
  final minuteStr = minute.toString().padLeft(2, '0');
  return '$hour:$minuteStr $period';
}
