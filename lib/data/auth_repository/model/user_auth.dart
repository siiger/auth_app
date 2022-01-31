import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [UserAu.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserAu extends Equatable {
  /// {@macro user}
  const UserAu({
    required this.id,
    this.email,
    this.name,
    this.photo,
    this.createdAt,
    this.lastSignedIn,
  });

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  /// Time of the registration
  final DateTime? createdAt;

  /// Time of the last sign In
  final DateTime? lastSignedIn;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserAu(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserAu.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserAu.empty;

  @override
  List<Object?> get props => [email, id, name, photo, createdAt, lastSignedIn];
}

enum AuthenticationStatus { unknown, login, logout, signup, signinanon }

class Auth extends Equatable {
  /// {@macro user}
  const Auth({
    required this.user,
    required this.status,
  });

  final UserAu user;

  final AuthenticationStatus status;

  @override
  List<Object> get props => [user, status];
}
