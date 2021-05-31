import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/utils/const_utils.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late FavoritesLocalDataSource dataSource;
  late MockSharedPreferences mockSharedPreferences;

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
  final tSightingListEncoded =
      List.generate(3, (index) => jsonEncode(tSighting.toJson()));

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = FavoritesLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('cacheSighting', () {
    test(
      'should return a list of sighitngs caching is successfull',
      () async {
        //arrange
        when(() => mockSharedPreferences.getStringList(any())).thenReturn(
          tSightingListEncoded,
        );
        when(() => mockSharedPreferences.setStringList(any(), any()))
            .thenAnswer((invocation) async => true);
        // act
        final result = await dataSource.cacheSighting(tSighting);
        // assert
        verify(
          () => mockSharedPreferences.setStringList(
            favoriteSightingsConst,
            [
              ...tSightingListEncoded,
              jsonEncode(tSighting.toJson()),
            ],
          ),
        );
        expect(
          result?.length,
          equals(tSightingListEncoded.length + 1),
        );
      },
    );

    test(
      'should throw a [CacheException] if caching returns false',
      () async {
        // arrange
        when(() => mockSharedPreferences.setStringList(any(), any()))
            .thenAnswer((_) async => false);
        // act
        final call = dataSource.cacheSighting;
        // assert
        expect(call(tSighting), throwsA(const TypeMatcher<CacheException>()));
      },
    );

    test(
      'should throw a [CacheException] if caching fails',
      () async {
        final error = CacheException.defaultError;
        // arrange
        when(() => mockSharedPreferences.setStringList(any(), any()))
            .thenThrow(error);
        // act
        final call = dataSource.cacheSighting;
        // assert
        expect(call(tSighting), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('getCachedSightings', () {
    test(
      'should return [Sighting] caching is successfull',
      () async {
        //arrange
        when(() => mockSharedPreferences.getStringList(any()))
            .thenAnswer((invocation) => tSightingListEncoded);
        // act
        final result = dataSource.getCachedSightings();
        // assert
        verify(
          () => mockSharedPreferences.getStringList(favoriteSightingsConst),
        );
        expect(result, equals(tSightingList));
      },
    );

    test(
      'should return an empty list if getStringList fails',
      () async {
        // arrange
        when(() => mockSharedPreferences.getStringList(any())).thenReturn(null);
        // act
        final call = dataSource.getCachedSightings;
        // assert
        expect(call(), equals(<String>[]));
      },
    );
  });

  group('deleteCachedSighting', () {
    test(
      'should return [Sighting] if delete cache is successfull',
      () async {
        final tSightingsEncodedWithItemRemoved = [...tSightingListEncoded]
          ..removeAt(0);

        //arrange
        when(() => mockSharedPreferences.getStringList(any())).thenReturn(
          tSightingListEncoded,
        );
        when(() => mockSharedPreferences.setStringList(any(), any()))
            .thenAnswer((invocation) async => true);
        // act
        final result = await dataSource.deleteCachedSighting(tSighting);
        // assert
        verify(
          () => mockSharedPreferences.setStringList(
            favoriteSightingsConst,
            [
              ...tSightingsEncodedWithItemRemoved,
            ],
          ),
        );
        expect(
          result?.length,
          equals(tSightingListEncoded.length - 1),
        );
      },
    );

    test(
      'should throw a [CacheException] if the item could not be found',
      () async {
        // arrange
        when(() => mockSharedPreferences.setStringList(any(), any()))
            .thenAnswer((invocation) async => true);
        // act
        final call = dataSource.deleteCachedSighting;
        // assert
        expect(call(null), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });
}
