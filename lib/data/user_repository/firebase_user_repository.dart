import 'dart:async';
import 'package:auth_app/data/user_repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/user.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({
    FirebaseFirestore? firestoreInstance,
  }) : _firestoreInstance = firestoreInstance ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestoreInstance;

  late User _user;

  @override
  User get currentUser => _user;

  @override
  Future<User> getUser(String uid) async {
    if (_user != null) return _user;
    final userDoc = await _firestoreInstance.collection('users').doc(uid).get();
    _user = User.fromMap(userDoc.data());
    return _user;
  }

  @override
  Future<bool> setUser(User user) async {
    final userDocRef = _firestoreInstance.collection('users').doc(user.id);
    await userDocRef.set(user.toMap(), SetOptions(merge: true));
    _user = user;
    return true;
  }

  @override
  Future<bool> updateIntroSeenCurrentUser({bool? introSeen}) async {
    if (_user != null) {
      final userDocRef = _firestoreInstance.collection('users').doc(_user.id);
      await userDocRef.set({'introSeen': introSeen}, SetOptions(merge: true));
      User user = User(
          id: _user.id,
          email: _user.email,
          name: _user.name,
          photo: _user.photo,
          dayOfBirth: _user.dayOfBirth,
          introSeen: introSeen!);
      _user = user;
      return true;
    } else {
      return false;
    }
  }
}
