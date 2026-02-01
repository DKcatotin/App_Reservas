import 'package:agenda_app/core/di/customers_di.dart';
import 'package:agenda_app/features/auth/domain/usecases/get_current_owner_usecase.dart';
import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'appointments_di.dart';
import 'auth_di.dart';
import 'catalogues_di.dart';
import 'core_di.dart';

/// Contenedor principal de todas las dependencias de la app.
///
/// REGLA DEL PROYECTO:
/// - Dio y TokenStorage se crean SOLO una vez en main().
/// - AppDependencies se "bootstrappea" con esas instancias y luego se reutiliza.
///
/// Esto evita duplicación (frankenstein) y mantiene el comportamiento existente.
class AppDependencies {
  static final AppDependencies _instance = AppDependencies._();
  factory AppDependencies() => _instance;

  // Flag para asegurar inicialización única
  bool _bootstrapped = false;

  late final CustomersDependencies customers;
  late final GetCurrentOwnerUseCase getCurrentOwnerUseCase;
  late final CoreDependencies core;
  late final AuthDependencies auth;
  late final CataloguesDependencies catalogues;
  late final AppointmentsDependencies appointments;

  AppDependencies._();

  /// Debe llamarse UNA vez en main() antes de usar AppDependencies() en la app.
  /// Si se llama dos veces, no hace nada (idempotente).
  void bootstrap({
    required Dio dio,
    required TokenStorage tokenStorage,
  }) {
    if (_bootstrapped) return;
    _bootstrapped = true;

    _initAll(dio: dio, tokenStorage: tokenStorage);
  }

  void _initAll({
    required Dio dio,
    required TokenStorage tokenStorage,
  }) {
    // Core
    core = CoreDependencies();
    core.init(
      dio: dio,
      tokenStorage: tokenStorage,
    );

    // Auth
    auth = AuthDependencies();
    auth.init(
      dio: core.dio,
      tokenStorage: core.tokenStorage,
    );

    getCurrentOwnerUseCase = auth.getCurrentOwnerUseCase;

    // Catalogues
    catalogues = CataloguesDependencies();
    catalogues.init(dio: core.dio);

    // Appointments
    appointments = AppointmentsDependencies();
    appointments.init(core.dio);

    // Customers
    customers = CustomersDependencies();
    customers.init(
      dio: core.dio,
      useRemote: true,
    );
  }

  // Getters de conveniencia
  Dio get dio {
    _assertBootstrapped();
    return core.dio;
  }

  TokenStorage get tokenStorage {
    _assertBootstrapped();
    return core.tokenStorage;
  }

  // Auth
  get loginOwnerUseCase {
    _assertBootstrapped();
    return auth.loginOwnerUseCase;
  }

  get logoutOwnerUseCase {
    _assertBootstrapped();
    return auth.logoutOwnerUseCase;
  }

  get ownerAuthRepository {
    _assertBootstrapped();
    return auth.ownerAuthRepository;
  }

  // Catalogues
  get cataloguesRepository {
    _assertBootstrapped();
    return catalogues.cataloguesRepository;
  }

  // Appointments
  get appointmentsRepository {
    _assertBootstrapped();
    return appointments.appointmentsRepository;
  }

  get createAppointmentUseCase {
    _assertBootstrapped();
    return appointments.createAppointmentUseCase;
  }

  // Customers
  get customersDatasource {
    _assertBootstrapped();
    return customers.customersDatasource;
  }

  void _assertBootstrapped() {
    assert(
      _bootstrapped,
      'AppDependencies no fue inicializado. Llama AppDependencies().bootstrap(...) en main() antes de usarlo.',
    );
  }
}
