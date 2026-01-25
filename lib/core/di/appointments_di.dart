import 'package:dio/dio.dart';
import '../../features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import '../../features/owner/appointments/data/sources/appointments/appointments_remote_datasource.dart';
import '../../features/owner/appointments/data/sources/appointments/appointment_services_remote_datasource.dart';  // ✅ AGREGAR
import '../../features/owner/appointments/domain/use_cases/create_appointment.dart';

class AppointmentsDependencies {
  late final AppointmentsRepositoryImpl appointmentsRepository;
  late final CreateAppointmentUseCase createAppointmentUseCase;

  void init(Dio dio) {
    // Datasources
    final appointmentsDatasource = AppointmentsRemoteDatasource(dio: dio);
    final appointmentServicesDataSource = AppointmentServicesRemoteDatasource(dio: dio);  // ✅ AGREGAR

    // Repository
    appointmentsRepository = AppointmentsRepositoryImpl(
      remoteDatasource: appointmentsDatasource,
      servicesDataSource: appointmentServicesDataSource,  // ✅ AGREGAR
    );

    // Use cases
    createAppointmentUseCase = CreateAppointmentUseCase(
      appointmentsRepository,
    );
  }
}
