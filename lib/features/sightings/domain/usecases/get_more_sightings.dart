import 'package:dartz/dartz.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/repositories/sightings_repository.dart';
import 'package:marine_watch/features/sightings/domain/usecases/get_sightings.dart';
import 'package:marine_watch/utils/errors/failure.dart';
import 'package:marine_watch/utils/usecases.dart';

class GetMoreSightings
    implements UseCase<List<Sighting?>?, GetSightingsParams> {
  GetMoreSightings({
    required this.repository,
  });

  final SightingsRepository repository;

  @override
  Future<Either<Failure, List<Sighting?>?>> call(
      GetSightingsParams params) async {
    return await repository.getMoreSightings(
      species: params.species,
      limit: params.limit,
      page: params.page,
      since: params.since,
      until: params.until,
      near: params.near,
      radius: params.radius,
    );
  }
}
