import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/usecases/get_sightings.dart';
import 'package:marine_watch/features/sightings/presentation/bloc/sightings_bloc.dart';
import 'package:marine_watch/core/errors/exceptions.dart';
import 'package:marine_watch/core/errors/failure.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetSightings extends Mock implements GetSightings {}

void main() {
  late MockGetSightings mockGetSightings;

  setUp(() {
    registerFallbackValue<GetSightingsParams>(GetSightingsParams());
    mockGetSightings = MockGetSightings();
  });

  group('Sightings bloc', () {
    final serverFailure =
        ServerFailure(exception: ServerException.defaultError);
    final sightings = sightingsFromJson(fixture('sightings.json'));
    test('initial state is [SightingsInitial]', () {
      expect(
          SightingsBloc(
            getSightings: mockGetSightings,
          ).state,
          equals(SightingsInitial()));
    });

    blocTest<SightingsBloc, SightingsState>(
      'emits [SightingsLoading, SightingsLoaded] when request is successful',
      build: () {
        when(() => mockGetSightings(any()))
            .thenAnswer((_) async => Right(sightings));
        return SightingsBloc(
          getSightings: mockGetSightings,
        );
      },
      verify: (_) {
        verify(() => mockGetSightings(any())).called(1);
      },
      act: (bloc) => bloc.add(GetSightingsEvent()),
      expect: () => [SightingsLoading(), SightingsLoaded()],
    );

    blocTest<SightingsBloc, SightingsState>(
      'emits [SightingsLoading, SightingsError] when request fails',
      build: () {
        when(() => mockGetSightings(any()))
            .thenAnswer((_) async => Left(serverFailure));
        return SightingsBloc(
          getSightings: mockGetSightings,
        );
      },
      verify: (_) {
        verify(() => mockGetSightings(any())).called(1);
      },
      act: (bloc) => bloc.add(GetSightingsEvent()),
      expect: () => [
        SightingsLoading(),
        SightingsError(
          message: serverFailure.message,
          code: serverFailure.code,
        )
      ],
    );
  });
}
