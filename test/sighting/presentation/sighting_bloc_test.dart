import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/favorites/domain/usecases/cache_sighting.dart';
import 'package:marine_watch/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:marine_watch/features/sighting/presentation/bloc/sighting_bloc.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixture_reader.dart';

class MockFavoritesBloc extends Mock implements FavoritesBloc {}

class MockFavoritesBlocStream extends Mock implements Stream<FavoritesState> {}

void main() {
  late MockFavoritesBloc mockFavoritesBloc;

  final sighting = sightingFromJson(fixture('sighting.json'));

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();
    registerFallbackValue<CacheSightingParams>(
        CacheSightingParams(sighting: sighting));
  });

  void setupLoadedFavoriteState() async {
    when(() => mockFavoritesBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([FavoritesLoaded()]),
    );

    when(() => mockFavoritesBloc.favoriteSightings).thenAnswer(
      (_) => [],
    );
  }

  void setupErrorFavoriteState() async {
    when(() => mockFavoritesBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([FavoritesError(message: '')]),
    );

    when(() => mockFavoritesBloc.favoriteSightings).thenAnswer(
      (_) => [],
    );
  }

  void setupLoadedFavoriteStateUnFavorite() async {
    when(() => mockFavoritesBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([FavoritesLoaded()]),
    );

    when(() => mockFavoritesBloc.favoriteSightings).thenAnswer(
      (_) => [sighting],
    );
  }

  void setupErrorFavoriteStateUnFavorite() async {
    when(() => mockFavoritesBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([FavoritesError(message: '')]),
    );

    when(() => mockFavoritesBloc.favoriteSightings).thenAnswer(
      (_) => [sighting],
    );
  }

  group('Sighting bloc', () {
    final cacheFailure = CacheFailure(exception: CacheException.defaultError);
    test('initial state is [SightingInitial]', () {
      setupLoadedFavoriteState();
      expect(
          SightingBloc(
            sighting: sighting,
            favoriteBloc: mockFavoritesBloc,
          ).state,
          equals(SightingInitial()));
    });

    group('ToggleFavoriteSightingEvent (Favorting)', () {
      blocTest<SightingBloc, SightingState>(
        'emits [SightingFavorite] when caching occurs',
        build: () {
          setupLoadedFavoriteState();
          return SightingBloc(
            sighting: sighting,
            favoriteBloc: mockFavoritesBloc,
          );
        },
        verify: (_) {
          verify(() =>
              mockFavoritesBloc.add(CacheSightingEvent(sighting: sighting)));
        },
        act: (bloc) => bloc.add(ToggleFavoriteSightingEvent()),
        expect: () => [SightingFavorite()],
      );

      blocTest<SightingBloc, SightingState>(
        'emits [SightingFavorite, SightingUnfavorite] when caching is fails',
        build: () {
          setupErrorFavoriteState();
          return SightingBloc(
            sighting: sighting,
            favoriteBloc: mockFavoritesBloc,
          );
        },
        verify: (_) {
          verify(() =>
              mockFavoritesBloc.add(CacheSightingEvent(sighting: sighting)));
        },
        act: (bloc) => bloc.add(ToggleFavoriteSightingEvent()),
        expect: () => [SightingFavorite(), SightingUnfavorite()],
      );
    });

    group('ToggleFavoriteSightingEvent (Unfavoriting)', () {
      blocTest<SightingBloc, SightingState>(
        'emits [SightingFavorite] when caching occurs',
        build: () {
          setupLoadedFavoriteStateUnFavorite();
          return SightingBloc(
            sighting: sighting,
            favoriteBloc: mockFavoritesBloc,
          );
        },
        verify: (_) {
          verify(() => mockFavoritesBloc
              .add(DeleteCachedSightingEvent(sighting: sighting)));
        },
        act: (bloc) => bloc.add(ToggleFavoriteSightingEvent()),
        expect: () => [SightingUnfavorite()],
      );

      blocTest<SightingBloc, SightingState>(
        'emits [SightingFavorite, SightingUnfavorite] when caching is fails',
        build: () {
          setupErrorFavoriteStateUnFavorite();
          return SightingBloc(
            sighting: sighting,
            favoriteBloc: mockFavoritesBloc,
          );
        },
        verify: (_) {
          verify(() => mockFavoritesBloc
              .add(DeleteCachedSightingEvent(sighting: sighting)));
        },
        act: (bloc) => bloc.add(ToggleFavoriteSightingEvent()),
        expect: () => [SightingUnfavorite(), SightingFavorite()],
      );
    });
  });
}
