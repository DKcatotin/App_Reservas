import 'package:dartz/dartz.dart';
import '../entities/owner.dart';
import '../../../../core/errors/failures.dart';

abstract class OwnerAuthRepository {
  /// Autentica al propietario con email y contraseña.
  Future<Either<Failure, Owner>> loginOwner({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, void>> logoutOwner();
  
  Future<Either<Failure, Owner>> getCurrentOwner();
  
}
