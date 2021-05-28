import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:marine_watch/features/sighting/presentation/cubit/toggle_sighting_cubit.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';

void main() {
  group('Toggle Sighting Cubit', () {
    test('initial state is [OnboardingInitial]', () {
      expect(ToggleSightingCubit().state, equals(ToggleSightingInitial()));
    });

    blocTest<ToggleSightingCubit, ToggleSightingState>(
      'emits nothing when toggleSightingToNull is called',
      build: () => ToggleSightingCubit(),
      verify: (cubit) {
        expect(cubit.sighting, equals(null));
      },
      act: (cubit) => cubit.toggleSightingToNull(),
      expect: () => [],
    );

    blocTest<ToggleSightingCubit, ToggleSightingState>(
      'emits [ToggledSigthingToNull, ToggledSigthingToValue] when '
      'toggleSightingToNullThenValue is called',
      build: () => ToggleSightingCubit(),
      verify: (cubit) {
        expect(cubit.sighting, equals(Sighting.defaultSighting));
      },
      act: (cubit) =>
          cubit.toggleSightingToNullThenValue(Sighting.defaultSighting),
      expect: () => [ToggledSigthingToNull(), ToggledSigthingToValue()],
    );
  });
}
