import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marine_watch/app/domain/usecases/get_cached_is_fresh_install.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:marine_watch/utils/usecases.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required this.getCachedIsFreshInstall,
  }) : super(AppInitial());

  final GetCachedIsFreshInstall getCachedIsFreshInstall;

  bool isFreshInstall = true;

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is GetIsFreshInstallEvent) {
      final result = await getCachedIsFreshInstall(NoParams());
      yield _handleGetCachedResult(result);
    }
  }

  AppState _handleGetCachedResult(Either<Failure, bool> result) {
    return result.fold((l) {
      final error = l as CacheFailure;
      return AppError(message: error.message);
    }, (r) {
      isFreshInstall = r;
      return AppLoaded();
    });
  }
}
