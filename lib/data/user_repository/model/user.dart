import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
///
class UserFields {
  static const String uid = 'id';
  static const String name = 'name';
  static const String email = 'email';
  static const String avatar = 'photo';
  static const String introSeen = 'introSeen';
  static const String dayOfBirth = 'dayOfBirth';
  static const String lastLoggedIn = 'last_logged_in';
  static const String registrationDate = 'registration_date';
}

///
class User extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? photo;
  final String? data;
  final DateTime? dayOfBirth;
  final DateTime? lastLoggedIn;
  final DateTime? registrationDate;
  final bool? introSeen;
  final bool? isAnonymous;

  const User(
      {required this.id,
      this.email,
      this.name,
      this.photo,
      this.introSeen,
      this.isAnonymous,
      this.dayOfBirth,
      this.lastLoggedIn,
      this.registrationDate,
      this.data});

  factory User.fromMap(Map<String, dynamic>? map) {
    return User(
      id: map!['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photo: map['avatar'] != null ? map['avatar'] as String : null,
      data: map['data'] != null ? map['data'] as String : null,
      introSeen: map['introSeen'] != null ? map['introSeen'] as bool : null,
      dayOfBirth: map['dayOfBirth'] != null ? map['dayOfBirth'] as DateTime : null,
      lastLoggedIn: map[UserFields.lastLoggedIn] != null ? map[UserFields.lastLoggedIn]?.toDate() as DateTime : null,
      registrationDate:
          map[UserFields.registrationDate] != null ? map[UserFields.registrationDate]?.toDate() as DateTime : null,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'uid': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (photo != null) 'avatar': photo,
      if (introSeen != null) 'introSeen': introSeen,
      if (data != null) 'data': data,
      if (dayOfBirth != null) 'dayOfBirth': dayOfBirth,
      if (lastLoggedIn != null) UserFields.lastLoggedIn: lastLoggedIn,
      if (registrationDate != null) UserFields.registrationDate: registrationDate,
    } as Map<String, dynamic>;
  }

  /// The current user's email address.

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  @override
  List<Object?> get props => [email, id, name, photo, dayOfBirth, introSeen, isAnonymous, data];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photo,
    DateTime? dayOfBirth,
    DateTime? lastLoggedIn,
    DateTime? registrationDate,
    bool? introSeen,
    bool? isAnonymous,
    String? data,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      dayOfBirth: dayOfBirth ?? this.dayOfBirth,
      lastLoggedIn: lastLoggedIn ?? this.lastLoggedIn,
      registrationDate: registrationDate ?? this.registrationDate,
      introSeen: introSeen ?? this.introSeen,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      data: data ?? this.data,
    );
  }
}
