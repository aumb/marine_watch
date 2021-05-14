import 'package:dartz/dartz.dart';
import 'package:marine_watch/app/data/datasources/app_local_data_source.dart';
import 'package:marine_watch/app/domain/repositories/app_repository.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:marine_watch/utils/errors/failure.dart';

class AppRepositoryImpl implements AppRepository {
  AppRepositoryImpl({
    required this.localDataSource,
  });

  final AppLocalDataSource localDataSource;

  @override
  Future<Either<Failure, bool>> cacheIsFreshInstall() async {
    try {
      final result = await localDataSource.cacheIsFreshInstall();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure, bool>> getCachedIsFreshInstall() async {
    try {
      final result = localDataSource.getCachedIsFreshInstall();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(exception: e));
    }
  }
}
