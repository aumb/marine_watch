import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/favorites/domain/usecases/cache_sighting.dart';
import 'package:marine_watch/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:marine_watch/features/sighting/presentation/bloc/sighting_bloc.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/core/utils/url_launcher_utils.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockFavoritesBloc extends Mock implements FavoritesBloc {}

class MockUrlLauncherUtils extends Mock implements UrlLauncherUtils {}

class MockFavoritesBlocStream extends Mock implements Stream<FavoritesState> {}

void main() {
  late MockFavoritesBloc mockFavoritesBloc;
  late MockUrlLauncherUtils mockUrlLauncherUtils;

  final sighting = sightingFromJson(fixture('sighting.json'));

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();
    mockUrlLauncherUtils = MockUrlLauncherUtils();
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
    test('initial state is [SightingInitial]', () {
      setupLoadedFavoriteState();
      expect(
          SightingBloc(
                  sighting: sighting,
                  favoriteBloc: mockFavoritesBloc,
                  urlLauncherUtils: mockUrlLauncherUtils)
              .state,
          equals(SightingInitial()));
    });

    group('ToggleFavoriteSightingEvent (Favorting)', () {
      blocTest<SightingBloc, SightingState>(
        'emits [SightingFavorite] when caching occurs',
        build: () {
          setupLoadedFavoriteState();
          return SightingBloc(
            sighting: sighting,
            urlLauncherUtils: mockUrlLauncherUtils,
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
            urlLauncherUtils: mockUrlLauncherUtils,
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
            urlLauncherUtils: mockUrlLauncherUtils,
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
            urlLauncherUtils: mockUrlLauncherUtils,
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

    group('TrackButtonPressedEvent', () {
      blocTest<SightingBloc, SightingState>(
        'calls launchCoordinates and emits no state',
        build: () {
          setupLoadedFavoriteStateUnFavorite();
          when(() =>
                  mockUrlLauncherUtils.launchCoordinates(any(), any(), any()))
              .thenAnswer((invocation) async => true);
          return SightingBloc(
            urlLauncherUtils: mockUrlLauncherUtils,
            sighting: sighting,
            favoriteBloc: mockFavoritesBloc,
          );
        },
        act: (bloc) => bloc.add(TrackButtonPressedEvent()),
      );
    });
  });
}
