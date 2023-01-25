import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/callingRooms/calling_rooms_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/pages/messages/chatting_page.dart';
import 'package:instagram/presentation/pages/messages/video_call_page.dart';
import 'package:instagram/presentation/pages/profile/widgets/which_profile_page.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/get_post_info.dart';

late FlutterLocalNotificationsPlugin _normalLocalNotifications;
late AndroidNotificationChannel _normalChannel;
late FlutterLocalNotificationsPlugin _videoCallLocalNotifications;
late AndroidNotificationChannel _videoCallChannel;

Future<void> notificationPermissions(BuildContext context) async {
  await _requestPermission();
  // ignore: use_build_context_synchronously
  await _listenFCM(context);
  // ignore: use_build_context_synchronously
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
      dynamic route = message.data["route"] ?? "";
      dynamic routeParameterId = message.data["routeParameterId"] ?? "";

      /// in case calling
      dynamic userCallingId = message.data["userCallingId"] ?? "";
      dynamic isThatGroupChat = message.data["isThatGroupChat"] ?? false;

      bool isThatVideoCall = route == "call";
      if (isThatVideoCall) {
        _videoCallLocalNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          payload: "$route,$routeParameterId,$userCallingId,$isThatGroupChat",
          NotificationDetails(
              android: _videoCallAndroidNotificationDetails(
                  channel: _videoCallChannel, isThatCalling: true)),
        );
      } else {
        _normalLocalNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          payload: "$route,$routeParameterId",
          NotificationDetails(
              android: _videoCallAndroidNotificationDetails(
                  channel: _normalChannel)),
        );
      }
    }
  });

  /// When app is onBackground
  FirebaseMessaging.onMessageOpenedApp
      .listen((m) async => await _handleMessage(context, m));
}

Future<void> _handleMessage(BuildContext context, RemoteMessage message) async {
  await _pushToPage(context,
      route: message.data["route"] ?? "",
      routeParameterId: message.data["routeParameterId"] ?? "",
      userCallingId: message.data["userCallingId"] ?? "",
      isThatGroupChat: message.data["isThatGroupChat"] ?? false);
}

Future<void> _pushToPage(
  BuildContext context, {
  required dynamic route,
  required dynamic routeParameterId,
  required dynamic userCallingId,
  required dynamic isThatGroupChat,
}) async {
  Widget page;
  if (route == "post") {
    page = GetsPostInfoAndDisplay(
      postId: routeParameterId,
      appBarText: StringsManager.post.tr,
    );
  } else if (route == "profile") {
    page = WhichProfilePage(userId: routeParameterId);
  } else if (route == "call") {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    await CallingRoomsCubit.get(context).joinToRoom(
        channelId: routeParameterId, myPersonalInfo: myPersonalInfo);
    page = CallPage(
      channelName: routeParameterId,
      role: ClientRole.Broadcaster,
      userCallingId: userCallingId,
      userCallingType: UserCallingType.receiver,
    );
  } else {
    page = BlocProvider<MessageBloc>(
      create: (context) => injector<MessageBloc>(),
      child:
          ChattingPage(chatUid: routeParameterId, isThatGroup: isThatGroupChat),
    );
  }

  // ignore: use_build_context_synchronously
  await Go(context).push(page: page);
}

AndroidNotificationDetails _videoCallAndroidNotificationDetails(
    {required AndroidNotificationChannel channel, bool isThatCalling = false}) {
  return AndroidNotificationDetails(
    channel.id,
    channel.name,
    icon: 'launch_background',
    importance: Importance.max,
    enableLights: true,
    playSound: true,
    priority: Priority.high,
    // showWhen: true,
    setAsGroupSummary: true,
    timeoutAfter: isThatCalling ? 75000 : null,
    fullScreenIntent: isThatCalling,
    sound: isThatCalling
        ? const RawResourceAndroidNotificationSound('video')
        : const RawResourceAndroidNotificationSound('notification'),
  );
}

Future<void> _loadFCM(BuildContext context) async {
  _normalChannel = _androidNotificationChannel();
  _videoCallChannel = _androidNotificationChannel(isThatCalling: true);

  _normalLocalNotifications = FlutterLocalNotificationsPlugin();
  _videoCallLocalNotifications = FlutterLocalNotificationsPlugin();

  await _normalLocalNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_normalChannel);

  await _videoCallLocalNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_videoCallChannel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("launch_background"));

  /// when app opened and select the message
  _normalLocalNotifications.initialize(initializationSettings,
      onSelectNotification: (p) => _onSelectNotification(context, p));

  _videoCallLocalNotifications.initialize(initializationSettings,
      onSelectNotification: (p) => _onSelectNotification(context, p));

  /// When app is close
  // ignore: use_build_context_synchronously
  await _detailsWhenAppClose(context);
}

Future<void> _detailsWhenAppClose(BuildContext context) async {
  final normalDetails =
      await _normalLocalNotifications.getNotificationAppLaunchDetails();
  if (normalDetails != null && normalDetails.didNotificationLaunchApp) {
    String? payload = normalDetails.payload;
    if (payload != null) {
      List<String> data = payload.split(",");
      int length = data.length;
      dynamic userCallingId = length > 2 ? data[2] : "";
      if (userCallingId != "") {
        final videoDetails = await _videoCallLocalNotifications
            .getNotificationAppLaunchDetails();
        if (videoDetails != null && videoDetails.didNotificationLaunchApp) {
          // ignore: use_build_context_synchronously
          await _onSelectNotification(context, videoDetails.payload);
        }
      } else {
        // ignore: use_build_context_synchronously
        await _onSelectNotification(context, payload);
      }
    }
  }
}

_onSelectNotification(BuildContext context, String? payload) async {
  if (payload != null) {
    List<String> data = payload.split(",");
    int length = data.length;
    if (length < 2) return;
    String route = "", routeParameterId = "", userCallingId = "";
    dynamic isThatGroupChat = false;
    route = data[0];
    routeParameterId = data[1];
    userCallingId = length > 2 ? data[2] : "";
    isThatGroupChat = length > 3 ? data[3] : false;

    if (userCallingId.isEmpty) {
      await _pushToPage(
        context,
        route: route,
        routeParameterId: routeParameterId,
        userCallingId: userCallingId,
        isThatGroupChat: isThatGroupChat,
      );
    }
  }
}

AndroidNotificationChannel _androidNotificationChannel(
    {bool isThatCalling = false}) {
  final int id = DateTime.now().microsecondsSinceEpoch ~/ 1000;

  return AndroidNotificationChannel(
    id.toString(),
    'high_importance_channel',
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
    showBadge: true,
    sound: isThatCalling
        ? const RawResourceAndroidNotificationSound('video')
        : const RawResourceAndroidNotificationSound('notification'),
  );
}
