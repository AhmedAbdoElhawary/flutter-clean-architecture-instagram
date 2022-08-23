import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    myId = widget.sharePrefs.getString("myPersonalId");
    if (myId != null) myPersonalId = myId!;

    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await callVideoPermissions());

    super.initState();
  }

  Future<void> callVideoPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
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
