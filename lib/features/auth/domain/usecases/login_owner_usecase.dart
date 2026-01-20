import 'package:dartz/dartz.dart';
import '../entities/owner.dart';
import '../repositories/owner_auth_repository.dart';
import '../../../../core/errors/failures.dart';

class LoginOwnerUseCase {
  final OwnerAuthRepository repository;

  LoginOwnerUseCase(this.repository);

  Future<Either<Failure, Owner>> call({
    required String email,
    required String password,
  }) async {
    return await repository.loginOwner(email: email, password: password);
  }
}
