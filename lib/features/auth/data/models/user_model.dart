import '../../domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

/// Data layer representation of User with FirebaseUser mapping.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
  });

  /// Factory constructor to map from Firebase User object
  factory UserModel.fromFirebaseUser(fb.User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  /// Factory constructor for map representation
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
    };
  }
}
