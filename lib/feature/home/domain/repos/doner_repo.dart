import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DonerRepo {
  Future<Either<Failures, void>> addRequest(
      DonerRequestEntity addRequestInputEntity);
}
