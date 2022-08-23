import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/strings_manager.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(StringsManager.underWork.tr,
            style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
