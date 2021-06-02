import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marine_watch/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/core/errors/failure.dart';
import 'package:marine_watch/core/usecases.dart';

class CacheSighting implements UseCase<List<Sighting?>?, CacheSightingParams> {
  CacheSighting({
    required this.repository,
  });

  final FavoritesRepository repository;

  @override
  Future<Either<Failure, List<Sighting?>?>> call(
      CacheSightingParams params) async {
    return await repository.cacheSighting(params.sighting);
  }
}

class CacheSightingParams extends Equatable {
  CacheSightingParams({
    required this.sighting,
  });

  final Sighting sighting;

  @override
  List<Object?> get props => [id];
}
