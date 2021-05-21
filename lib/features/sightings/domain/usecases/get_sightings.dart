import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/features/sightings/domain/repositories/sightings_repository.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:marine_watch/utils/usecases.dart';

class GetSightings implements UseCase<List<Sighting?>?, GetSightingsParams> {
  GetSightings({
    required this.repository,
  });

  final SightingsRepository repository;

  @override
  Future<Either<Failure, List<Sighting?>?>> call(
      GetSightingsParams params) async {
    return await repository.getSightings(
      species: params.species,
      limit: params.limit,
      page: params.page,
      since: params.since,
      until: params.until,
      near: params.near,
      radius: params.radius,
    );
  }
}

class GetSightingsParams extends Equatable {
  GetSightingsParams({
    this.species,
    this.limit,
    this.page,
    this.since,
    this.until,
    this.near,
    this.radius,
  });

  final Species? species;
  final int? limit;
  final int? page;
  final DateTime? since;
  final DateTime? until;
  final LatLng? near;
  final int? radius;

  GetSightingsParams copyWith({
    Species? species,
    int? limit,
    int? page,
    DateTime? since,
    DateTime? until,
    LatLng? near,
    int? radius,
  }) {
    return GetSightingsParams(
      species: species,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      since: since ?? this.since,
      until: until ?? this.until,
      near: near ?? this.near,
      radius: radius ?? this.radius,
    );
  }

  @override
  List<Object?> get props => [
        species,
        limit,
        page,
        since,
        until,
        near,
        radius,
      ];
}
