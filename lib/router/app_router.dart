import 'package:flutter/material.dart'; // Add this import if not present
import 'package:auto_route/auto_route.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/todo/presentation/todo_list_screen.dart';

// The part directive must be after imports
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        // add your routes here
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: TodoListRoute.page),
        AutoRoute(page: RegisterRoute.page),
      ];
}
