import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

Future<String?> initializeDefaultValues() async {

  await Future.wait([
   Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
   initializeDependencies(),
   GetStorage.init("AppLang"),
   if(!kIsWeb)_crashlytics(),
  ]);

  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

  final sharePrefs = injector<SharedPreferences>();
  String? myId = sharePrefs.getString("myPersonalId");
  if (myId != null) myPersonalId = myId;
  return myId;
}

Future<void> _crashlytics() async {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(message.data.toString());
    print(message.notification!.title);
  }
}
