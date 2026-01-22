import 'package:agenda_app/core/errors/failures.dart';
import 'package:agenda_app/features/auth/domain/entities/owner.dart';
import 'package:agenda_app/features/auth/domain/repositories/owner_auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentOwnerUseCase {
  final OwnerAuthRepository repository;

  GetCurrentOwnerUseCase(this.repository);

  Future<Either<Failure, Owner>> call() async {
    return await repository.getCurrentOwner();
  }
}