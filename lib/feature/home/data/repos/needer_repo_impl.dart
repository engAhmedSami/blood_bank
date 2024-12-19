import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/core/services/data_service.dart';
import 'package:blood_bank/core/utils/backend_endpoint.dart';
import 'package:blood_bank/feature/home/data/model/needer_model.dart';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:dartz/dartz.dart';

class NeederRepoImpl implements NeederRepo {
  final DatabaseService databaseService;

  NeederRepoImpl(this.databaseService);

  @override
  Future<Either<Failures, void>> addNeederRequest(
      NeederRequestEntity addNeederInputEntity) async {
    try {
      await databaseService.addData(
          path: BackendEndpoint.neederRequest,
          data: NeederModel.fromEntity(
            addNeederInputEntity,
          ).toJson());
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure('Failed to add Request'),
      );
    }
  }
}
