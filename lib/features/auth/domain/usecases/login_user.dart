import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.loginWithEmailPassword(email, password);
  }
}
