import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetAuthState {
  final AuthRepository repository;

  GetAuthState(this.repository);

  Stream<UserEntity?> call() {
    return repository.authStateChanges;
  }

  UserEntity? getCurrentUser() {
    return repository.getCurrentUser();
  }
}
