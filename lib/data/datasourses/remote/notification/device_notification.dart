import 'dart:convert';

import 'package:http/http.dart' as http;

class DeviceNotification{
 static Future<void> sendPopupNotification({
    required List<dynamic> devicesTokens,
    required String body,
    required String title,
  }) async {
    try {
      for (final token in devicesTokens) {
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
            'key=AAAA5lCz-i8:APA91bHpr30q3RMS-xIJpQXaKq5SJ7DfK32CAjS9AiHbzuR04EL6Ci8NLSikXEoi112-X6y7_0AcwPjl0NWNt3osiV2mAQtyBKc77uD8k-rLrq6YG430wWO95ruE7EXAsOgPgCFPDRXt',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{'body': body, 'title': title},
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              "to": token,
            },
          ),
        );
      }
    } catch (e) {
      return Future.error("error push notification");
    }
  }
}
