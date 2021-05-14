import 'package:marine_watch/utils/safe_print.dart';

class ServerException implements Exception {
  ServerException({
    required this.message,
    required this.code,
  });

  final String? message;
  final int? code;

  static ServerException get defaultError =>
      ServerException(message: '', code: 500);

  static ServerException handleException({required dynamic? error}) {
    safePrint(error?.toString() ?? '');
    return ServerException.defaultError;
  }
}

class CacheException implements Exception {
  CacheException({
    this.message,
  });

  final String? message;

  static CacheException get defaultError => CacheException(message: '');

  static CacheException handleException({required dynamic? error}) {
    safePrint(error?.toString() ?? '');
    return CacheException.defaultError;
  }
}
