import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:marine_watch/app/domain/usecases/cache_is_fresh_install.dart';
import 'package:marine_watch/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:marine_watch/utils/usecases.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheIsFreshInstall extends Mock implements CacheIsFreshInstall {}

void main() {
  late MockCacheIsFreshInstall mockCacheIsFreshInstall;

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    mockCacheIsFreshInstall = MockCacheIsFreshInstall();
  });

  group('Onboarding Cubit', () {
    final cacheFailure = CacheFailure(exception: CacheException.defaultError);
    test('initial state is [OnboardingInitial]', () {
      expect(
          OnboardingCubit(cacheIsFreshInstall: mockCacheIsFreshInstall).state,
          equals(OnboardingInitial()));
    });

    blocTest<OnboardingCubit, OnboardingState>(
      'emits [OnboardingLoading, OnboardingLoaded] when cache is successful',
      build: () {
        when(() => mockCacheIsFreshInstall(any()))
            .thenAnswer((_) async => const Right(true));
        return OnboardingCubit(cacheIsFreshInstall: mockCacheIsFreshInstall);
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
        return OnboardingCubit(cacheIsFreshInstall: mockCacheIsFreshInstall);
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
