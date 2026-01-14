// Contrato entre la app y los datos
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';

abstract class AppointmentsRepository {
  Future<List<AppointmentEntity>> getAll();
  Future<List<AppointmentEntity>> getByDay(DateTime day);
  Future<void> create(AppointmentEntity appointment);
  Future<void> update(AppointmentEntity appointment);
  Future<void> delete(String id);
}