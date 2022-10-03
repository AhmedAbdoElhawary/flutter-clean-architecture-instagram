import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram/core/app.dart';

/// follow README.md to know how to add this file
import 'package:instagram/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utility/injector.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(message.data.toString());
    print(message.notification!.title);
  }
}

Future<void> main() async {
  final sharePrefs = await init();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  Widget myApp = Phoenix(child: MyApp(sharePrefs: sharePrefs));
  runApp(myApp);
}

Future<SharedPreferences> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  await GetStorage.init();
  if (!kIsWeb) {
    await crashlytics();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  return await SharedPreferences.getInstance();
}

crashlytics() async {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
}
