import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:marine_watch/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:marine_watch/features/favorites/domain/usecases/cache_sighting.dart';
import 'package:marine_watch/features/favorites/domain/usecases/delete_cahced_sighting.dart';
import 'package:marine_watch/features/favorites/domain/usecases/get_cached_sightings.dart';
import 'package:marine_watch/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/core/errors/exceptions.dart';
import 'package:marine_watch/core/errors/failure.dart';
import 'package:marine_watch/core/usecases.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetCachedSightings extends Mock implements GetCachedSightings {}

class MockCacheSighting extends Mock implements CacheSighting {}

class MockDeleteCachedSighting extends Mock implements DeleteCachedSighting {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late MockGetCachedSightings mockGetCachedSightings;
  late MockCacheSighting mockCacheSighting;
  late MockDeleteCachedSighting mockDeleteCachedSighting;
  late MockFavoritesRepository mockFavoritesRepository;

  final sightings = sightingsFromJson(fixture('sightings.json'));
  final sighting = sightingFromJson(fixture('sighting.json'));

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    registerFallbackValue<CacheSightingParams>(
        CacheSightingParams(sighting: sighting));
    registerFallbackValue<DeleteCachedSightingParams>(
        DeleteCachedSightingParams(sighting: sighting));
    mockGetCachedSightings = MockGetCachedSightings();
    mockCacheSighting = MockCacheSighting();
    mockDeleteCachedSighting = MockDeleteCachedSighting();
    mockFavoritesRepository = MockFavoritesRepository();
  });

  group('Favorites bloc', () {
    final cacheFailure = CacheFailure(exception: CacheException.defaultError);
    test('initial state is [FavoritesInitial]', () {
      expect(
          FavoritesBloc(
            favoritesRepository: mockFavoritesRepository,
            getCachedSightings: mockGetCachedSightings,
            deleteCachedSighting: mockDeleteCachedSighting,
            cacheSighting: mockCacheSighting,
          ).state,
          equals(FavoritesInitial()));
    });

    group('CacheSightingEvent', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesLoaded] when caching is successful',
        build: () {
          when(() => mockCacheSighting(any()))
              .thenAnswer((_) async => Right(sightings));
          return FavoritesBloc(
            favoritesRepository: mockFavoritesRepository,
            getCachedSightings: mockGetCachedSightings,
            deleteCachedSighting: mockDeleteCachedSighting,
            cacheSighting: mockCacheSighting,
          );
        },
        verify: (_) {
          verify(() => mockCacheSighting(any())).called(1);
        },
        act: (bloc) => bloc.add(CacheSightingEvent(sighting: sighting)),
        expect: () => [FavoritesLoading(), FavoritesLoaded()],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesError] when request fails',
        build: () {
          when(() => mockCacheSighting(any()))
              .thenAnswer((_) async => Left(cacheFailure));
          return FavoritesBloc(
            favoritesRepository: mockFavoritesRepository,
            getCachedSightings: mockGetCachedSightings,
            deleteCachedSighting: mockDeleteCachedSighting,
            cacheSighting: mockCacheSighting,
          );
        },
        verify: (_) {
          verify(() => mockCacheSighting(any())).called(1);
        },
        act: (bloc) => bloc.add(CacheSightingEvent(sighting: sighting)),
        expect: () => [
          FavoritesLoading(),
          FavoritesError(
            message: cacheFailure.message,
          )
        ],
      );
    });

    group('GetCachedSightingsEvent', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesLoaded] when caching is successful',
        build: () {
          when(() => mockGetCachedSightings(any()))
              .thenAnswer((_) async => Right(sightings));
          return FavoritesBloc(
            favoritesRepository: mockFavoritesRepository,
            getCachedSightings: mockGetCachedSightings,
            deleteCachedSighting: mockDeleteCachedSighting,
            cacheSighting: mockCacheSighting,
          );
        },
        verify: (_) {
          verify(() => mockGetCachedSightings(any())).called(1);
        },
        act: (bloc) => bloc.add(GetCachedSightingsEvent()),
        expect: () => [FavoritesLoading(), FavoritesLoaded()],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesError] when get caching fails',
        build: () {
          when(() => mockGetCachedSightings(any()))
              .thenAnswer((_) async => Left(cacheFailure));
          return FavoritesBloc(
            favoritesRepository: mockFavoritesRepository,
            getCachedSightings: mockGetCachedSightings,
            deleteCachedSighting: mockDeleteCachedSighting,
            cacheSighting: mockCacheSighting,
          );
        },
        verify: (_) {
          verify(() => mockGetCachedSightings(any())).called(1);
        },
        act: (bloc) => bloc.add(GetCachedSightingsEvent()),
        expect: () => [
          FavoritesLoading(),
          FavoritesError(
            message: cacheFailure.message,
          )
        ],
      );
    });

    group('GetCachedSightingsEvent', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesLoaded] when caching is successful',
        build: () {
          when(() => mockGetCachedSightings(any()))
              .thenAnswer((_) async => Right(sightings));
          return FavoritesBloc(
            favoritesRepository: mockFavoritesRepository,
            getCachedSightings: mockGetCachedSightings,
            deleteCachedSighting: mockDeleteCachedSighting,
            cacheSighting: mockCacheSighting,
          );
        },
        verify: (_) {
          verify(() => mockGetCachedSightings(any())).called(1);
        },
        act: (bloc) => bloc.add(GetCachedSightingsEvent()),
        expect: () => [FavoritesLoading(), FavoritesLoaded()],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesError] when get caching fails',
        build: () {
          when(() => mockGetCachedSightings(any()))
              .thenAnswer((_) async => Left(cacheFailure));
          return FavoritesBloc(
            favoritesRepository: mockFavoritesRepository,
            getCachedSightings: mockGetCachedSightings,
            deleteCachedSighting: mockDeleteCachedSighting,
            cacheSighting: mockCacheSighting,
          );
        },
        verify: (_) {
          verify(() => mockGetCachedSightings(any())).called(1);
        },
        act: (bloc) => bloc.add(GetCachedSightingsEvent()),
        expect: () => [
          FavoritesLoading(),
          FavoritesError(
            message: cacheFailure.message,
          )
        ],
      );
    });

    group('DeleteCachedSightingEvent', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesLoaded] when caching is successful',
        build: () {
          when(() => mockDeleteCachedSighting(any()))
              .thenAnswer((_) async => Right(sightings));
          return FavoritesBloc(
            favoritesRepository: mockFavoritesRepository,
            getCachedSightings: mockGetCachedSightings,
            deleteCachedSighting: mockDeleteCachedSighting,
            cacheSighting: mockCacheSighting,
          );
        },
        verify: (_) {
          verify(() => mockDeleteCachedSighting(any())).called(1);
        },
        act: (bloc) => bloc.add(DeleteCachedSightingEvent(sighting: sighting)),
        expect: () => [FavoritesLoading(), FavoritesLoaded()],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesError] when request fails',
        build: () {
          when(() => mockDeleteCachedSighting(any()))
              .thenAnswer((_) async => Left(cacheFailure));
          return FavoritesBloc(
            favoritesRepository: mockFavoritesRepository,
            getCachedSightings: mockGetCachedSightings,
            deleteCachedSighting: mockDeleteCachedSighting,
            cacheSighting: mockCacheSighting,
          );
        },
        verify: (_) {
          verify(() => mockDeleteCachedSighting(any())).called(1);
        },
        act: (bloc) => bloc.add(DeleteCachedSightingEvent(sighting: sighting)),
        expect: () => [
          FavoritesLoading(),
          FavoritesError(
            message: cacheFailure.message,
          )
        ],
      );
    });
  });
}
