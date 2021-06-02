import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marine_watch/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:marine_watch/features/favorites/domain/usecases/cache_sighting.dart';
import 'package:marine_watch/features/favorites/domain/usecases/delete_cahced_sighting.dart';
import 'package:marine_watch/features/favorites/domain/usecases/get_cached_sightings.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/core/errors/failure.dart';
import 'package:marine_watch/core/usecases.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({
    required this.getCachedSightings,
    required this.cacheSighting,
    required this.deleteCachedSighting,
    required this.favoritesRepository,
  }) : super(FavoritesInitial());

  final GetCachedSightings getCachedSightings;
  final CacheSighting cacheSighting;
  final DeleteCachedSighting deleteCachedSighting;
  final FavoritesRepository favoritesRepository;

  List<Sighting?> get favoriteSightings =>
      favoritesRepository.favoriteSightings?.reversed.toList() ?? [];

  @override
  Stream<FavoritesState> mapEventToState(
    FavoritesEvent event,
  ) async* {
    if (event is GetCachedSightingsEvent) {
      yield FavoritesLoading();
      final result = await getCachedSightings(NoParams());
      yield _mapGetCachedSightingsEvent(result);
    } else if (event is CacheSightingEvent) {
      yield FavoritesLoading();
      final result = await cacheSighting(
        CacheSightingParams(
          sighting: event.sighting,
        ),
      );
      yield _mapCacheSightingEvent(result);
    } else if (event is DeleteCachedSightingEvent) {
      yield FavoritesLoading();
      final result = await deleteCachedSighting(
        DeleteCachedSightingParams(
          sighting: event.sighting,
        ),
      );
      yield _mapDeleteCachedSightingEvent(result);
    }
  }

  FavoritesState _mapGetCachedSightingsEvent(
      Either<Failure, List<Sighting?>?> result) {
    return result.fold(
      (l) {
        l as CacheFailure;
        return FavoritesError(message: l.message);
      },
      _hasFavorites,
    );
  }

  FavoritesState _mapCacheSightingEvent(
      Either<Failure, List<Sighting?>?> result) {
    return result.fold(
      (l) {
        l as CacheFailure;
        return FavoritesError(message: l.message);
      },
      _hasFavorites,
    );
  }

  FavoritesState _mapDeleteCachedSightingEvent(
      Either<Failure, List<Sighting?>?> result) {
    return result.fold(
      (l) {
        l as CacheFailure;
        return FavoritesError(message: l.message);
      },
      _hasFavorites,
    );
  }

  FavoritesState _hasFavorites(List<Sighting?>? sightings) {
    if (sightings?.isEmpty ?? true) {
      return FavoritesEmpty();
    } else {
      return FavoritesLoaded();
    }
  }
}
