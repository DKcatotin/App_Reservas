import 'package:dartz/dartz.dart';
import '../../domain/entities/owner.dart';
import '../../domain/repositories/owner_auth_repository.dart';
import '../models/owner_model.dart'; // ← AGREGAR IMPORT
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/owner_auth_remote_datasource.dart';

class OwnerAuthRepositoryImpl implements OwnerAuthRepository {
  final OwnerAuthRemoteDataSource remoteDataSource;

  OwnerAuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Owner>> loginOwner({
    required String email,
    required String password,
  }) async {
    try {
      // Delegar al DataSource
      final owner = await remoteDataSource.loginOwner(
        email: email,
        password: password,
      );
      return Right(owner);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logoutOwner() async {
    try {
      await remoteDataSource.logoutOwner();
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure('Error al cerrar sesión: $e'));
    }
  }

  @override
  Future<Either<Failure, Owner>> getCurrentOwner() async {
    try {
      final owner = await remoteDataSource.getCurrentOwner();
      return Right(owner);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Error al obtener usuario actual: $e'));
    }
  }
}
