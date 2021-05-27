import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:marine_watch/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements FavoritesLocalDataSource {}

void main() {
  late MockLocalDataSource mockLocalDataSource;
  late FavoritesRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = FavoritesRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

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

  group('cacheSighting', () {
    test(
      'should return a list of sightings when caching is successful',
      () async {
        // arrange
        when(() => mockLocalDataSource.cacheSighting(tSighting))
            .thenAnswer((_) async => tSightingList);
        // act
        final result = await repository.cacheSighting(tSighting);
        // assert
        verify(() => mockLocalDataSource.cacheSighting(tSighting));

        expect(tSightingList, equals(repository.favoriteSightings));
        expect(result, equals(Right(tSightingList)));
      },
    );

    test(
      'should return [CacheFailure] when caching has failed',
      () async {
        final exception = CacheException.defaultError;
        final error = CacheFailure(exception: exception);
        // arrange
        when(() => mockLocalDataSource.cacheSighting(tSighting))
            .thenThrow(exception);
        // act
        final result = await repository.cacheSighting(tSighting);
        // assert
        verify(() => mockLocalDataSource.cacheSighting(tSighting));

        expect(result, equals(Left(error)));
      },
    );
  });

  group('getCachedSightings', () {
    test(
      'should return a list of sightings when caching is successful',
      () async {
        // arrange
        when(() => mockLocalDataSource.getCachedSightings())
            .thenReturn(tSightingList);
        // act
        final result = await repository.getCachedSightings();
        // assert

        verify(() => mockLocalDataSource.getCachedSightings());

        expect(tSightingList, equals(repository.favoriteSightings));
        expect(result, equals(Right(tSightingList)));
      },
    );

    test(
      'should return [CacheFailure] when an error occurs',
      () async {
        final exception = CacheException.defaultError;
        final error = CacheFailure(exception: exception);
        // arrange
        when(() => mockLocalDataSource.getCachedSightings())
            .thenThrow(exception);
        // act
        final result = await repository.getCachedSightings();
        // assert
        verify(() => mockLocalDataSource.getCachedSightings());

        expect(result, equals(Left(error)));
      },
    );
  });

  group('deleteCachedSighting', () {
    test(
      'should return a list of sightings when deleting cache is successful',
      () async {
        // arrange
        when(() => mockLocalDataSource.deleteCachedSighting(tSighting))
            .thenAnswer((_) async => tSightingList);
        // act
        final result = await repository.deleteCachedSighting(tSighting);
        // assert
        verify(() => mockLocalDataSource.deleteCachedSighting(tSighting));

        expect(tSightingList, equals(repository.favoriteSightings));
        expect(result, equals(Right(tSightingList)));
      },
    );

    test(
      'should return [CacheFailure] when deleteing cache has failed',
      () async {
        final exception = CacheException.defaultError;
        final error = CacheFailure(exception: exception);
        // arrange
        when(() => mockLocalDataSource.deleteCachedSighting(tSighting))
            .thenThrow(exception);
        // act
        final result = await repository.deleteCachedSighting(tSighting);
        // assert
        verify(() => mockLocalDataSource.deleteCachedSighting(tSighting));

        expect(result, equals(Left(error)));
      },
    );
  });
}
