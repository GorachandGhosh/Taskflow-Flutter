import 'package:intl/intl.dart';

/// Clean date formatting utility for task due dates and timestamps.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _displayFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _dayHeaderFormat = DateFormat('EEEE, d MMMM');

  /// Formats date for display: "Today", "Tomorrow", "Yesterday", or "13 Sep 2026"
  static String formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final difference = target.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else {
      return _displayFormat.format(date);
    }
  }

  /// Full formatted date string (e.g., "13 Sep 2026")
  static String formatDate(DateTime date) {
    return _displayFormat.format(date);
  }

  /// Full formatted timestamp string (e.g., "13 Sep 2026, 04:30 PM")
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  /// Categorizes date for group headers: "TODAY", "TOMORROW", "THIS WEEK", or "LATER"
  static String getDateGroupCategory(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final diff = target.difference(today).inDays;

    if (diff < 0) {
      return 'OVERDUE';
    } else if (diff == 0) {
      return 'TODAY';
    } else if (diff == 1) {
      return 'TOMORROW';
    } else if (diff <= 7) {
      return 'THIS WEEK';
    } else {
      return 'UPCOMING';
    }
  }

  /// Day header for Home Screen (e.g. "Today, 1 May")
  static String formatHeaderDate(DateTime date) {
    return _dayHeaderFormat.format(date);
  }
}
