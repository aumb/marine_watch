import 'package:dartz/dartz.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/utils/errors/failure.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Sighting?>>> getCachedSightings();
  Future<Either<Failure, List<Sighting?>>> cacheSighting(Sighting? sighting);
  Future<Either<Failure, List<Sighting?>>> deleteCachedSighting(Sighting? id);
  List<Sighting?>? favoriteSightings;
}
