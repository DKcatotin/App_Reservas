import 'package:agenda_app/features/owner/appointments/data/models/appointment_service.dart';
import 'package:agenda_app/features/owner/appointments/data/models/customer.dart';
import 'package:agenda_app/features/owner/appointments/data/models/source.dart';
import 'package:agenda_app/features/owner/appointments/data/models/staff.dart';
import 'package:agenda_app/features/owner/appointments/data/models/status.dart';
import 'package:agenda_app/features/owner/appointments/domain/create_appointement_input.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';

import '../models/appointment.dart';
import '../sources/appointments_datasource.dart';
import '../../domain/date_utils.dart';

class AppointmentsRepository {
  final AppointmentsDatasource datasource;

  AppointmentsRepository({required this.datasource});


  Future<void> createFromInput(CreateAppointmentInput input) async {
    //normalizar notas 
    final notes = input.notes?.trim();
    final cleanNotes = (notes == null || notes.isEmpty) ? null : notes;
    final customer = Customer(
        id: _makeTempId('customer'), 
        name: input.customerName.trim(),
        phone: input.customerPhone.trim(),
        );
        // TODO(backend): Buscar/crear customer por phone en API y usar customer.id real.
        // TODO(backend): Crear appointment en API y usar appointment.id real retornado.
        final totalMinutes = input.services.fold(0, (sum, s) => sum + s.durationMinutes);

        final appointment = Appointment(
          id: _makeTempId('appointment'),
          ownerId: 'owner1',
          branchId: 'branch1',
          customerId: customer.id,
          staffId: 's1',
          startAt: input.startAt,
          endAt: input.startAt.add(Duration(minutes: totalMinutes)),
          notes: cleanNotes,
          status: Status(code:'pending', label: 'Pendiente'),
          source: Source(type: input.source),
          customer: customer,
          staff: Staff(id: 's1', name: 'Staff demo'),
          services: input.services.map((Service s){
            return AppointmentService(id: s.id,
             name: s.name, 
             durationMinutes: s.durationMinutes
             );
          }).toList(),
        );
        await datasource.create(appointment);
  }
  String _makeTempId(String prefix) => '$prefix-${DateTime.now().microsecondsSinceEpoch}';

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
Future<void> update(Appointment appointment) => datasource.update(appointment);

Future<void> delete(String id) => datasource.delete(id);


}
