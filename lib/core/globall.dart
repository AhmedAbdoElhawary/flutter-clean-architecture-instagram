import 'package:intl/intl.dart';

class DateOfNow {
 static String dateOfNow() {
    DateTime now = DateTime.now();
    DateFormat formatterDate = DateFormat('y/M/d');
    String actualDate = formatterDate.format(now);
    actualDate += "/${now.hour}/${now.minute}";
    return actualDate;
  }

 static String differenceDateOfNow(String theDate) {
    DateTime now = DateTime.now();
    List dateDetails = theDate.split("/");
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
}
