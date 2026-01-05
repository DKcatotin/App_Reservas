import '../models/appointment.dart';

abstract class AppointmentsDatasource {
  Future<List<Appointment>> getAll();
  Future<void> create(Appointment appointment);
}

