import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/app/data/datasources/app_local_data_source.dart';
import 'package:marine_watch/core/utils/const_utils.dart';
import 'package:marine_watch/core/errors/exceptions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AppLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AppLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('cacheIsFreshInstall', () {
    test(
      'should return true if [$isFreshInstallConst] is successfully cached',
      () async {
        //arrange
        when(() => mockSharedPreferences.setBool(any(), any()))
            .thenAnswer((invocation) async => true);
        // act
        final result = await dataSource.cacheIsFreshInstall();
        // assert
        verify(() => mockSharedPreferences.setBool('isFreshInstall', false));
        expect(result, equals(true));
      },
    );

    test(
      'should throw a [CacheException] if caching fails',
      () async {
        final error = CacheException.defaultError;
        // arrange
        when(() => mockSharedPreferences.setBool(any(), any()))
            .thenThrow(error);
        // act
        final call = dataSource.cacheIsFreshInstall;
        // assert
        expect(call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );

    test(
      'should throw a [CacheException] if caching returns false',
      () async {
        // arrange
        when(() => mockSharedPreferences.setBool(any(), any()))
            .thenAnswer((invocation) async => false);
        // act
        final call = dataSource.cacheIsFreshInstall;
        // assert
        expect(call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('getCachedIsFreshInstall', () {
    final isFreshInstall = false;
    test(
      'should return the value of [$isFreshInstallConst]',
      () {
        //arrange
        when(() => mockSharedPreferences.getBool(any()))
            .thenReturn(isFreshInstall);
        // act
        final result = dataSource.getCachedIsFreshInstall();
        // assert
        verify(() => mockSharedPreferences.getBool(isFreshInstallConst));
        expect(result, equals(isFreshInstall));
      },
    );

    test(
      'should throw a [CacheException] if getting [$isFreshInstallConst] fails',
      () {
        final error = CacheException.defaultError;
        // arrange
        when(() => mockSharedPreferences.getBool(any())).thenThrow(error);
        // act
        final call = dataSource.getCachedIsFreshInstall;
        // assert
        expect(call, throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });
}
