import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthStarted>((event, emit) async {
      final user = authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoggedIn>((event, emit) async {
      emit(AuthAuthenticated(user: event.user));
    });

    on<AuthLoggedOut>((event, emit) async {
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    });

    // Handle any errors during authentication
    on<AuthErrorOccurred>((event, emit) {
      emit(AuthError(message: event.message));
    });
  }
}
