class PushNotification {
  String body;
  String title;
  String deviceToken;
  String routeParameterId;
  String notificationRoute;
  String userCallingId;
  bool isThatGroupChat;
  PushNotification({
    required this.body,
    required this.title,
    required this.deviceToken,
    this.userCallingId = '',
    required this.routeParameterId,
    required this.notificationRoute,
    this.isThatGroupChat = false,
  });

  Map<String, dynamic> toMap() => {
        'notification': <String, dynamic>{'body': body, 'title': title},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'route': notificationRoute,
          'routeParameterId': routeParameterId,
          'userCallingId': userCallingId,
          'isThatGroupChat': isThatGroupChat,
        },
        "to": deviceToken,
      };
}
