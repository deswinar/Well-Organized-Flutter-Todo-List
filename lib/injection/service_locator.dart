import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/domain/auth_bloc.dart';
import '../features/todo/data/todo_repository.dart';
import '../features/todo/domain/todo_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Register FirebaseAuth as a lazy singleton
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  // Register Repositories (One instance, created only when first needed)
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<FirebaseAuth>()));

  // Register Blocs (New instance every time it is requested)
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));

  // TodoRepository and TodoBloc
  getIt.registerLazySingleton<TodoRepository>(() => TodoRepository(
        getIt<FirebaseFirestore>(),
        getIt<AuthRepository>(),
      ));

  // Todo Bloc
  getIt.registerFactory<TodoBloc>(() => TodoBloc(getIt<TodoRepository>()));
}
