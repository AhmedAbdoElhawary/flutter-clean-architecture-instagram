part of '../firestoreUserInfoCubit/firestore_get_user_info_cubit.dart';

abstract class FirestoreGetUserInfoState {}

class CubitInitial extends FirestoreGetUserInfoState {}

class CubitUserLoading extends FirestoreGetUserInfoState {}

class CubitUserLoaded extends FirestoreGetUserInfoState {
  UserPersonalInfo userPersonalInfo;

  CubitUserLoaded(this.userPersonalInfo);

}

class CubitGetUserInfoFailed extends FirestoreGetUserInfoState {
  final String error;
  CubitGetUserInfoFailed(this.error);
}
