import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tSightingModelJson = {
    'id': '59d039a0686f743ec5020000',
    'species': 'harbor porpoise',
    'quantity': '20',
    'description': 'From the Inn at Langley looking east there was a very '
        'large group of porpoise swimming south in the Saratoga passage',
    'url': 'http://hotline.whalemuseum.org/sightings/59d039a0686f743ec5020000',
    'latitude': 48.047447813103005,
    'longitude': -122.40477597314452,
    'location': 'Camano Island, WA, US',
    'sighted_at': '2017-10-01T00:38:00.000Z',
    'created_at': '2017-10-01T00:41:04.000Z',
    'updated_at': '2017-10-03T22:01:43.000Z',
  };

  final tSighting = Sighting(
    id: '59d039a0686f743ec5020000',
    species: Species.harborPorpoise,
    quantity: 20,
    description: 'From the Inn at Langley looking east there was a very '
        'large group of porpoise swimming south in the Saratoga passage',
    url: 'http://hotline.whalemuseum.org/sightings/59d039a0686f743ec5020000',
    latitude: 48.047447813103005,
    longitude: -122.40477597314452,
    location: 'Camano Island, WA, US',
    sightedAt: DateTime.tryParse('2017-10-01T00:38:00Z'),
    createdAt: DateTime.tryParse('2017-10-01T00:41:04Z'),
    updatedAt: DateTime.tryParse('2017-10-03T22:01:43Z'),
  );

  final tSightings = sightingsFromJson(fixture('sightings.json'));

  test(
    'should be of type Sighting',
    () async {
      // assert
      expect(tSighting, isA<Sighting>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON is parsable',
      () async {
        // arrange
        final jsonString = fixture('sighting.json');
        // act
        final result = sightingFromJson(jsonString);
        // assert
        expect(result, tSighting);
      },
    );
  });

  group('fromJsonList', () {
    test(
      'should return a valid model when the JSON is parsable',
      () async {
        // arrange
        final jsonString = fixture('sightings.json');
        // act
        final result = sightingsFromJson(jsonString);
        // assert
        expect(result, tSightings);
      },
    );

    test(
      'should return an empty list if json is null or empty',
      () async {
        // arrange
        final jsonString = null;
        // act
        final result = sightingsFromJson(jsonString);
        // assert
        expect(result, []);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tSighting.toJson();
        // assert
        expect(result, tSightingModelJson);
      },
    );
  });

  group('Species', () {
    test(
      'should return a Species.none if not found',
      () async {
        final speciesStr = 'test';
        // act
        final result = Species(speciesStr);
        // assert
        expect(result, Species.none);
      },
    );
  });
}
