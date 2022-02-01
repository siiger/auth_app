import 'package:equatable/equatable.dart';

class UserAu extends Equatable {
  const UserAu({
    required this.id,
    this.email,
    this.name,
    this.photo,
    this.createdAt,
    this.lastSignedIn,
    this.isAnonymous,
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

  /// is Anonymous
  final bool? isAnonymous;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserAu(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserAu.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserAu.empty;

  @override
  List<Object?> get props => [email, id, name, photo, createdAt, lastSignedIn];
}
