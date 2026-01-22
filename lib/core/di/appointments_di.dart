import '../../features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import '../../features/owner/appointments/data/sources/appointments/appointments_json_datasource.dart';
import '../../features/owner/appointments/data/sources/appointments/appointments_memory_datasource.dart';
import '../../features/owner/appointments/data/sources/appointments/appointments_hybrid_datasource.dart';

/// Dependencias del módulo de citas
class AppointmentsDependencies {
  late final AppointmentsRepositoryImpl appointmentsRepository;

  void init() {
    final appointmentsDatasource = AppointmentsHybridDatasource(
      json: AppointmentsJsonDatasource(),
      memory: AppointmentsMemoryDatasource(),
    );

    appointmentsRepository = AppointmentsRepositoryImpl(
      datasource: appointmentsDatasource,
    );
  }
}
