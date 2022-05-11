import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram/config/themes/app_theme.dart';
import 'package:instagram/core/app_prefs.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/pages/login_page.dart';
import 'package:instagram/presentation/widgets/get_my_user_info.dart';
import 'package:instagram/presentation/widgets/multi_bloc_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  final SharedPreferences sharePrefs;
  const MyApp({Key? key, required this.sharePrefs}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? myId;
  final AppPrefMode _appPreferences = injector<AppPrefMode>();
  ThemeData? themeOfApp;
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    myId = widget.sharePrefs.getString("myPersonalId");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    themeOfApp = _appPreferences.getAppMode();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBloc(materialApp(context));
  }

  Widget materialApp(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      title: 'instagram',
      theme: themeOfApp ?? AppTheme.light,
      darkTheme: AppTheme.dark,
      home: AnimatedSplashScreen(
        centered: true,
        splash: Lottie.asset('assets/splash_gif/instagram.json'),
        nextScreen: myId == null
            ? LoginPage(sharePrefs: widget.sharePrefs)
            : GetMyPersonalId(myPersonalId: myId!),
      ),
    );
  }
}
