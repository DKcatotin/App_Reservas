import '../models/appointment.dart';
import '../sources/appointments_datasource.dart';
import '../../domain/date_utils.dart';

class AppointmentsRepository {
  final AppointmentsDatasource datasource;

  AppointmentsRepository({required this.datasource});

  // Nuevo (para calendario)
  Future<List<Appointment>> getAll() {
    return datasource.getAll();
  }

  // Nuevo (UI más "tonta": pide por día y ya)
  Future<List<Appointment>> getByDay(DateTime day) async {
  final all = await getAll();

  final result = all.where((a) {
    return isSameDate(a.startAt, day);
  }).toList();

  result.sort((a, b) => a.startAt.compareTo(b.startAt));
  return result;
}

Future<List<Appointment>> getToday() {
  return getByDay(DateTime.now());
}

  // --- Compatibilidad temporal (se borra al final) ---
  Future<void> create(Appointment appointment) {
    return datasource.create(appointment);
  }
}
