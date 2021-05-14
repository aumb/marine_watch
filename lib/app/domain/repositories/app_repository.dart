import 'package:dartz/dartz.dart';
import 'package:marine_watch/utils/errors/failure.dart';

abstract class AppRepository {
  Future<Either<Failure, bool>> getCachedIsFreshInstall();

  Future<Either<Failure, bool>> cacheIsFreshInstall();
}
