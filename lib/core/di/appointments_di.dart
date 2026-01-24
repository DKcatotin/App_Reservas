import '../../features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import '../../features/owner/appointments/data/sources/appointments/appointments_json_datasource.dart';
import '../../features/owner/appointments/data/sources/appointments/appointments_memory_datasource.dart';
import '../../features/owner/appointments/data/sources/appointments/appointments_hybrid_datasource.dart';
import '../../features/owner/appointments/domain/use_cases/create_appointment.dart';

/// Dependencias del módulo de citas
class AppointmentsDependencies {
  late final AppointmentsRepositoryImpl appointmentsRepository;
  late final CreateAppointmentUseCase createAppointmentUseCase;

  void init() {
        // Crear el datasource híbrido que combina JSON local + memoria
    final appointmentsDatasource = AppointmentsHybridDatasource(
      json: AppointmentsJsonDatasource(),
      memory: AppointmentsMemoryDatasource(),
    );

    // Inicializar repositorio con datasource híbrido
    appointmentsRepository = AppointmentsRepositoryImpl(
      datasource: appointmentsDatasource,
    );

    // Crear use case
    createAppointmentUseCase = CreateAppointmentUseCase(
      appointmentsRepository,
    );
  }
}
