import '../models/appointment.dart';
import '../sources/appointments_datasource.dart';

class AppointmentsRepository {
  final AppointmentsDatasource datasource;

  AppointmentsRepository({required this.datasource});

  Future<List<Appointment>> getToday() => datasource.getToday();

  Future<List<Appointment>> getPast() => datasource.getPast();

  Future<List<Appointment>> getUpcoming() => datasource.getUpcoming();
}
