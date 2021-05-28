import 'package:dartz/dartz.dart';
import 'package:marine_watch/features/sightings/data/datasources/sightings_remote_data_source.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/features/sightings/domain/repositories/sightings_repository.dart';
import 'package:marine_watch/utils/custom_lat_lng.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:marine_watch/utils/errors/failure.dart';

class SightingsRepositoryImpl implements SightingsRepository {
  SightingsRepositoryImpl({
    required this.remoteDataSource,
  });

  final SightingsRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<Sighting?>?>> getMoreSightings({
    Species? species,
    int? limit,
    int? page,
    DateTime? since,
    DateTime? until,
    CustomLatLng? near,
    int? radius,
  }) async {
    try {
      final result = await remoteDataSource.getMoreSightings(
        species: species,
        limit: limit,
        page: page,
        since: since,
        until: until,
        near: near,
        radius: radius,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure, List<Sighting?>?>> getSightings({
    Species? species,
    int? limit,
    int? page,
    DateTime? since,
    DateTime? until,
    CustomLatLng? near,
    int? radius,
  }) async {
    try {
      final result = await remoteDataSource.getSightings(
        species: species,
        limit: limit,
        page: page,
        since: since,
        until: until,
        near: near,
        radius: radius,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(exception: e));
    }
  }
}
