import 'package:equatable/equatable.dart';

/// Base Failure class for Clean Architecture.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again later.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed. Please check your credentials.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Please check your internet connection and try again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load local data.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
