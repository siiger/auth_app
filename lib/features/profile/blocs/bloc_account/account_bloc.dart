import 'dart:async';

import 'package:auth_app/data/user_repository/model/user.dart';
import 'package:auth_app/data/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_event.dart';

class AccountBloc extends Bloc<AccountEvent, User> {
  AccountBloc({
    required UserRepository userRepository,
  }): _userRepository = userRepository,
        super(userRepository.currentUser);

  final UserRepository _userRepository;

  @override
  Stream<User> mapEventToState(
    AccountEvent event,
  ) async* {
    if (event is UpdateAccount) {
      yield* _mapUpdateAccountToState(state, event);
    } else if (event is Email) {
      yield* _mapEmailToState(state, event);
    } else if (event is DayOfBirth) {
      yield* _mapDayOfBirthToState(state, event);
    } else if (event is Name) {
      yield* _mapNameToState(state, event);
    } else if (event is Save) {
      yield* _mapSaveToState(state, event);
    } else if (event is UpdateData) {
      yield* _mapUpdateDataToState(state, event);
    }
  }

  Stream<User> _mapUpdateAccountToState(User user, UpdateAccount event) async* {
    yield user = event.user;
  }

  Stream<User> _mapEmailToState(User user, Email event) async* {
    yield user.copyWith(email: event.email);
  }

  Stream<User> _mapDayOfBirthToState(User user, DayOfBirth event) async* {
    yield user.copyWith(dayOfBirth: event.dayOfBirth);
  }

  Stream<User> _mapNameToState(User user, Name event) async* {
    yield user.copyWith(name: event.name);
  }


  Stream<User> _mapSaveToState(User user, Save event) async* {
    final res = await _trySetUser(user);
  }

  Stream<User> _mapUpdateDataToState(User user, UpdateData event) async* {
    final res = await _tryUpdateDataUser(user, event.data);
  }

  Future<bool> _trySetUser(User user) async {
    try {
      final res = await _userRepository.setUser(user);
      return res;
    } on Exception {
      return false;
    }
  }

  Future<bool> _tryUpdateDataUser(User user, String data) async {
    try {
      final res = await _userRepository.updateDataFieldCurrentUser(data: data);
      return res;
    } on Exception {
      return false;
    }
  }
}
