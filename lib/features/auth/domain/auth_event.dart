import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final User user;

  AuthLoggedIn({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthLoggedOut extends AuthEvent {}

class AuthErrorOccurred extends AuthEvent {
  final String message;

  AuthErrorOccurred({required this.message});

  @override
  List<Object?> get props => [message];
}
