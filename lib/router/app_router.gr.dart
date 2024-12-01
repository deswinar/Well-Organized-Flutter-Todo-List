// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginScreen(key: args.key),
      );
    },
    RegisterRoute.name: (routeData) {
      final args = routeData.argsAs<RegisterRouteArgs>(
          orElse: () => const RegisterRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RegisterScreen(key: args.key),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    TodoListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TodoListScreen(),
      );
    },
  };
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<LoginRouteArgs> page = PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key}';
  }
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          RegisterRoute.name,
          args: RegisterRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<RegisterRouteArgs> page =
      PageInfo<RegisterRouteArgs>(name);
}

class RegisterRouteArgs {
  const RegisterRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key}';
  }
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TodoListScreen]
class TodoListRoute extends PageRouteInfo<void> {
  const TodoListRoute({List<PageRouteInfo>? children})
      : super(
          TodoListRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
