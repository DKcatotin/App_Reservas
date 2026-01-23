import '../models/owner_model.dart';

abstract class OwnerAuthRemoteDataSource {
  /// Login del propietario/admin
  /// Retorna [OwnerModel] si es exitoso
  /// Lanza [ServerException] si hay error del servidor
  /// Lanza [AuthException] si las credenciales son inválidas
  Future<OwnerModel> loginOwner({
    required String email,
    required String password,
  });

  /// Cierra sesión del propietario
  Future<void> logoutOwner();

  /// Obtiene el propietario actual desde caché/storage
  /// Lanza [CacheException] si no hay sesión activa
  Future<OwnerModel> getCurrentOwner();
}
