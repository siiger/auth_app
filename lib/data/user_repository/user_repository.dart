import 'dart:async';

import 'model/user.dart';

abstract class UserRepository {
  Future<User> getUser(String uid);

  Future<bool> setUser(User user);

  User get currentUser;

  void resetCurrentUser();

  Future<bool> updateIntroSeenCurrentUser({bool? introSeen});

  Future<bool> updateDataFieldCurrentUser({String? data});
}
