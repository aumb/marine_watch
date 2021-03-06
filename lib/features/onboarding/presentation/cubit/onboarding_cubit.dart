import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marine_watch/features/app/domain/usecases/cache_is_fresh_install.dart';
import 'package:marine_watch/core/errors/failure.dart';
import 'package:marine_watch/core/nav/navgiation_manager.dart';
import 'package:marine_watch/core/usecases.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required this.cacheIsFreshInstall,
    required this.navigationManager,
  }) : super(OnboardingInitial());

  final CacheIsFreshInstall cacheIsFreshInstall;
  final NavigationManager navigationManager;

  Future<void> cacheIsFreshInstallEvent() async {
    emit(OnboardingLoading());
    final result = await cacheIsFreshInstall(NoParams());
    emit(_handleCacheIsFreshInstallEvent(result));
  }

  OnboardingState _handleCacheIsFreshInstallEvent(
      Either<Failure, bool> result) {
    return result.fold((l) {
      final error = l as CacheFailure;
      return OnboardingError(message: error.message);
    }, (r) {
      return OnboardingLoaded();
    });
  }
}
