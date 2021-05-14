import 'package:equatable/equatable.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  ServerFailure({required this.exception});

  final ServerException exception;

  String get message => exception.message ?? '';

  int get code => exception.code ?? 500;

  @override
  List<Object?> get props => [exception];
}

class CacheFailure extends Failure {
  CacheFailure({required this.exception});

  final CacheException exception;

  String get message => exception.message ?? '';

  @override
  List<Object?> get props => [exception];
}
