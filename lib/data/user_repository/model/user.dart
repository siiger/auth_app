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
  final DateTime? dayOfBirth;
  final DateTime? lastLoggedIn;
  final DateTime? registrationDate;
  final bool? introSeen;

  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
    this.introSeen,
    this.dayOfBirth,
    this.lastLoggedIn,
    this.registrationDate,
  });

  factory User.fromMap(Map<String, dynamic>? map) {
    return User(
      id: map!['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photo: map['avatar'] as String,
      introSeen: map['introSeen'] as bool,
      dayOfBirth: map['dayOfBirth'] as DateTime,
      lastLoggedIn: map[UserFields.lastLoggedIn]?.toDate() as DateTime,
      registrationDate: map[UserFields.registrationDate]?.toDate() as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'uid': id,
      'name': name,
      'email': email,
      'avatar': photo,
      'introSeen': introSeen,
      'dayOfBirth': dayOfBirth,
      UserFields.lastLoggedIn: lastLoggedIn,
      UserFields.registrationDate: registrationDate,
    } as Map<String, dynamic>;
  }

  /// The current user's email address.

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  @override
  List<Object?> get props => [email, id, name, photo, dayOfBirth, introSeen];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photo,
    DateTime? dayOfBirth,
    DateTime? lastLoggedIn,
    DateTime? registrationDate,
    bool? introSeen,
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
    );
  }
}
