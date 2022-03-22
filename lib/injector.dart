import 'package:get_it/get_it.dart';
import 'package:instegram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'data/repositories/firebase_auth_repository_impl.dart';
import 'data/repositories/firestore_post_repo_impl.dart';
import 'data/repositories/firestore_user_repo_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/authUsecase/sign_out_auth_usecase.dart';
import 'domain/usecases/authusecase/log_in_auth_usecase.dart';
import 'domain/usecases/authusecase/sign_up_auth_usecase.dart';
import 'domain/usecases/firestoreUserUseCase/upload_profile_image_usecase.dart';
import 'domain/usecases/firestoreUserUsecase/add_new_user_usecase.dart';
import 'domain/usecases/firestoreUserUsecase/get_user_info_usecase.dart';
import 'domain/usecases/firestoreUserUsecase/update_user_info.dart';
import 'domain/usecases/postUseCase/create_post.dart';

final injector = GetIt.I;

Future<void> initializeDependencies() async {
  // Repository
  injector.registerSingleton<FirestorePostRepository>(
    FirestorePostRepositoryImpl(),
  );
  injector.registerSingleton<FirebaseAuthRepository>(
    FirebaseAuthRepositoryImpl(),
  );
  injector.registerSingleton<FirestoreUserRepository>(
    FirebaseUserRepoImpl(),
  );

  // Firebase auth useCases
  injector.registerSingleton<LogInAuthUseCase>(LogInAuthUseCase(injector()));
  injector.registerSingleton<SignUpAuthUseCase>(SignUpAuthUseCase(injector()));
  injector
      .registerSingleton<SignOutAuthUseCase>(SignOutAuthUseCase(injector()));
  // *
  // Firestore user useCases
  injector.registerSingleton<AddNewUserUseCase>(AddNewUserUseCase(injector()));
  injector
      .registerSingleton<GetUserInfoUseCase>(GetUserInfoUseCase(injector()));
  injector.registerSingleton<UpdateUserInfoUseCase>(
      UpdateUserInfoUseCase(injector()));
  injector.registerSingleton<UploadProfileImageUseCase>(
      UploadProfileImageUseCase(injector()));
  // *
  // Firestore Post useCases
  injector.registerSingleton<CreatePostUseCase>(CreatePostUseCase(injector()));
  // *

  // auth Blocs
  injector.registerFactory<FirebaseAuthCubit>(
    () => FirebaseAuthCubit(injector(), injector(), injector()),
  );
  // *

  // user Blocs
  injector.registerFactory<FirestoreAddNewUserCubit>(
    () => FirestoreAddNewUserCubit(injector()),
  );
  injector.registerFactory<FirestoreUserInfoCubit>(
    () => FirestoreUserInfoCubit(injector(), injector(), injector()),
  );
  // *

  // post Blocs
  injector.registerFactory<PostCubit>(
    () => PostCubit(injector()),
  );
  // *
}
