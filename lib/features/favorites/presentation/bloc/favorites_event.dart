part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class GetCachedSightingsEvent extends FavoritesEvent {}

class CacheSightingEvent extends FavoritesEvent {
  CacheSightingEvent({required this.sighting});

  final Sighting sighting;

  @override
  List<Object?> get props => [sighting];
}

class DeleteCachedSightingEvent extends FavoritesEvent {
  DeleteCachedSightingEvent({required this.sighting});

  final Sighting sighting;

  @override
  List<Object?> get props => [sighting];
}
