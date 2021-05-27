import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marine_watch/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:marine_watch/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:marine_watch/injection_container.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.favoritesBloc,
  }) : super(HomeInitial()) {
    setupFavoritesBlocSubscription();
  }

  final FavoritesBloc favoritesBloc;
  late StreamSubscription favoritesBlocSubscription;

  @override
  Future<void> close() {
    favoritesBlocSubscription.cancel();
    return super.close();
  }

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetFavoriteSightingsEvent) {
      favoritesBloc.add(GetCachedSightingsEvent());
    } else if (event is ShowErrorEvent) {
      //TODO: listen to error event and show snackbar
      yield HomeError(message: event.message, code: event.code);
    }
  }

  void setupFavoritesBlocSubscription() {
    favoritesBlocSubscription = favoritesBloc.stream.listen((state) {
      if (state is FavoritesError) {
        add(ShowErrorEvent(message: state.message, code: state.code));
      } else if (state is FavoritesLoaded) {
        print(sl<FavoritesRepository>().favoriteSightings);
      }
    });
  }
}
