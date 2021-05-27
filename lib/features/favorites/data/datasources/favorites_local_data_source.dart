import 'dart:convert';

import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/utils/const_utils.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FavoritesLocalDataSource {
  List<Sighting?> getCachedSightings();
  Future<List<Sighting?>?> cacheSighting(Sighting? sighting);
  Future<List<Sighting?>?> deleteCachedSighting(Sighting? sighting);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  ///Gets existing cached sighings, returns an empty list if the key does not
  ///exist.
  List<String> get cachedSightings =>
      sharedPreferences.getStringList(favoriteSightingsConst) ?? [];

  ///Caches the sightings provided.
  Future<bool> setCachedSightings(List<String> sightings) async =>
      await sharedPreferences.setStringList(
        favoriteSightingsConst,
        sightings,
      );

  @override
  Future<List<Sighting?>?> cacheSighting(Sighting? sighting) async {
    try {
      final cachedSightings = [...this.cachedSightings];
      if (sighting != null) {
        cachedSightings.add(jsonEncode(sighting.toJson()));
      }

      //Cache the new list
      final result = await setCachedSightings(cachedSightings);

      //If caching is successfull return the full cached list.
      //If caching fails return a [CacheException]
      if (result) {
        final sightings = sightingsFromStringList(cachedSightings);
        return sightings;
      } else {
        throw CacheException.defaultError;
      }
    } catch (e) {
      throw CacheException.handleException(error: e);
    }
  }

  @override
  Future<List<Sighting?>?> deleteCachedSighting(Sighting? sighting) async {
    try {
      final cachedSightings = [...this.cachedSightings];
      var parsedSightings = sightingsFromStringList(cachedSightings);

      ///Find the item to delete.
      final itemToDelete = parsedSightings.firstWhere(
        (element) => element?.id == sighting?.id,
        orElse: () => null,
      );

      if (itemToDelete != null) {
        ///Removes the item
        parsedSightings.remove(itemToDelete);

        //Clears old list and converts the updated list into string to be cached
        cachedSightings
          ..clear()
          ..addAll(sightingsToJsonList(parsedSightings));

        await setCachedSightings(cachedSightings);

        return parsedSightings;
      } else {
        throw CacheException.defaultError;
      }
    } catch (e) {
      throw CacheException.handleException(error: e);
    }
  }

  @override
  List<Sighting?> getCachedSightings() {
    try {
      final cachedSightings = [...this.cachedSightings];
      final parsedSightings = sightingsFromStringList(cachedSightings);
      return parsedSightings;
    } catch (e) {
      throw CacheException.handleException(error: e);
    }
  }
}
