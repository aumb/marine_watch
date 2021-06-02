import 'package:dartz/dartz.dart';
import 'package:marine_watch/features/app/domain/repositories/app_repository.dart';
import 'package:marine_watch/core/errors/failure.dart';
import 'package:marine_watch/core/usecases.dart';

class GetCachedIsFreshInstall implements UseCase<bool, NoParams> {
  GetCachedIsFreshInstall({
    required this.repository,
  });

  final AppRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.getCachedIsFreshInstall();
  }
}
