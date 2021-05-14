import 'package:dartz/dartz.dart';
import 'package:marine_watch/app/domain/repositories/app_repository.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:marine_watch/utils/usecases.dart';

class CacheIsFreshInstall implements UseCase<bool, NoParams> {
  CacheIsFreshInstall({
    required this.repository,
  });

  final AppRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.cacheIsFreshInstall();
  }
}
