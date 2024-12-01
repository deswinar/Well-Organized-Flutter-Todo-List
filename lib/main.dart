import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/domain/auth_bloc.dart';
import 'features/auth/domain/auth_event.dart';
import 'features/todo/domain/todo_bloc.dart';
import 'injection/service_locator.dart';
import 'router/app_router.dart';
import 'firebase_options.dart';

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup dependency injection
  setupDependencies();
}

void main() async {
  await _initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide AuthBloc using GetIt
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()..add(AuthStarted()),
        ),
        // Provide TodoBloc using GetIt
        BlocProvider<TodoBloc>(
          create: (_) => getIt<TodoBloc>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter().config(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
