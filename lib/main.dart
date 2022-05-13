import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:instagram/core/resources/langauge_manager.dart';
import 'package:instagram/material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utility/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final SharedPreferences sharePrefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await initializeDependencies();
  runApp(EasyLocalization(
      child: Phoenix(child: MyApp(sharePrefs: sharePrefs)),
      supportedLocales: const [arabicLocal, englishLocal],
      path: assetPathLocalisations));
}
