import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/core/services/data_service.dart';
import 'package:blood_bank/core/utils/backend_endpoint.dart';
import 'package:blood_bank/feature/home/data/model/doner_model.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/doner_repo.dart';
import 'package:dartz/dartz.dart';

class DonerRepoImpl implements DonerRepo {
  final DatabaseService databaseService;

  DonerRepoImpl(this.databaseService);
  @override
  Future<Either<Failures, void>> addRequest(
      DonerRequestEntity addRequestInputEntity) async {
    try {
      await databaseService.addData(
          path: BackendEndpoint.donerRequest,
          data: DonerModel.fromEntity(
            addRequestInputEntity,
          ).toJson());
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure('Failed to add Request'),
      );
    }
  }
}
