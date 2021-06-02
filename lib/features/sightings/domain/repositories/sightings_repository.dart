import 'package:dartz/dartz.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/core/custom_lat_lng.dart';
import 'package:marine_watch/core/errors/failure.dart';

abstract class SightingsRepository {
  Future<Either<Failure, List<Sighting?>?>> getSightings({
    Species? species,
    int? limit,
    int? page,
    DateTime? since,
    DateTime? until,
    CustomLatLng? near,
    int? radius,
  });
}
