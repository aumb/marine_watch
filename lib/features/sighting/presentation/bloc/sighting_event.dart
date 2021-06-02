part of 'sighting_bloc.dart';

abstract class SightingEvent extends Equatable {
  const SightingEvent();

  @override
  List<Object> get props => [];
}

class ToggleFavoriteSightingEvent extends SightingEvent {}

class ToggleFavoriteSightingErrorEvent extends SightingEvent {}

class TrackButtonPressedEvent extends SightingEvent {}
