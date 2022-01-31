part of 'auth_bloc.dart';



abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  const AuthenticationUserChanged(this.auth);

  final UserAu auth;

  @override
  List<Object> get props => [auth];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
