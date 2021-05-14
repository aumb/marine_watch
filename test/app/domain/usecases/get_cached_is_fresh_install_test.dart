import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/app/domain/repositories/app_repository.dart';
import 'package:marine_watch/app/domain/usecases/get_cached_is_fresh_install.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:marine_watch/utils/usecases.dart';
import 'package:mocktail/mocktail.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  late GetCachedIsFreshInstall usecase;
  late MockAppRepository mockAppRepository;
  late bool isFreshInstall;

  setUp(() {
    isFreshInstall = true;
    mockAppRepository = MockAppRepository();
    usecase = GetCachedIsFreshInstall(repository: mockAppRepository);
  });

  test(
    'should [isFreshInstall] value from the repository',
    () async {
      // arrange
      when(
        () => mockAppRepository.getCachedIsFreshInstall(),
      ).thenAnswer((_) async => Right(isFreshInstall));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(isFreshInstall));
      verify(() => mockAppRepository.getCachedIsFreshInstall());
      verifyNoMoreInteractions(mockAppRepository);
    },
  );

  test(
    'should get [CachingException] when getting [isFreshInstall] fails',
    () async {
      final cacheFailure = CacheFailure(exception: CacheException.defaultError);
      // arrange
      when(
        () => mockAppRepository.getCachedIsFreshInstall(),
      ).thenAnswer((_) async => Left(cacheFailure));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Left(cacheFailure));
      verify(() => mockAppRepository.getCachedIsFreshInstall());
      verifyNoMoreInteractions(mockAppRepository);
    },
  );
}
