import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';

part 'toggle_sighting_state.dart';

class ToggleSightingCubit extends Cubit<ToggleSightingState> {
  ToggleSightingCubit() : super(ToggleSightingInitial());

  Sighting? _sighting;
  Sighting? get sighting => _sighting;

  void toggleSightingToNull() {
    _sighting = null;
  }

  void toggleSightingToNullThenValue(Sighting? sighting) async {
    _sighting = null;
    emit(ToggledSigthingToNull());
    await Future.delayed(const Duration(milliseconds: 300));
    _sighting = sighting;
    emit(ToggledSigthingToValue());
  }
}
