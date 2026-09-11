import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache failure occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed']);
}

class AuthFailure extends Failure {
  final String? code;

  const AuthFailure(super.message, {super.statusCode, this.code});

  @override
  List<Object?> get props => [message, statusCode, code];
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
