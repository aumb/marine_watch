import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:marine_watch/features/app/domain/usecases/cache_is_fresh_install.dart';
import 'package:marine_watch/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:marine_watch/core/errors/exceptions.dart';
import 'package:marine_watch/core/errors/failure.dart';
import 'package:marine_watch/core/nav/navgiation_manager.dart';
import 'package:marine_watch/core/usecases.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheIsFreshInstall extends Mock implements CacheIsFreshInstall {}

class MockNavigationManager extends Mock implements NavigationManager {}

void main() {
  late MockCacheIsFreshInstall mockCacheIsFreshInstall;
  late MockNavigationManager mockNavigationManager;

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    mockCacheIsFreshInstall = MockCacheIsFreshInstall();
    mockNavigationManager = MockNavigationManager();
  });

  group('Onboarding Cubit', () {
    final cacheFailure = CacheFailure(exception: CacheException.defaultError);
    test('initial state is [OnboardingInitial]', () {
      expect(
          OnboardingCubit(
            cacheIsFreshInstall: mockCacheIsFreshInstall,
            navigationManager: mockNavigationManager,
          ).state,
          equals(OnboardingInitial()));
    });

    blocTest<OnboardingCubit, OnboardingState>(
      'emits [OnboardingLoading, OnboardingLoaded] when cache is successful',
      build: () {
        when(() => mockCacheIsFreshInstall(any()))
            .thenAnswer((_) async => const Right(true));
        return OnboardingCubit(
          cacheIsFreshInstall: mockCacheIsFreshInstall,
          navigationManager: mockNavigationManager,
        );
      },
      verify: (_) {
        verify(() => mockCacheIsFreshInstall(any())).called(1);
      },
      act: (cubit) => cubit.cacheIsFreshInstallEvent(),
      expect: () => [OnboardingLoading(), OnboardingLoaded()],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'emits [OnboardingLoading, OnboardingError] when cache fails',
      build: () {
        when(() => mockCacheIsFreshInstall(any()))
            .thenAnswer((_) async => Left(cacheFailure));
        return OnboardingCubit(
          cacheIsFreshInstall: mockCacheIsFreshInstall,
          navigationManager: mockNavigationManager,
        );
      },
      verify: (_) {
        verify(() => mockCacheIsFreshInstall(any())).called(1);
      },
      act: (cubit) => cubit.cacheIsFreshInstallEvent(),
      expect: () =>
          [OnboardingLoading(), OnboardingError(message: cacheFailure.message)],
    );
  });
}
