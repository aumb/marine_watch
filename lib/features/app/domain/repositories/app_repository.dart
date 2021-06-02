import 'package:dartz/dartz.dart';
import 'package:marine_watch/core/errors/failure.dart';

abstract class AppRepository {
  Future<Either<Failure, bool>> getCachedIsFreshInstall();

  Future<Either<Failure, bool>> cacheIsFreshInstall();
}
