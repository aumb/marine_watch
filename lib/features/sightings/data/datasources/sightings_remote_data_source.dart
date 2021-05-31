import 'package:dio/dio.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/utils/api.dart';
import 'package:marine_watch/utils/custom_lat_lng.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';

abstract class SightingsRemoteDataSource {
  Future<List<Sighting?>?> getSightings({
    Species? species,
    int? limit,
    int? page,
    DateTime? since,
    DateTime? until,
    CustomLatLng? near,
    int? radius,
  });
}

class SightingsRemoteDataSourceImpl implements SightingsRemoteDataSource {
  SightingsRemoteDataSourceImpl({
    required this.dio,
  });

  final Dio dio;

  @override
  Future<List<Sighting?>?> getSightings({
    Species? species,
    int? limit,
    int? page,
    DateTime? since,
    DateTime? until,
    CustomLatLng? near,
    int? radius,
  }) async {
    try {
      final Response? response = await dio.get(API.sightings, queryParameters: {
        if (species != null) 'species': species.value,
        if (limit != null) 'limit': limit,
        if (page != null) 'page': page,
        if (since != null) 'since': since.toIso8601String(),
        if (until != null) 'until': until.toIso8601String(),
        if (near != null)
          'near': '${near.latitude.toString()},${near.longitude.toString()}',
        'radius': radius ?? 0.5
      });
      if (response?.statusCode == 200) {
        final sightings = Sighting.fromJsonList(response?.data);
        return sightings;
      }
    } catch (e) {
      throw ServerException.handleException(error: e);
    }
  }
}
