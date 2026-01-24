import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointments_datasource.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointments_json_datasource.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointments_memory_datasource.dart';

class AppointmentsHybridDatasource implements AppointmentsDatasource {
  final AppointmentsJsonDatasource json;
  final AppointmentsMemoryDatasource memory;

  bool _loaded = false;

  AppointmentsHybridDatasource({
    required this.json,
    required this.memory,
  });

  Future<void> _ensureLoaded() async {
    if (_loaded) return;

    final all = await json.getAll(); //  List<Appointment>

    for (final a in all) {
      await memory.create(a); //  Guardar en memoria
    }

    _loaded = true;
  }

  @override
  Future<List<Appointment>> getAll() async {
    await _ensureLoaded();
    return memory.getAll(); //  devolver desde memoria
  }

  @override
  Future<void> create(Appointment appointment) async {
    await _ensureLoaded();
    return memory.create(appointment);
  }

  @override
  Future<void> update(Appointment appointment) async {
    await _ensureLoaded();
    return memory.update(appointment);
  }

  @override
  Future<void> delete(String id) async {
    await _ensureLoaded();
    return memory.delete(id);
  }
}
