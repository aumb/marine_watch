import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/features/sightings/domain/usecases/get_sightings.dart';
import 'package:marine_watch/utils/custom_lat_lng.dart';
import 'package:marine_watch/utils/errors/failure.dart';

part 'sightings_event.dart';
part 'sightings_state.dart';

class SightingsBloc extends Bloc<SightingsEvent, SightingsState> {
  SightingsBloc({
    required this.getSightings,
  }) : super(SightingsInitial());

  final GetSightings getSightings;

  List<Sighting?>? sightings;
  Species? species;

  Sighting? selectedSighting;

  bool isGettingSightings = false;
  bool hasMovedCamera = false;

  Set<Marker>? markers;

  bool get shouldGetMarkers => !isGettingSightings && hasMovedCamera;

  @override
  Stream<SightingsState> mapEventToState(
    SightingsEvent event,
  ) async* {
    if (event is GetSightingsEvent) {
      isGettingSightings = true;
      yield SightingsLoading();
      final result = await getSightings(
        GetSightingsParams(
          limit: 15,
          near: event.latLng,
          species: species,
        ),
      );
      yield _mapGetSightingsEvent(result);
      isGettingSightings = false;
    }
  }

  SightingsState _mapGetSightingsEvent(
      Either<Failure, List<Sighting?>?> result) {
    return result.fold((l) {
      l as ServerFailure;
      return SightingsError(message: l.message, code: l.code);
    }, (r) {
      sightings = r;
      return SightingsLoaded();
    });
  }
}
