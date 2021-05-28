// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show hashValues;

import 'package:meta/meta.dart';

/// A pair of latitude and longitude coordinates, stored as degrees.
class CustomLatLng {
  /// Creates a geographical location specified in degrees [latitude] and
  /// [longitude].
  ///
  /// The latitude is clamped to the inclusive interval from -90.0 to +90.0.
  ///
  /// The longitude is normalized to the half-open interval from -180.0
  /// (inclusive) to +180.0 (exclusive)
  const CustomLatLng(double latitude, double longitude)
      : latitude =
            (latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude)),
        longitude = (longitude + 180.0) % 360.0 - 180.0;

  /// The latitude in degrees between -90.0 and 90.0, both inclusive.
  final double latitude;

  /// The longitude in degrees between -180.0 (inclusive) and 180.0 (exclusive).
  final double longitude;

  /// Converts this object to something serializable in JSON.
  Object toJson() {
    return <double>[latitude, longitude];
  }

  /// Initialize a CustomLatLng from an \[lat, lng\] array.
  static CustomLatLng? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is List && json.length == 2);
    final list = json as List;
    return CustomLatLng(list[0], list[1]);
  }

  @override
  String toString() => '$runtimeType($latitude, $longitude)';

  @override
  bool operator ==(Object other) {
    return other is CustomLatLng &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => hashValues(latitude, longitude);
}

/// A latitude/longitude aligned rectangle.
///
/// The rectangle conceptually includes all points (lat, lng) where
/// * lat ∈ [`southwest.latitude`, `northeast.latitude`]
/// * lng ∈ [`southwest.longitude`, `northeast.longitude`],
///   if `southwest.longitude` ≤ `northeast.longitude`,
/// * lng ∈ [-180, `northeast.longitude`] ∪ [`southwest.longitude`, 180],
///   if `northeast.longitude` < `southwest.longitude`
class CustomLatLngBounds {
  /// Creates geographical bounding box with the specified corners.
  ///
  /// The latitude of the southwest corner cannot be larger than the
  /// latitude of the northeast corner.
  CustomLatLngBounds({required this.southwest, required this.northeast})
      : assert(southwest.latitude <= northeast.latitude);

  /// The southwest corner of the rectangle.
  final CustomLatLng southwest;

  /// The northeast corner of the rectangle.
  final CustomLatLng northeast;

  /// Converts this object to something serializable in JSON.
  Object toJson() {
    return <Object>[southwest.toJson(), northeast.toJson()];
  }

  /// Returns whether this rectangle contains the given [CustomLatLng].
  bool contains(CustomLatLng point) {
    return _containsLatitude(point.latitude) &&
        _containsLongitude(point.longitude);
  }

  bool _containsLatitude(double lat) {
    return (southwest.latitude <= lat) && (lat <= northeast.latitude);
  }

  bool _containsLongitude(double lng) {
    if (southwest.longitude <= northeast.longitude) {
      return southwest.longitude <= lng && lng <= northeast.longitude;
    } else {
      return southwest.longitude <= lng || lng <= northeast.longitude;
    }
  }

  /// Converts a list to [CustomLatLngBounds].
  @visibleForTesting
  static CustomLatLngBounds? fromList(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is List && json.length == 2);
    final list = json as List;
    return CustomLatLngBounds(
      southwest: CustomLatLng.fromJson(list[0])!,
      northeast: CustomLatLng.fromJson(list[1])!,
    );
  }

  @override
  String toString() {
    return '$runtimeType($southwest, $northeast)';
  }

  @override
  bool operator ==(Object other) {
    return other is CustomLatLngBounds &&
        other.southwest == southwest &&
        other.northeast == northeast;
  }

  @override
  int get hashCode => hashValues(southwest, northeast);
}
