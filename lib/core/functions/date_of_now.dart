import 'package:easy_localization/easy_localization.dart';

class DateReformat {
  static String dateOfNow() => DateTime.now().toString();

  static String oneDigitFormat(String theDate) {
    final DateTime dateOne = DateTime.now();
    final DateTime? dateTwo = DateTime.tryParse(theDate);
    if (dateTwo == null) return "";
    final Duration duration = dateOne.difference(dateTwo);
    int year = (duration.inDays / 256).ceil();
    int month = (duration.inDays / 30).ceil();
    int week = month * 4;
    int day = duration.inDays;
    int hour = duration.inHours;
    int minute = duration.inMinutes;
    int second = duration.inSeconds;
    return second > 60
        ? (minute > 60
            ? (hour > 24
                ? (day > 30
                    ? (week > 4
                        ? (month > 12 ? "$year y" : "$month m")
                        : "$week w")
                    : "$day d")
                : "$hour h")
            : "$minute m")
        : "$second s";
  }

  static String fullDigitsFormat(String theDate, String previousDateOfMessage) {
    DateTime theActualDate = DateTime.parse(theDate);
    DateTime thePreviousDate = DateTime.parse(previousDateOfMessage);
    DateTime now = DateTime.now();

    String dateOfToday = DateFormat(" h:m a").format(theActualDate);
    String dateOfDay = DateFormat("EEE h:m a").format(theActualDate);
    String dateOfMonth = DateFormat("MMM d, h:m a").format(theActualDate);
    String theCompleteDate =
        DateFormat("MMM d, y  h:m a").format(theActualDate);

    String theDateOTime = theActualDate.year == now.year
        ? (theActualDate.month == now.month
            ? (theActualDate.day == now.day ? "Today$dateOfToday" : dateOfDay)
            : dateOfMonth)
        : theCompleteDate;

    DateTime from = _dateTime(theActualDate);
    DateTime to = _dateTime(thePreviousDate);
    int date = from.difference(to).inHours;
    return (!theActualDate.isAtSameMomentAs(thePreviousDate) && date < 1)
        ? ""
        : theDateOTime;
  }
}

DateTime _dateTime(DateTime theDate) => DateTime(
    theDate.year, theDate.month, theDate.day, theDate.hour, theDate.minute);
