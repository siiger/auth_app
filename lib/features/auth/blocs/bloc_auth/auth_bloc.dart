import 'dart:async';

import 'package:auth_app/data/auth_repository/auth_repository.dart';
import 'package:auth_app/data/auth_repository/model/user_auth.dart';
import 'package:auth_app/data/user_repository/model/user.dart';
import 'package:auth_app/data/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pedantic/pedantic.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.uninitialized()) {
    _authSubscription = _authenticationRepository.auth.listen(
      (auth) => add(AuthenticationUserChanged(auth)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<UserAu> _authSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield await _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) async {
    if (event.auth.isEmpty) {
      return const AuthenticationState.unauthenticated();
    }
    // Detect new authentication to create new collection for user
    if (event.auth.lastSignedIn!.difference(event.auth.createdAt!).inMinutes <= 1) {
      final user = User(id: event.auth.id, email: event.auth.email, name: event.auth.name);
      final res = await _trySetUser(user);
      return res ? AuthenticationState.authenticated(user) : const AuthenticationState.unauthenticated();
    }

    final user = await _tryGetUser(event.auth.id);
    return user != null ? AuthenticationState.authenticated(user) : const AuthenticationState.unauthenticated();
  }

  Future<User> _tryGetUser(String uid) async {
    try {
      final user = await _userRepository.getUser(uid);
      return user;
    } on Exception {
      print("Exception ");
      return const User(id: '0');
    }
  }

  Future<bool> _trySetUser(User user) async {
    try {
      final res = await _userRepository.setUser(user);
      return res;
    } on Exception {
      return false;
    }
  }
}
