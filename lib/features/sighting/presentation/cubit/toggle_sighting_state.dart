part of 'toggle_sighting_cubit.dart';

abstract class ToggleSightingState extends Equatable {
  const ToggleSightingState();

  @override
  List<Object> get props => [];
}

class ToggleSightingInitial extends ToggleSightingState {}

class ToggledSigthingToNull extends ToggleSightingState {}

class ToggledSigthingToValue extends ToggleSightingState {}
