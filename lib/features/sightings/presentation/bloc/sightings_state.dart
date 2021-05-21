part of 'sightings_bloc.dart';

abstract class SightingsState extends Equatable {
  const SightingsState();

  @override
  List<Object?> get props => [];
}

class SightingsInitial extends SightingsState {}

class SightingsLoading extends SightingsState {}

class SightingsLoaded extends SightingsState {}

class SightingsError extends SightingsState {
  SightingsError({
    required this.message,
    this.code,
  });

  final String message;
  final int? code;

  @override
  List<Object?> get props => [message, code];
}
