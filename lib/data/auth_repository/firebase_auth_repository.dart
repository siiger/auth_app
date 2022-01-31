import 'dart:async';

import 'package:auth_app/data/auth_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';


import 'model/user_auth.dart';

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}


class FirebaseAuthenticationRepository implements AuthenticationRepository {
  
  FirebaseAuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthenticationStatus _status = AuthenticationStatus.unknown;

  


  @override
  Stream<Auth> get auth {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null
          ? const Auth(user: UserAu.empty, status: AuthenticationStatus.unknown)
          : Auth(user: firebaseUser.toUser, status: _status);
    });
  }

  


  @override
  Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }

  

  
  @override
  Future<void> logOut() async {
    _status = AuthenticationStatus.logout;
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }

  @override
  Future<void> signInAnonymously() async {
    _status = AuthenticationStatus.signinanon;
    await _firebaseAuth.signInAnonymously();
  }
}

extension on firebase_auth.User {
  UserAu get toUser {
    return UserAu(id: uid, 
    email: email,
    name: displayName, 
    photo: photoURL,
    createdAt: metadata.creationTime,
    lastSignedIn: metadata.lastSignInTime);
  }
}
