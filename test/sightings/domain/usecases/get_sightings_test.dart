import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/features/sightings/domain/repositories/sightings_repository.dart';
import 'package:marine_watch/features/sightings/domain/usecases/get_sightings.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSightingsRepository extends Mock implements SightingsRepository {}

void main() {
  late GetSightings usecase;
  late MockSightingsRepository mockSightingsRepository;
  late List<Sighting?> sightings;

  setUp(() {
    mockSightingsRepository = MockSightingsRepository();
    usecase = GetSightings(repository: mockSightingsRepository);
    sightings = sightingsFromJson(fixture('sightings.json'));
  });

  test(
    'should get a list of sightings result from the repository',
    () async {
      // arrange
      when(
        () => mockSightingsRepository.getSightings(
          species: any(named: 'species'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
          since: any(named: 'since'),
          until: any(named: 'until'),
          near: any(named: 'near'),
          radius: any(named: 'radius'),
        ),
      ).thenAnswer((_) async => Right(sightings));

      // act
      final result = await usecase(GetSightingsParams());

      // assert
      expect(result, Right(sightings));
      verify(() => mockSightingsRepository.getSightings());
      verifyNoMoreInteractions(mockSightingsRepository);
    },
  );

  test(
    'should get [ServerFailure] when the request fails',
    () async {
      final serverFailure =
          ServerFailure(exception: ServerException.defaultError);
      // arrange
      when(
        () => mockSightingsRepository.getSightings(
          species: any(named: 'species'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
          since: any(named: 'since'),
          until: any(named: 'until'),
          near: any(named: 'near'),
          radius: any(named: 'radius'),
        ),
      ).thenAnswer((_) async => Left(serverFailure));

      // act
      final result = await usecase(GetSightingsParams());

      // assert
      expect(result, Left(serverFailure));
      verify(() => mockSightingsRepository.getSightings());
      verifyNoMoreInteractions(mockSightingsRepository);
    },
  );

  group('GetSightingsParams', () {
    final tSighting = Sighting.defaultSighting;
    test(('Should reutrn updated params with copyWith'), () {
      final params = GetSightingsParams(
        species: Species.atlanticWhiteSidedDolphin,
        limit: 3,
      );

      final result = params.copyWith(species: params.species, limit: 4);

      expect(
          result,
          equals(GetSightingsParams(
            species: Species.atlanticWhiteSidedDolphin,
            limit: 4,
          )));
    });
  });
}
