import '../models/appointment.dart';
//Define un contrato para las fuentes de citas
abstract class AppointmentsDatasource {
  Future<List<Appointment>> getAll();
  Future<void> create(Appointment appointment);
   Future<void> update(Appointment appointment);
  Future<void> delete(String id);
}

