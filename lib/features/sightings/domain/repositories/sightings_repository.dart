import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/utils/errors/failure.dart';

abstract class SightingsRepository {
  Future<Either<Failure, List<Sighting?>?>> getSightings({
    Species? species,
    int? limit,
    int? page,
    DateTime? since,
    DateTime? until,
    LatLng? near,
    int? radius,
  });

  Future<Either<Failure, List<Sighting?>?>> getMoreSightings({
    Species? species,
    int? limit,
    int? page,
    DateTime? since,
    DateTime? until,
    LatLng? near,
    int? radius,
  });
}
