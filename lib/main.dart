import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instegram/presentation/pages/login_page.dart';
import 'package:instegram/presentation/widgets/multi_bloc_provider.dart';
import 'package:lottie/lottie.dart';
import 'config/routes/app_routes.dart';
import 'injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDunLPbW_YPXUGsXvlF7fD0vXX9Fix7yjg",
            appId: "1:989196450351:web:f707cdceb20709083764da",
            messagingSenderId: "989196450351",
            projectId: "el-instagram",
            storageBucket: "el-instagram.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
  await initializeDependencies();
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBloc(materialApp());
  }

  static Widget materialApp() {
    return Localizations(
        locale: const Locale('en', 'US'),
        delegates: const <LocalizationsDelegate<dynamic>>[
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'instagram',
          theme: ThemeData(
            appBarTheme:const AppBarTheme(
              elevation: 0,
              color: Colors.white,
            ),
            primarySwatch: Colors.grey,
            scaffoldBackgroundColor: Colors.white,
            canvasColor: Colors.transparent,
          ),
          home: AnimatedSplashScreen(
            centered: true,
            splash: Lottie.asset('assets/splash_gif/instagram.json'),
            nextScreen: const LoginPage(),
          ),
        ));
  }
}
