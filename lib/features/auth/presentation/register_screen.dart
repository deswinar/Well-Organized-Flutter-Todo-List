import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/injection/service_locator.dart';
import 'package:myapp/router/app_router.dart';
import '../data/auth_repository.dart';
import '../domain/auth_bloc.dart';
import '../domain/auth_event.dart';
import '../domain/auth_state.dart';
import 'widgets/auth_button.dart';

@RoutePage()
class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  RegisterScreen({super.key});

  void _register(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Call the sign-up method from the AuthRepository
        final user = await getIt<AuthRepository>().signUp(email, password);
        if (user != null) {
          // Dispatch event to indicate successful registration
          context.read<AuthBloc>().add(AuthLoggedIn(user: user));
          // Navigate to a different screen (e.g., Todo List screen)
          context.pushRoute(const TodoListRoute());
        }
      } catch (e) {
        // Handle registration errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email Text Field with consistent styling
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Text Field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Text Field
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Register Button styled similarly to the login button
                AuthButton(
                  onPressed: () => _register(context),
                  text: 'Register',
                ),
                const SizedBox(height: 10),

                // Switch to login screen text button
                TextButton(
                  onPressed: () {
                    context.router.replace(LoginRoute());
                  },
                  child: const Text(
                    'Already have an account? Login',
                    
                  ),
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
