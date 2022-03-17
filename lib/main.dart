import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/firestore_add_new_user_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/firestore_get_user_info_cubit.dart';
import 'package:instegram/presentation/pages/login_page.dart';
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
  runApp(MultiBlocProvider(providers: [
    BlocProvider<FirebaseAuthCubit>(
      create: (context) => injector<FirebaseAuthCubit>(),
    ),
    BlocProvider<FirestoreGetUserInfoCubit>(
      create: (context) => injector<FirestoreGetUserInfoCubit>(),
    ),
    BlocProvider<FirestoreAddNewUserCubit>(
      create: (context) => injector<FirestoreAddNewUserCubit>(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'instagram',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.transparent,
      ),
      home: LoginPage(),
    );
  }
}
