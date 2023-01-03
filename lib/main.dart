import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:instagram/core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget myApp = Phoenix(child: const MyApp());
  runApp(myApp);
}
