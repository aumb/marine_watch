import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';

List<Sighting?> sightingsFromJson(String str) =>
    Sighting.fromJsonList(json.decode(str));

List<Sighting?> sightingsFromStringList(List<String> str) =>
    Sighting.fromStringList(str);

Sighting sightingFromJson(String str) => Sighting.fromJson(json.decode(str));

String sightingToJson(Sighting? data) => json.encode(data?.toJson());

List<String> sightingsToJsonList(List<Sighting?> data) =>
    Sighting.toJsonList(data);

class Sighting extends Equatable {
  Sighting({
    required this.id,
    required this.species,
    required this.quantity,
    required this.description,
    required this.url,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.sightedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sighting.fromJson(Map<String, dynamic>? json) => Sighting(
        id: json?['id'],
        species: Species(json?['species']),
        quantity:
            json?['quantity'] == null ? 0 : num.tryParse(json?['quantity']),
        description: json?['description'],
        url: json?['url'],
        latitude: json?['latitude'].toDouble(),
        longitude: json?['longitude'].toDouble(),
        location: json?['location'],
        sightedAt: DateTime.parse(json?['sighted_at']),
        createdAt: DateTime.parse(json?['created_at']),
        updatedAt: DateTime.parse(json?['updated_at']),
      );

  final String? id;
  final Species? species;
  final num? quantity;
  final String? description;
  final String? url;
  final num? latitude;
  final num? longitude;
  final String? location;
  final DateTime? sightedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static List<Sighting?> fromJsonList(List? json) {
    if (json != null && json.isNotEmpty) {
      List<Sighting?> sightings =
          json.map((sighting) => Sighting.fromJson(sighting)).toList();
      return sightings;
    } else {
      return [];
    }
  }

  static List<Sighting?> fromStringList(List<String> list) {
    final sightings = <Sighting?>[];

    for (var item in list) {
      sightings.add(sightingFromJson(item));
    }

    return sightings;
  }

  static List<String> toJsonList(List<Sighting?> list) {
    final sightings = <String>[];

    for (var item in list) {
      sightings.add(sightingToJson(item));
    }

    return sightings;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'species': species?.value,
        'quantity': quantity?.toString(),
        'description': description,
        'url': url,
        'latitude': latitude,
        'longitude': longitude,
        'location': location,
        'sighted_at': sightedAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  static Sighting defaultSighting = Sighting(
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

  @override
  List<Object?> get props => [
        id,
        species,
        quantity,
        description,
        url,
        latitude,
        longitude,
        location,
        sightedAt,
        createdAt,
        updatedAt,
      ];
}
