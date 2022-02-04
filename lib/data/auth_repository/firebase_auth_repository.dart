import 'dart:async';

import 'package:auth_app/data/auth_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'model/user_auth.dart';

/// Thrown during the sign in with google process if a failure occurs
class LogInWithGoogleFailure implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithGoogleFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the sign in with apple process if a failure occurs.
class LogInWithAppleFailure implements Exception {}

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

  @override
  Stream<UserAu> get auth {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      final user = firebaseUser == null ? UserAu.empty : firebaseUser.toUser;
      return user;
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

      final currentUser = _firebaseAuth.currentUser;
      //if there is already an anonymous user signed in
      if (currentUser != null && currentUser.isAnonymous) {
        try {
          await currentUser.linkWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          if (e.code == "credential-already-in-use") {
            await _firebaseAuth.signInWithCredential(credential);
          }
        }
      } else {
        await _firebaseAuth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  @override
  Future<void> logInWithApple() async {
    var redirectURL = "https://AuthApp.glitch.me/callbacks/sign_in_with_apple";
    var clientID = "com.example.authApp";
    try {
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        /*
        webAuthenticationOptions: WebAuthenticationOptions(
          redirectUri: Uri.parse(redirectURL),
          clientId: clientID,
        ),
        */
      );
      final oAuthProvider = firebase_auth.OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      final currentUser = _firebaseAuth.currentUser;
      //if there is already an anonymous user signed in
      if (currentUser != null && currentUser.isAnonymous) {
        await currentUser.linkWithCredential(credential);
      } else {
        await _firebaseAuth.signInWithCredential(credential);
      }
    } on Exception {
      throw LogInWithAppleFailure();
    }
  }

  @override
  Future<void> logOut() async {
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
      await _firebaseAuth.signInAnonymously();
  }
}

extension on firebase_auth.User {
  UserAu get toUser {
    return UserAu(
        id: uid,
        email: email,
        name: providerData.isNotEmpty ? providerData[0].displayName : displayName,
        photo: providerData.isNotEmpty ? providerData[0].photoURL : photoURL,
        createdAt: metadata.creationTime,
        lastSignedIn: metadata.lastSignInTime,
        isAnonymous: isAnonymous);
  }
}
