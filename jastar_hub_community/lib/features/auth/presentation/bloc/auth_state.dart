part of 'auth_bloc.dart';

/// States for the AuthBloc.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state — not yet checked.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading — operation in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated — user is logged in.
class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Not authenticated — user needs to login.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state with message.
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Password reset email sent successfully.
class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}
