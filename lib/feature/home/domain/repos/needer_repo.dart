import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:dartz/dartz.dart';

abstract class NeederRepo {
  Future<Either<Failures, void>> addNeederRequest(
      NeederRequestEntity addNeederInputEntity);
}
