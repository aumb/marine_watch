import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:marine_watch/features/favorites/domain/usecases/get_cached_sightings.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/core/errors/exceptions.dart';
import 'package:marine_watch/core/errors/failure.dart';
import 'package:marine_watch/core/usecases.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late GetCachedSightings usecase;
  late MockFavoritesRepository mockAppRepository;

  final tSighting = Sighting(
    id: '59d039a0686f743ec5020000',
    species: Species.harborPorpoise,
    quantity: 20,
    description: 'From the Inn at Langley looking east there was a very '
        'large group of porpoise swimming south in the Saratoga passage',
    url: 'http://hotline.whalemuseum.org/sightings/59d039a0686f743ec5020000',
    latitude: 48.047447813103005,
    longitude: -122.40477597314452,
    location: 'Camano Island, WA, US',
    sightedAt: DateTime.tryParse('2017-10-01T00:38:00Z'),
    createdAt: DateTime.tryParse('2017-10-01T00:41:04Z'),
    updatedAt: DateTime.tryParse('2017-10-03T22:01:43Z'),
  );

  final tSightingList = List.generate(3, (index) => tSighting);

  setUp(() {
    mockAppRepository = MockFavoritesRepository();
    usecase = GetCachedSightings(repository: mockAppRepository);
  });

  test(
    'should get a list of cached sightings from the repository',
    () async {
      // arrange
      when(
        () => mockAppRepository.getCachedSightings(),
      ).thenAnswer(
        (_) async => Right(tSightingList),
      );

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(tSightingList));
      verify(() => mockAppRepository.getCachedSightings());
      verifyNoMoreInteractions(mockAppRepository);
    },
  );

  test(
    'should get [CachingException] when getting cached data fails',
    () async {
      final cacheFailure = CacheFailure(exception: CacheException.defaultError);
      // arrange
      when(
        () => mockAppRepository.getCachedSightings(),
      ).thenAnswer((_) async => Left(cacheFailure));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Left(cacheFailure));
      verify(() => mockAppRepository.getCachedSightings());
      verifyNoMoreInteractions(mockAppRepository);
    },
  );
}
