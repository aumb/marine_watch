import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:marine_watch/features/home/presentation/bloc/home_bloc.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures/fixture_reader.dart';

class MockFavoritesBloc extends Mock implements FavoritesBloc {}

class MockFavoritesBlocStream extends Mock implements Stream<FavoritesState> {}

void main() {
  late MockFavoritesBloc mockFavoritesBloc;

  final sighting = sightingFromJson(fixture('sighting.json'));

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();
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
      (_) => [sighting],
    );
  }

  group('Home bloc', () {
    test('initial state is [HomeInitial]', () {
      setupLoadedFavoriteState();
      expect(HomeBloc(favoritesBloc: mockFavoritesBloc).state,
          equals(HomeInitial()));
    });

    group('GetFavoriteSightingsEvent', () {
      blocTest<HomeBloc, HomeState>(
        'emits no state when getting favorite sightings',
        build: () {
          setupLoadedFavoriteState();
          return (HomeBloc(favoritesBloc: mockFavoritesBloc));
        },
        verify: (_) {
          verify(() => mockFavoritesBloc.add(GetCachedSightingsEvent()));
        },
        act: (bloc) => bloc.add(GetFavoriteSightingsEvent()),
        expect: () => [],
      );

      blocTest<HomeBloc, HomeState>(
        'emits [HomeError] when getting favorite sightings fails',
        build: () {
          setupErrorFavoriteState();
          return (HomeBloc(favoritesBloc: mockFavoritesBloc));
        },
        verify: (bloc) {
          verify(() => mockFavoritesBloc.add(GetCachedSightingsEvent()));
        },
        act: (bloc) => bloc.add(GetFavoriteSightingsEvent()),
        expect: () => [HomeError(message: '', code: 500)],
      );
    });

    group('ChangeTabBarIndexEvent', () {
      blocTest<HomeBloc, HomeState>(
        'emits [HomeLoading, HomeLoaded] when changing index',
        build: () {
          setupLoadedFavoriteState();
          return (HomeBloc(favoritesBloc: mockFavoritesBloc));
        },
        act: (bloc) => bloc.add(ChangeTabBarIndexEvent(index: 2)),
        expect: () => [HomeLoading(), HomeLoaded()],
      );
    });
  });
}
