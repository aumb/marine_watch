import 'package:dartz/dartz.dart';
import 'package:marine_watch/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:marine_watch/utils/usecases.dart';

class GetCachedSightings implements UseCase<List<Sighting?>?, NoParams> {
  GetCachedSightings({
    required this.repository,
  });

  final FavoritesRepository repository;

  @override
  Future<Either<Failure, List<Sighting?>?>> call(NoParams params) async {
    return await repository.getCachedSightings();
  }
}
