import '../models/appointment.dart';

abstract class AppointmentsDatasource {
  Future<List<Appointment>> getToday();
  Future<List<Appointment>> getPast();
  Future<List<Appointment>> getUpcoming();

  Future<void> create(Appointment appointment);
}
