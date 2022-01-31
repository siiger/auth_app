import 'dart:async';

import 'model/user.dart';

abstract class UserRepository {
  Future<User> getUser(String uid);

  Future<bool> setUser(User user);

  User get currentUser;

  Future<bool> updateIntroSeenCurrentUser({bool? introSeen});
}
