part of 'sighting_bloc.dart';

abstract class SightingState extends Equatable {
  const SightingState();

  @override
  List<Object> get props => [];
}

class SightingInitial extends SightingState {}

class SightingFavorite extends SightingState {}

class SightingUnfavorite extends SightingState {}
