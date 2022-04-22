import 'package:intl/intl.dart';

class DateOfNow {
  static String dateOfNow() {
    DateTime now = DateTime.now();
    print(now);
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

    // the if statement

    // if (year == 0) {
    //   if (month == 0) {
    //     if (day == 0) {
    //       if (hour == 0) {
    //         return "${minute}m";
    //       } else {
    //         return "${hour}h";
    //       }
    //     } else {
    //       return "${day}d";
    //     }
    //   } else {
    //     int week1 = month * 4;
    //     if (day != 0) {
    //       int week2 = day ~/ 7;
    //       return "${week2 + week1}w";
    //     }
    //     return "${week1}w";
    //   }
    // } else {
    //   return "${year}y";
    // }
  }

  static String chattingDateOfNow(
      String theDate, String previousDateOfMassage) {
    DateTime theActualDate = DateTime.parse(theDate);
    DateTime thePreviousDate = DateTime.parse(previousDateOfMassage);
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
    int date = to.difference(from).inHours;
    return (!theActualDate.isAtSameMomentAs(thePreviousDate) && date < 1)
        ? ""
        : theDateOTime;

    // the if statement
    // if(theActualDate.year==now.year){
    //   if(theActualDate.month==now.month){
    //     if(theActualDate.day==now.day){
    //       return "Today$dateOfToday";
    //     }else{
    //       return dateOfDay;
    //     }
    //   }else{
    //     return dateOfMonth;
    //   }
    //
    // }else{
    //   return theCompleteDate;
    // }
  }
}