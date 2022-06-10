import 'package:intl/intl.dart';

class DateOfNow {
  static String dateOfNow() {
    DateTime now = DateTime.now();
    return now.toString();
  }

  static String commentsDateOfNow(String theDate) {
    DateTime now = DateTime.now();
    List dateDetails = _splitTheDate(theDate);
    int year = now.year - int.parse(dateDetails[0]);
    int month = now.month - int.parse(dateDetails[1]);
    int day = now.day - int.parse(dateDetails[2]);
    int hour = now.hour - int.parse(dateDetails[3]);
    int minute = now.minute - int.parse(dateDetails[4]);
    int week = month * 4;
    return year == 0
        ? (month == 0
            ? (day == 0 ? (hour == 0 ? "${minute}m" : "${hour}h") : "${day}d")
            : "${day != 0 ? day ~/ 7 + week : week}w")
        : ("${year}y");
  }

  static String chattingDateOfNow(
      String theDate, String previousDateOfMessage) {
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

List _splitTheDate(String theDate) {
  List dateDetails;
  if (theDate.split("/").length > 2) {
    dateDetails = theDate.split("/");
  } else {
    dateDetails = theDate.split("-");
    List<String> w1 = dateDetails[2].split(" ");
    List<String> w2 = w1[1].split(":");
    w1.removeAt(1);
    dateDetails += w1 + w2;
    dateDetails.removeAt(2);
  }
  return dateDetails;
}

DateTime _dateTime(DateTime theDate) => DateTime(
    theDate.year, theDate.month, theDate.day, theDate.hour, theDate.minute);
