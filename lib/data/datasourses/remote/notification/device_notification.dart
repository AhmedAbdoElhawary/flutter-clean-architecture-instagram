import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instagram/core/private_keys.dart';

class DeviceNotification {
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
            'Authorization': notificationKey,
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
