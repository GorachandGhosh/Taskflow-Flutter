/// Custom exceptions thrown by Data Sources.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server exception']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Auth exception']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache exception']);
}
