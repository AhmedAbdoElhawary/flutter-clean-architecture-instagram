import 'package:intl/intl.dart';

class DateOfNow{
  static String dateOfNow(){
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    String formattedDate = formatter.format(now);
    formattedDate += "/${now.hour}/${now.minute}";
    return formattedDate;
  }
}