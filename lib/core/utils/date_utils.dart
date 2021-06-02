import 'package:intl/intl.dart';

// coverage:ignore-file
class CustomDateUtils {
  static String getStrDate(DateTime? date, {String? pattern, String? locale}) {
    final defaultFormat = locale != null
        ? DateFormat('dd/MM/yyyy', locale)
        : DateFormat('dd/MM/yyyy');

    if (date == null || date.millisecondsSinceEpoch == 0) {
      return '';
    }

    DateFormat? format;
    if (pattern != null) {
      try {
        format =
            locale != null ? DateFormat(pattern, locale) : DateFormat(pattern);
      } on Exception catch (e) {
        throw Exception('errorDatePattern: $e');
      }
    }

    String formattedDate;
    if (format != null) {
      formattedDate = format.format(date);
    } else {
      formattedDate = defaultFormat.format(date);
    }
    return formattedDate;
  }

  DateTime getDateTimeFromTime(String time) {
    final now = DateTime.now();
    final timeList = time.split(':');

    var hour = int.tryParse(timeList.first);
    var minute = int.tryParse(timeList[1]);

    final dateTime =
        DateTime(now.year, now.month, now.day, hour ?? 0, minute ?? 0);

    return dateTime;
  }
}
