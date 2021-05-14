import 'package:marine_watch/utils/const_utils.dart';
import 'package:marine_watch/utils/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppLocalDataSource {
  bool getCachedIsFreshInstall();

  Future<bool> cacheIsFreshInstall();
}

class AppLocalDataSourceImpl implements AppLocalDataSource {
  AppLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  @override
  Future<bool> cacheIsFreshInstall() async {
    try {
      final result =
          await sharedPreferences.setBool(isFreshInstallConst, false);
      if (result) {
        return result;
      } else {
        throw CacheException.defaultError;
      }
    } catch (e) {
      throw CacheException.handleException(error: e);
    }
  }

  @override
  bool getCachedIsFreshInstall() {
    try {
      final result = sharedPreferences.getBool(isFreshInstallConst);
      return result ?? true;
    } catch (e) {
      throw CacheException.handleException(error: e);
    }
  }
}
