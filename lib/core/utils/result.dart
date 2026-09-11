import '../errors/failures.dart';

class Result<T> {
  final T? data;
  final Failure? failure;

  const Result.success(this.data) : failure = null;
  const Result.failure(this.failure) : data = null;

  bool get isSuccess => failure == null;
  bool get isFailure => failure != null;
}

class AuthResult {
  final dynamic user;
  final Failure? failure;

  const AuthResult.success(this.user) : failure = null;
  const AuthResult.failure(this.failure) : user = null;

  bool get isSuccess => failure == null;
  bool get isFailure => failure != null;
}
