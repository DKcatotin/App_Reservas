import 'package:agenda_app/core/di/customers_di.dart';
import 'package:agenda_app/features/auth/domain/usecases/get_current_owner_usecase.dart';

import 'core_di.dart';
import 'auth_di.dart';
import 'catalogues_di.dart';
import 'appointments_di.dart';

/// Contenedor principal de todas las dependencias de la app
class AppDependencies {
  static final AppDependencies _instance = AppDependencies._();
  factory AppDependencies() => _instance;

  late final CustomersDependencies customers;
  late final GetCurrentOwnerUseCase getCurrentOwnerUseCase;
  late final CoreDependencies core;
  late final AuthDependencies auth;
  late final CataloguesDependencies catalogues;
  late final AppointmentsDependencies appointments;

  AppDependencies._() {
    _initAll();
  }

  void _initAll() {
    core = CoreDependencies();
    core.init();

    auth = AuthDependencies();
    auth.init(
      dio: core.dio,
      tokenStorage: core.tokenStorage,
    );

    getCurrentOwnerUseCase = auth.getCurrentOwnerUseCase;

    catalogues = CataloguesDependencies();
    catalogues.init(dio: core.dio);

    appointments = AppointmentsDependencies();
    appointments.init(core.dio);

    customers = CustomersDependencies();
    customers.init(
      dio: core.dio,
      useRemote: true,
    );
  }

  // Getters de conveniencia
  get dio => core.dio;
  get tokenStorage => core.tokenStorage;

  // Auth
  get loginOwnerUseCase => auth.loginOwnerUseCase;
  get logoutOwnerUseCase => auth.logoutOwnerUseCase;
  get ownerAuthRepository => auth.ownerAuthRepository;

  // Catalogues
  get cataloguesRepository => catalogues.cataloguesRepository;

  // Appointments
  get appointmentsRepository => appointments.appointmentsRepository;
  get createAppointmentUseCase =>
      appointments.createAppointmentUseCase;

  // Customers
  get customersDatasource => customers.customersDatasource;
}
