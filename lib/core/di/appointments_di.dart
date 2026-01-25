import 'package:dio/dio.dart';
import '../../features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import '../../features/owner/appointments/data/sources/appointments/appointments_remote_datasource.dart';
import '../../features/owner/appointments/domain/use_cases/create_appointment.dart';

class AppointmentsDependencies {
  late final AppointmentsRepositoryImpl appointmentsRepository;
  late final CreateAppointmentUseCase createAppointmentUseCase;

  void init(Dio dio) {
    // Usar el datasource remoto
    final appointmentsDatasource = AppointmentsRemoteDatasource(dio: dio);

    appointmentsRepository = AppointmentsRepositoryImpl(
      remoteDatasource: appointmentsDatasource,
    );

    createAppointmentUseCase = CreateAppointmentUseCase(
      appointmentsRepository,
    );
  }
}
