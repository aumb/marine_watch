import 'package:dartz/dartz.dart';
import 'package:marine_watch/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:marine_watch/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({
    required this.localDataSource,
  });

  final FavoritesLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<Sighting?>>> cacheSighting(
      Sighting? sighting) async {
    try {
      final result = await localDataSource.cacheSighting(sighting);
      favoriteSightings!
        ..clear()
        ..addAll(result ?? []);
      return Right(result ?? []);
    } on CacheException catch (e) {
      return Left(CacheFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure, List<Sighting?>>> deleteCachedSighting(
      Sighting? sighting) async {
    try {
      final result = await localDataSource.deleteCachedSighting(sighting);
      favoriteSightings!
        ..clear()
        ..addAll(result ?? []);
      return Right(result ?? []);
    } on CacheException catch (e) {
      return Left(CacheFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure, List<Sighting?>>> getCachedSightings() async {
    try {
      final result = localDataSource.getCachedSightings();
      favoriteSightings!
        ..clear()
        ..addAll(result);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(exception: e));
    }
  }

  @override
  List<Sighting?>? favoriteSightings = [];
}
