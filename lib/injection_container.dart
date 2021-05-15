import 'package:get_it/get_it.dart';
import 'package:marine_watch/app/data/datasources/app_local_data_source.dart';
import 'package:marine_watch/app/data/repositories/app_repository_impl.dart';
import 'package:marine_watch/app/domain/repositories/app_repository.dart';
import 'package:marine_watch/app/domain/usecases/cache_is_fresh_install.dart';
import 'package:marine_watch/app/domain/usecases/get_cached_is_fresh_install.dart';
import 'package:marine_watch/app/presentation/bloc/app_bloc.dart';
import 'package:marine_watch/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:marine_watch/utils/nav/navgiation_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  //Blocs & Cubits
  sl
    ..registerLazySingleton(() => NavigationManager())
    ..registerFactory(
      () => OnboardingCubit(
        cacheIsFreshInstall: sl(),
      ),
    )
    ..registerLazySingleton(
      () => CacheIsFreshInstall(
        repository: sl(),
      ),
    )
    ..registerLazySingleton(
      () => GetCachedIsFreshInstall(
        repository: sl(),
      ),
    )
    ..registerLazySingleton<AppRepository>(
      () => AppRepositoryImpl(
        localDataSource: sl(),
      ),
    )
    ..registerLazySingleton<AppLocalDataSource>(
      () => AppLocalDataSourceImpl(sharedPreferences: sl()),
    )
    ..registerLazySingleton(() => sharedPreferences)
    ..registerFactory(
      () => AppBloc(
        getCachedIsFreshInstall: sl(),
      ),
    );
}
