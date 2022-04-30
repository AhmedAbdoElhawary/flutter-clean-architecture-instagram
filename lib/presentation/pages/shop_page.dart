import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instegram/core/resources/strings_manager.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(StringsManager.underWork.tr()),),
    );
  }
}
