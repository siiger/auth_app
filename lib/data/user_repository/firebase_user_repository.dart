import 'dart:async';
import 'package:auth_app/data/user_repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/user.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({
    FirebaseFirestore? firestoreInstance,
  }) : _firestoreInstance = firestoreInstance ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestoreInstance;

  User _user = User.empty;

  @override
  User get currentUser => _user;

  @override
  void resetCurrentUser() {
    _user = User.empty;
  }

  @override
  Future<User> getUser(String uid) async {
    if (!_user.isEmpty) return _user;
    final userDoc = await _firestoreInstance.collection('users').doc(uid).get();
    _user = User.fromMap(userDoc.data());
    _user = _user.copyWith(isAnonymous: _user.email == null);
    return _user;
  }

  @override
  Future<bool> setUser(User user) async {
    final userDocRef = _firestoreInstance.collection('users').doc(user.id);
    await userDocRef.set(user.toMap(), SetOptions(merge: true));
    if (!_user.isEmpty) {
      _user = _user.copyWith(
        data: user.data,
        isAnonymous: user.isAnonymous,
        email: user.email,
        introSeen: user.introSeen,
        name: user.name,
        photo: user.photo,
      );
      return true;
    }
    _user = user;
    return true;
  }

  @override
  Future<bool> updateIntroSeenCurrentUser({bool? introSeen}) async {
    if (!_user.isEmpty) {
      final userDocRef = _firestoreInstance.collection('users').doc(_user.id);
      await userDocRef.set({'introSeen': introSeen}, SetOptions(merge: true));
      _user = _user.copyWith(introSeen: introSeen);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateDataFieldCurrentUser({String? data}) async {
    if (!_user.isEmpty) {
      final userDocRef = _firestoreInstance.collection('users').doc(_user.id);
      await userDocRef.set({'data': data}, SetOptions(merge: true));
      _user = _user.copyWith(data: data);
      return true;
    } else {
      return false;
    }
  }
}
