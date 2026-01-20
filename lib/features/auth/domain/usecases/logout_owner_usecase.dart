import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/owner_auth_repository.dart';

class LogoutOwnerUseCase {
  final OwnerAuthRepository repository;

  LogoutOwnerUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logoutOwner();
  }
}
