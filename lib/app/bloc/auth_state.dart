part of 'auth_bloc.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.userAuth = UserAuth.empty,
  });

  const AuthState.authenticated(UserAuth user)
      : this._(status: AuthStatus.authenticated, userAuth: user);

  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final UserAuth userAuth;

  @override
  List<Object> get props => [status, userAuth];
}