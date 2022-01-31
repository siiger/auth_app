part of 'auth_bloc.dart';

enum AuthenticationBlocStatus { uninitialized, authenticated, unauthenticated}

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationBlocStatus.uninitialized,
    this.user = User.empty,
  });

  //const AuthenticationState.unknown() : this._();

  const AuthenticationState.uninitialized()
      : this._(status: AuthenticationBlocStatus.uninitialized);

  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationBlocStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationBlocStatus.unauthenticated);

  final AuthenticationBlocStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
