part of 'sightings_bloc.dart';

abstract class SightingsEvent extends Equatable {
  const SightingsEvent();

  @override
  List<Object?> get props => [];
}

class GetSightingsEvent extends SightingsEvent {
  GetSightingsEvent({
    this.latLng,
    this.species,
  });

  final CustomLatLng? latLng;
  final Species? species;

  @override
  List<Object?> get props => [latLng, species];
}
