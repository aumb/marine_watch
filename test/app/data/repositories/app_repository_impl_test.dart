import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/app/data/datasources/app_local_data_source.dart';
import 'package:marine_watch/app/data/repositories/app_repository_impl.dart';
import 'package:marine_watch/utils/const_utils.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements AppLocalDataSource {}

void main() {
  late MockLocalDataSource mockLocalDataSource;
  late AppRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = AppRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

  group('cacheIsFreshInstall', () {
    test(
      'should return true when caching is successful',
      () async {
        // arrange
        when(() => mockLocalDataSource.cacheIsFreshInstall())
            .thenAnswer((_) async => true);
        // act
        final result = await repository.cacheIsFreshInstall();
        // assert
        verify(() => mockLocalDataSource.cacheIsFreshInstall());

        expect(result, equals(const Right(true)));
      },
    );

    test(
      'should return [CacheFailure] when caching has failed',
      () async {
        final exception = CacheException.defaultError;
        final error = CacheFailure(exception: exception);
        // arrange
        when(() => mockLocalDataSource.cacheIsFreshInstall())
            .thenThrow(exception);
        // act
        final result = await repository.cacheIsFreshInstall();
        // assert
        verify(() => mockLocalDataSource.cacheIsFreshInstall());

        expect(result, equals(Left(error)));
      },
    );
  });

  group('getCachedIsFreshInstall', () {
    test(
      'should return the value of $isFreshInstallConst',
      () async {
        final isFreshInstall = false;
        // arrange
        when(() => mockLocalDataSource.getCachedIsFreshInstall())
            .thenReturn(isFreshInstall);
        // act
        final result = await repository.getCachedIsFreshInstall();
        // assert
        verify(() => mockLocalDataSource.getCachedIsFreshInstall());

        expect(result, equals(Right(isFreshInstall)));
      },
    );

    test(
      'should return [CacheFailure] when an error occurs',
      () async {
        final exception = CacheException.defaultError;
        final error = CacheFailure(exception: exception);
        // arrange
        when(() => mockLocalDataSource.getCachedIsFreshInstall())
            .thenThrow(exception);
        // act
        final result = await repository.getCachedIsFreshInstall();
        // assert
        verify(() => mockLocalDataSource.getCachedIsFreshInstall());

        expect(result, equals(Left(error)));
      },
    );
  });
}
