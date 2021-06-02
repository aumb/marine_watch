import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marine_watch/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/utils/url_launcher_utils.dart';

part 'sighting_event.dart';
part 'sighting_state.dart';

class SightingBloc extends Bloc<SightingEvent, SightingState> {
  SightingBloc({
    required this.favoriteBloc,
    required this.sighting,
    required this.urlLauncherUtils,
  }) : super(SightingInitial()) {
    _favoriteBlocSubcription = favoriteBloc.stream.listen((state) {
      if (state is FavoritesError) {
        add(ToggleFavoriteSightingErrorEvent());
      }
    });
    _isFavorite = checkIsFavorite();
  }

  final Sighting? sighting;
  final FavoritesBloc favoriteBloc;
  final UrlLauncherUtils urlLauncherUtils;

  late StreamSubscription _favoriteBlocSubcription;

  late bool _isFavorite;
  bool get isFavorite => _isFavorite;

  @override
  Future<void> close() {
    _favoriteBlocSubcription.cancel();
    return super.close();
  }

  @override
  Stream<SightingState> mapEventToState(
    SightingEvent event,
  ) async* {
    if (event is ToggleFavoriteSightingEvent) {
      _isFavorite = !_isFavorite;
      if (_isFavorite) {
        favoriteBloc.add(
          CacheSightingEvent(
            sighting: sighting!,
          ),
        );

        yield SightingFavorite();
      } else {
        favoriteBloc.add(
          DeleteCachedSightingEvent(
            sighting: sighting!,
          ),
        );
        yield SightingUnfavorite();
      }
    } else if (event is ToggleFavoriteSightingErrorEvent) {
      _isFavorite = !_isFavorite;
      if (_isFavorite) {
        yield SightingFavorite();
      } else {
        yield SightingUnfavorite();
      }
    } else if (event is TrackButtonPressedEvent) {
      if (sighting?.longitude != null && sighting?.latitude != null) {
        await urlLauncherUtils.launchCoordinates(
          sighting!.longitude!.toDouble(),
          sighting!.latitude!.toDouble(),
        );
      }
    }
  }

  bool checkIsFavorite() {
    var cachedSighting = favoriteBloc.favoriteSightings.firstWhere(
      (element) => element?.id == sighting?.id,
      orElse: () => null,
    );

    if (cachedSighting != null) {
      return true;
    } else {
      return false;
    }
  }
}
