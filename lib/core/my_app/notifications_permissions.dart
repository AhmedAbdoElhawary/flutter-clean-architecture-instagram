import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/pages/messages/chatting_page.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/get_post_info.dart';

late FlutterLocalNotificationsPlugin _localNotifications;
late AndroidNotificationChannel _channel;

Future<void> notificationPermissions(BuildContext context) async {
  await _requestPermission();
  await _listenFCM(context);
  await _loadFCM(context);
}

Future<void> _requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );
}

Future<void> _listenFCM(BuildContext context) async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        payload: "${message.data["route"]},${message.data["routeParameterId"]}",
        NotificationDetails(android: _androidNotificationDetails()),
      );
    }
  });



  /// When app is close
  FirebaseMessaging.instance.getInitialMessage().then((value) async {
    if (value != null)await _handleMessage(context, value);
  });

  /// When app is onBackground
  FirebaseMessaging.onMessageOpenedApp
      .listen((m) async =>await _handleMessage(context, m));
}

Future<void> _handleMessage(BuildContext context, RemoteMessage message) async{
 await _pushToPage(
      route: message.data["route"],
      routeParameterId: message.data["routeParameterId"],
      context);
}

Future<void> _pushToPage(BuildContext context,
    {required dynamic route, required dynamic routeParameterId}) async {
  Widget page;
  if (route == "post") {
    page = GetsPostInfoAndDisplay(
      postId: routeParameterId,
      appBarText: StringsManager.post.tr,
    );
  } else if (route == "profile") {
    page = WhichProfilePage(userId: routeParameterId);
  } else {
    page = BlocProvider<MessageBloc>(
      create: (context) => injector<MessageBloc>(),
      child: ChattingPage(userId: routeParameterId),
    );
  }
  await pushToPage(context, page: page);
}

AndroidNotificationDetails _androidNotificationDetails() {
  return AndroidNotificationDetails(
    _channel.id,
    _channel.name,
    icon: 'launch_background',
    importance: Importance.max,
    enableLights: true,
    playSound: true,
    priority: Priority.high,
    showWhen: true,
    setAsGroupSummary: true,
    sound: const RawResourceAndroidNotificationSound('notification'),
  );
}

Future<void> _loadFCM(BuildContext context) async {
  final int id = DateTime.now().microsecondsSinceEpoch ~/ 1000;
  _channel = AndroidNotificationChannel(
    id.toString(),
    'high_importance_channel',
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
    showBadge: true,
    sound: const RawResourceAndroidNotificationSound('notification'),
  );

  _localNotifications = FlutterLocalNotificationsPlugin();
  await _localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("launch_background"));

  /// when app opened and select the message
  _localNotifications.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      List<String> s = payload.split(",");
      String route = s[0];
      String routeParameterId = s[1];
      await _pushToPage(
          route: route, routeParameterId: routeParameterId, context);
    }
  });
}
