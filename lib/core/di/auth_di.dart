import 'package:dio/dio.dart';
import '../config/env.dart';
import '../storage/token_storage.dart';

// ==================== AUTH (Clean Architecture) ====================
import '../../features/auth/data/sources/owner_auth_remote_datasource.dart';
import '../../features/auth/data/sources/owner_auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/owner_auth_repository_impl.dart';
import '../../features/auth/domain/repositories/owner_auth_repository.dart';
import '../../features/auth/domain/usecases/login_owner_usecase.dart';
import '../../features/auth/domain/usecases/logout_owner_usecase.dart';
import '../../features/auth/domain/usecases/get_current_owner_usecase.dart'; // ← IMPORTAR

/// Dependencias del módulo de autenticación (Clean Architecture)
class AuthDependencies {
  late final OwnerAuthRepository ownerAuthRepository;
  late final LoginOwnerUseCase loginOwnerUseCase;
  late final LogoutOwnerUseCase logoutOwnerUseCase;
  late final GetCurrentOwnerUseCase getCurrentOwnerUseCase; // ← AGREGAR

  void init({
    required Dio dio,
    required TokenStorage tokenStorage,
  }) {
    final OwnerAuthRemoteDataSource remoteDataSource =
        OwnerAuthRemoteDataSourceImpl(
          client: dio,
          storage: tokenStorage,
          baseUrl: Env.baseUrl,
        );

    ownerAuthRepository = OwnerAuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    loginOwnerUseCase = LoginOwnerUseCase(ownerAuthRepository);
    logoutOwnerUseCase = LogoutOwnerUseCase(ownerAuthRepository);
    getCurrentOwnerUseCase = GetCurrentOwnerUseCase(ownerAuthRepository); // ← INICIALIZAR
  }

  // Alias para mantener compatibilidad temporal con app_router.dart
  OwnerAuthRepository get authRepository => ownerAuthRepository;
}