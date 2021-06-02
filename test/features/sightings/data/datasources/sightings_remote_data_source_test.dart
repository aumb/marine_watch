import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/sightings/data/datasources/sightings_remote_data_source.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/core/api.dart';
import 'package:marine_watch/core/errors/exceptions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements HttpClientAdapter {}

void main() {
  late SightingsRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  final dio = Dio();

  setUp(() {
    registerFallbackValue<RequestOptions>(RequestOptions(path: API.sightings));
    mockHttpClient = MockHttpClient();
    dataSource = SightingsRemoteDataSourceImpl(
      dio: dio,
    );

    dio.httpClientAdapter = mockHttpClient;
  });

  void setUpMockHttpClientSuccess() async {
    final responsepayload = fixture('sightings.json');

    final httpResponse =
        ResponseBody.fromString(responsepayload, 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });

    when(() => mockHttpClient.fetch(any(), any(), any()))
        .thenAnswer((_) async => httpResponse);
  }

  void setUpMockHttpClientFailure() {
    final responsepayload = jsonEncode({
      'error': 'Something went wrong',
      'code': 500,
    });

    final httpResponse =
        ResponseBody.fromString(responsepayload, 404, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
    when(() => mockHttpClient.fetch(any(), any(), any()))
        .thenAnswer((_) async => httpResponse);
  }

  group('getSightings', () {
    final tSightings = sightingsFromJson(fixture('sightings.json'));

    test(
      'should return a list of sighitngs when the response code is 200',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getSightings();
        // assert
        expect(result, equals(tSightings));
      },
    );

    test(
      'should throw a ServerException when the response code is an error code',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getSightings;
        // assert
        expect(call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
