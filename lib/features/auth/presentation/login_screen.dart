import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/presentation/widgets/auth_button.dart';
import 'package:myapp/injection/service_locator.dart';
import 'package:myapp/router/app_router.dart';
import '../data/auth_repository.dart';
import '../domain/auth_bloc.dart';
import '../domain/auth_event.dart';
import '../domain/auth_state.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(AuthStarted()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                context.replaceRoute(const TodoListRoute());
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                AuthButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please fill in all fields")),
                      );
                      return;
                    }

                    try {
                      final user =
                          await getIt<AuthRepository>().signIn(email, password);
                      if (user != null) {
                        context.read<AuthBloc>().add(AuthLoggedIn(user: user));
                        context.replaceRoute(TodoListRoute());
                      }
                    } catch (e) {
                      context
                          .read<AuthBloc>()
                          .add(AuthErrorOccurred(message: e.toString()));
                    }
                  },
                  text: 'Login',
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    context.pushRoute(RegisterRoute());
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 10),
                AuthButton(
                  onPressed: () async {
                    try {
                      final user =
                          await getIt<AuthRepository>().signInWithGoogle();
                      if (user != null) {
                        context.read<AuthBloc>().add(AuthLoggedIn(user: user));
                      }
                    } catch (e) {
                      context
                          .read<AuthBloc>()
                          .add(AuthErrorOccurred(message: e.toString()));
                    }
                  },
                  text: 'Sign in with Google',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  isGoogleSignIn: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
