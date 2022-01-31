import 'dart:async';

import 'model/user_auth.dart';

abstract class AuthenticationRepository {

  Future<void> logInWithGoogle();

  Future<void> logOut();

  Future<void> signInAnonymously();

  Stream<UserAu> get auth;
}