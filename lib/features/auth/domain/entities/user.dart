import 'package:equatable/equatable.dart';

/// Pure domain entity representing an authenticated user.
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
  });

  @override
  List<Object?> get props => [id, email, displayName];
}
