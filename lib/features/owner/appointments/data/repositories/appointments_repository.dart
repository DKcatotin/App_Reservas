import '../models/appointment.dart';
import '../sources/appointments_datasource.dart';

class AppointmentsRepository {
  final AppointmentsDatasource datasource;

  AppointmentsRepository({required this.datasource});

  Future<List<Appointment>> getToday() {
    return datasource.getToday();
  }

  Future<List<Appointment>> getPast() {
    return datasource.getPast();
  }

  Future<List<Appointment>> getUpcoming() {
    return datasource.getUpcoming();
  }

  /// Crear nueva cita
  Future<void> create(Appointment appointment) {
    return datasource.create(appointment);
  }
}
