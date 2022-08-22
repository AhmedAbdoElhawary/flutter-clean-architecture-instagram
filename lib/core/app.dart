import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:instagram/config/themes/app_theme.dart';
import 'package:instagram/config/themes/theme_service.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/translations/app_lang.dart';
import 'package:instagram/core/translations/translations.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/pages/register/login_page.dart';
import 'package:instagram/presentation/widgets/belong_to/register_w/get_my_user_info.dart';
import 'package:instagram/presentation/widgets/global/others/multi_bloc_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  final SharedPreferences sharePrefs;
  const MyApp({Key? key, required this.sharePrefs}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? myId;
  final navigatorKey = GlobalKey<NavigatorState>();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;

  @override
  void initState() {
    myId = widget.sharePrefs.getString("myPersonalId");
    if (myId != null) myPersonalId = myId!;

    WidgetsBinding.instance.addPostFrameCallback((_) async => await onJoin());

    /// It's prefer to the here not in data_sources to avoid bugs when push notification.
    if (isThatMobile) {
      requestPermission();
      listenFCM();
      loadFCM();
    }
    super.initState();
  }

  Future<void> onJoin() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
  }

  Future<void> _handleCameraAndMic(Permission permission) async =>
      await permission.request();

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && isThatMobile) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          payload: notification.body,
          NotificationDetails(android: androidNotificationDetails()),
        );
      }
    });
  }

  AndroidNotificationDetails androidNotificationDetails() {
    return AndroidNotificationDetails(
      channel.id,
      channel.name,
      icon: 'launch_background',
      importance: Importance.max,
      enableLights: true,
      playSound: true,
      color: const Color.fromARGB(255, 0, 0, 0),
      priority: Priority.high,
      showWhen: true,
      setAsGroupSummary: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
  }

  void loadFCM() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    isThatMobile =
        platform == TargetPlatform.iOS || platform == TargetPlatform.android;
    isThatAndroid = platform == TargetPlatform.android;
    return MultiBlocs(materialApp(context));
  }

  Widget materialApp(BuildContext context) {
    return GetBuilder<AppLanguage>(
        init: AppLanguage(),
        builder: (controller) {
          return GetMaterialApp(
            translations: Translation(),
            locale: Locale(controller.appLocale),
            fallbackLocale: const Locale('en'),
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Instagram',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeOfApp().theme,
            home: AnimatedSplashScreen(
              centered: true,
              splash: IconsAssets.splashIcon,
              backgroundColor: ColorManager.white,
              splashTransition: SplashTransition.scaleTransition,
              nextScreen: myId == null
                  ? LoginPage(sharePrefs: widget.sharePrefs)
                  : GetMyPersonalInfo(myPersonalId: myId!),
            ),
          );
        });
  }
}
