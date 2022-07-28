import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:instagram/config/themes/app_theme.dart';
import 'package:instagram/config/themes/theme_service.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/pages/register/login_page.dart';
import 'package:instagram/presentation/widgets/belong_to/register_w/get_my_user_info.dart';
import 'package:instagram/presentation/widgets/global/others/multi_bloc_provider.dart';
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
  @override
  void initState() {
    myId = widget.sharePrefs.getString("myPersonalId");
    super.initState();
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
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      title: 'instagram',
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
  }
}
