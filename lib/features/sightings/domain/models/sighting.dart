import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';

List<Sighting?> sightingsFromJson(String str) =>
    Sighting.fromJsonList(json.decode(str));

Sighting sightingFromJson(String str) => Sighting.fromJson(json.decode(str));

String sightingToJson(Sighting data) => json.encode(data.toJson());

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
      List<Sighting?> images =
          json.map((image) => Sighting.fromJson(image)).toList();
      return images;
    } else {
      return [];
    }
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
