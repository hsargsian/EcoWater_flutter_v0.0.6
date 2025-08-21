import 'package:easy_localization/easy_localization.dart';
import 'package:echowater/base/utils/strings.dart';

extension DateUtil on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  String humanReadableDateString(
      {required bool hasShortHad, String format = 'MMM dd'}) {
    if (hasShortHad) {
      if (isToday) {
        return 'Today'.localized;
      }
      if (isYesterday) {
        return 'Yesterday'.localized;
      }
    }

    return DateFormat(format).format(this);
  }

  bool get isDateInPast {
    final normalizedDate1 = DateTime(year, month, day);
    final now = DateTime.now();
    final normalizedDate2 = DateTime(now.year, now.month, now.day);

    return normalizedDate1.isBefore(normalizedDate2);
  }

  bool isSameDay(DateTime previousDate) {
    return day == previousDate.day &&
        month == previousDate.month &&
        year == previousDate.year;
  }

  static String? getDateFormatted(
      String? inputDateString, String inputFormat, String outputFormat) {
    if (inputDateString == null) {
      return null;
    }
    try {
      final inputDate = DateFormat(inputFormat).parse(inputDateString);
      return DateFormat(outputFormat).format(inputDate);
    } catch (e) {
      return null;
    }
  }

  static DateTime getDateObj(String inputFormat, String date,
      {bool isUTC = false}) {
    return DateFormat(inputFormat).parse(date, isUTC);
  }

  DateTime get startOfMonth {
    return DateTime(year, month);
  }

  DateTime get endOfOfMonth {
    DateTime startOfNextMonth;
    if (month == 12) {
      startOfNextMonth = DateTime(year + 1);
    } else {
      startOfNextMonth = DateTime(year, month + 1);
    }
    return startOfNextMonth.subtract(const Duration(days: 1));
  }

  DateTime get startOfWeek {
    // Subtract days to get to Sunday
    final daysToSubtract = weekday % 7;
    return subtract(Duration(days: daysToSubtract)).startOfDay;
  }

  // Get the end of the week (Saturday)
  DateTime get endOfWeek {
    // Add days to get to Saturday
    final daysToAdd = 6 - (weekday % 7);
    return add(Duration(days: daysToAdd)).endOfDay;
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  // Helper method to get the end of the day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  String get defaultStringDateFormat =>
      humanReadableDateString(hasShortHad: false, format: 'yyyy-MM-dd');

  static DateTime parseProtocolTime(String time, DateTime date) {
    final timeParts = time.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      int.parse(timeParts[2]),
    );
  }
}
