import 'package:dartz/dartz.dart';
import 'package:marine_watch/features/app/domain/repositories/app_repository.dart';
import 'package:marine_watch/core/errors/failure.dart';
import 'package:marine_watch/core/usecases.dart';

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
