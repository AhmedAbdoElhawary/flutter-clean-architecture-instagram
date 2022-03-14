import 'package:get_it/get_it.dart';
import 'package:instegram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/firestore_add_new_user_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/firestore_get_user_info_cubit.dart';

import 'data/repositories/firebase_auth_repository_impl.dart';
import 'data/repositories/firestore_user_repo_impl.dart';
import 'domain/repositories/firebase_auth_repository.dart';
import 'domain/repositories/firestore_user_repo.dart';
import 'domain/usecases/authusecase/log_in_auth_usecase.dart';
import 'domain/usecases/authusecase/sign_up_auth_usecase.dart';
import 'domain/usecases/firestoreUsecase/add_new_user_usecase.dart';
import 'domain/usecases/firestoreUsecase/get_user_info_usecase.dart';

final injector = GetIt.I;

Future<void> initializeDependencies() async {

  injector.registerSingleton<FirebaseAuthRepository>(
    FirebaseAuthRepositoryImpl(),
  );

  injector.registerSingleton<FirestoreUserRepository>(
    FirebaseUserRepoImpl(),
  );

  // Firebase auth useCases
  injector.registerSingleton<LogInAuthUseCase>(LogInAuthUseCase(injector()));
  injector.registerSingleton<SignUpAuthUseCase>(SignUpAuthUseCase(injector()));
  // injector.registerSingleton<SignOutAuthUseCase>(SignOutAuthUseCase(injector()));
  // *

  // Firestore user useCases
  injector.registerSingleton<AddNewUserUseCase>(AddNewUserUseCase(injector()));
  injector.registerSingleton<GetUserInfoUseCase>(GetUserInfoUseCase(injector()));
  // *

  // auth Blocs
  injector.registerFactory<FirebaseAuthCubit>(
    () => FirebaseAuthCubit(injector(), injector()),
  );
  // *

  // user Blocs
  injector.registerFactory<FirestoreAddNewUserCubit>(
    () => FirestoreAddNewUserCubit(injector()),
  );
  injector.registerFactory<FirestoreGetUserInfoCubit>(
        () => FirestoreGetUserInfoCubit(injector()),
  );
  // *
}
