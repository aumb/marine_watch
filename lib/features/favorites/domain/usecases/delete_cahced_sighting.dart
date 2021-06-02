import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marine_watch/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/core/errors/failure.dart';
import 'package:marine_watch/core/usecases.dart';

class DeleteCachedSighting
    implements UseCase<List<Sighting?>?, DeleteCachedSightingParams> {
  DeleteCachedSighting({
    required this.repository,
  });

  final FavoritesRepository repository;

  @override
  Future<Either<Failure, List<Sighting?>?>> call(
      DeleteCachedSightingParams params) async {
    return await repository.deleteCachedSighting(params.sighting);
  }
}

class DeleteCachedSightingParams extends Equatable {
  DeleteCachedSightingParams({
    required this.sighting,
  });

  final Sighting sighting;

  @override
  List<Object?> get props => [id];
}
