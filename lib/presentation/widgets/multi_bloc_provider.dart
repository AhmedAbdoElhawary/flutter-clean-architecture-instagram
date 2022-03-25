import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../../injector.dart';
import '../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../cubit/postInfoCubit/post_cubit.dart';

// ignore: must_be_immutable
class MultiBloc extends StatelessWidget{
  Widget materialApp;

  MultiBloc(this.materialApp,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
        providers: [
          BlocProvider<FirebaseAuthCubit>(
            create: (context) => injector<FirebaseAuthCubit>(),
          ),
          BlocProvider<FirestoreUserInfoCubit>(
            create: (context) => injector<FirestoreUserInfoCubit>(),
          ),
          BlocProvider<FirestoreAddNewUserCubit>(
            create: (context) => injector<FirestoreAddNewUserCubit>(),
          ),
          BlocProvider<PostCubit>(
            create: (context) => injector<PostCubit>()..getAllPostInfo(),
          ),

        ],
        child: materialApp
    );
  }
}