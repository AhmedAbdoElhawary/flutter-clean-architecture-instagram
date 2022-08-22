

class PushNotification {
  String body;
  String title;
  String deviceToken;
  String routeParameterId;
  String notificationRoute;
  PushNotification({
    required this.body,
    required this.title,
    required this.deviceToken,
    required this.routeParameterId,
    required this.notificationRoute,
  });


  Map<String, dynamic> toMap() => {
        'notification': <String, dynamic>{'body': body, 'title': title},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'route': notificationRoute,
          'routeParameterId': routeParameterId,
        },
        "to": deviceToken,
      };
}
