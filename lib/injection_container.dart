import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:marine_watch/app/data/datasources/app_local_data_source.dart';
import 'package:marine_watch/app/data/repositories/app_repository_impl.dart';
import 'package:marine_watch/app/domain/repositories/app_repository.dart';
import 'package:marine_watch/app/domain/usecases/cache_is_fresh_install.dart';
import 'package:marine_watch/app/domain/usecases/get_cached_is_fresh_install.dart';
import 'package:marine_watch/app/presentation/bloc/app_bloc.dart';
import 'package:marine_watch/features/home/presentation/bloc/home_bloc.dart';
import 'package:marine_watch/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:marine_watch/features/sightings/data/datasources/sightings_remote_data_source.dart';
import 'package:marine_watch/features/sightings/data/repositories/sightings_repository_impl.dart';
import 'package:marine_watch/features/sightings/domain/repositories/sightings_repository.dart';
import 'package:marine_watch/features/sightings/domain/usecases/get_more_sightings.dart';
import 'package:marine_watch/features/sightings/domain/usecases/get_sightings.dart';
import 'package:marine_watch/features/sightings/presentation/bloc/sightings_bloc.dart';
import 'package:marine_watch/utils/api.dart';
import 'package:marine_watch/utils/bitmap_utils.dart';
import 'package:marine_watch/utils/nav/navgiation_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init({bool isTesting = false}) async {
  if (isTesting) {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
  }
  final sharedPreferences = await SharedPreferences.getInstance();
  //Blocs & Cubits
  sl
    ..registerLazySingleton(
      () => Dio(
        BaseOptions(baseUrl: API.base),
      )..interceptors.addAll([
          LogInterceptor(request: true),
        ]),
    )
    ..registerLazySingleton(() => sharedPreferences)
    ..registerLazySingleton(() => NavigationManager())
    ..registerLazySingleton(() => BitmapManager())
    ..registerFactory(
      () => OnboardingCubit(
        cacheIsFreshInstall: sl(),
        navigationManager: sl(),
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
    ..registerFactory(
      () => AppBloc(
        getCachedIsFreshInstall: sl(),
      ),
    )
    ..registerFactory(
      () => HomeBloc(),
    )
    ..registerLazySingleton(
      () => GetSightings(
        repository: sl(),
      ),
    )
    ..registerLazySingleton(
      () => GetMoreSightings(
        repository: sl(),
      ),
    )
    ..registerLazySingleton<SightingsRepository>(
      () => SightingsRepositoryImpl(
        remoteDataSource: sl(),
      ),
    )
    ..registerLazySingleton<SightingsRemoteDataSource>(
      () => SightingsRemoteDataSourceImpl(dio: sl()),
    )
    ..registerFactory(
      () => SightingsBloc(
        getSightings: sl(),
      ),
    );
}
