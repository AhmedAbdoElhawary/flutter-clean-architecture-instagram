import 'package:custom_gallery_display/custom_gallery_display.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram/core/app.dart';
import 'package:instagram/core/utility/private_keys.dart';
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
  if (kIsWeb) {
    // I deleted private_keys in github project,
    // so create your own firebase project and add your web private keys here and in web/index.html.
    await Firebase.initializeApp(
      options: FirebaseOptions(
        measurementId: measurementId,
        databaseURL: databaseURL,
        authDomain: authDomain,
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
      ),
    );
  } else {
    await Firebase.initializeApp();
    await CustomGalleryPermissions.requestPermissionExtend();
  }

  await initializeDependencies();
  await GetStorage.init();
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  return await SharedPreferences.getInstance();
}
