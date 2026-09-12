import '../../domain/entities/user.dart';

/// Abstract contract for authentication repository in the domain layer.
abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<UserEntity> loginWithEmailPassword(String email, String password);
  Future<UserEntity> registerWithEmailPassword(String email, String password);
  Future<void> logout();
  Future<void> sendPasswordResetEmail(String email);
  UserEntity? getCurrentUser();
}
