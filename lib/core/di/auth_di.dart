import 'package:dio/dio.dart';

// ==================== CORE ====================
import '../networking/dio_client.dart';
import '../storage/token_storage.dart';

// ==================== AUTH ====================
import '../../features/auth/data/sources/auth/auth_api.dart';
import '../../features/auth/data/repositories/auth/auth_repository.dart';

// ==================== CATALOGUES ====================
import 'package:agenda_app/features/owner/catalogues/data/datasources/catalogues_datasource.dart';
import 'package:agenda_app/features/owner/catalogues/data/datasources/catalogues_local_datasource.dart';
// import 'package:agenda_app/features/owner/catalogues/data/datasources/catalogues_remote_datasource.dart'; // backend
import 'package:agenda_app/features/owner/catalogues/data/repositories/catalogues_repository_impl.dart';
import 'package:agenda_app/features/owner/catalogues/domain/repositories/catalogues_repository.dart';

// ==================== APPOINTMENTS ====================
import '../../features/owner/appointments/data/repositories/appointments_repository.dart';
import '../../features/owner/appointments/data/sources/appointments_json_datasource.dart';
import '../../features/owner/appointments/data/sources/appointments_memory_datasource.dart';
import '../../features/owner/appointments/data/sources/appointments_hybrid_datasource.dart';

class AppDependencies {
  static final AppDependencies _instance = AppDependencies._();
  factory AppDependencies() => _instance;

  // ==================== CORE ====================
  late final TokenStorage tokenStorage;
  late final Dio dio;

  // ==================== AUTH ====================
  late final AuthRepository authRepository;

  // ==================== CATALOGUES ====================
  // Datasource (privado)
  late final CataloguesDatasource _cataloguesDatasource;

  // Repository (público)
  late final CataloguesRepository cataloguesRepository;

  // ==================== APPOINTMENTS ====================
  late final AppointmentsRepository appointmentsRepository;

  AppDependencies._() {
    _initCore();
    _initAuth();
    _initCatalogues();
    _initAppointments();
  }

  // ==================== CORE INIT ====================
  void _initCore() {
    tokenStorage = TokenStorage();
    dio = DioClient.create(tokenStorage);
  }

  // ==================== AUTH INIT ====================
  void _initAuth() {
    final authApi = AuthApi(dio);

    authRepository = AuthRepository(
      api: authApi,
      tokenStorage: tokenStorage,
    );
  }

  // ==================== CATALOGUES INIT ====================
  void _initCatalogues() {
    // TODO(backend): cambiar a CataloguesRemoteDatasource(dio)
    _cataloguesDatasource = CataloguesLocalDatasource();

    cataloguesRepository = CataloguesRepositoryImpl(
      datasource: _cataloguesDatasource,
    );
  }

  // ==================== APPOINTMENTS INIT ====================
  void _initAppointments() {
    final appointmentsDatasource = AppointmentsHybridDatasource(
      json: AppointmentsJsonDatasource(),
      memory: AppointmentsMemoryDatasource(),
    );

    appointmentsRepository = AppointmentsRepository(
      datasource: appointmentsDatasource,
    );
  }
}
