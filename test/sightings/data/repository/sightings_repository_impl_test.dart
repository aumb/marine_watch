import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/sightings/data/datasources/sightings_remote_data_source.dart';
import 'package:marine_watch/features/sightings/data/repositories/sightings_repository_impl.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements SightingsRemoteDataSource {}

void main() {
  late SightingsRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  final sightings = sightingsFromJson(fixture('sightings.json'));

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = SightingsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('getSightings', () {
    test(
      'should return data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getSightings())
            .thenAnswer((_) async => sightings);
        // act
        final result = await repository.getSightings();
        // assert
        verify(() => mockRemoteDataSource.getSightings()).called(1);

        expect(result, equals(Right(sightings)));
      },
    );
  });

  group('getMoreSightings', () {
    test(
      'should return data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMoreSightings())
            .thenAnswer((_) async => sightings);
        // act
        final result = await repository.getMoreSightings();
        // assert
        verify(() => mockRemoteDataSource.getMoreSightings()).called(1);

        expect(result, equals(Right(sightings)));
      },
    );
  });
}
