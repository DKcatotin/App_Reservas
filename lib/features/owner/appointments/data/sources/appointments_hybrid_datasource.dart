import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments_datasource.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments_json_datasource.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments_memory_datasource.dart';

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

    final today = await json.getToday();
    final past = await json.getPast();
    final upcoming = await json.getUpcoming();

    for (final a in [...past, ...today, ...upcoming]) {
      await memory.create(a);
    }

    _loaded = true;
  }

  @override
  Future<List<Appointment>> getToday() async {
    await _ensureLoaded();
    return memory.getToday();
  }

  @override
  Future<List<Appointment>> getUpcoming() async {
    await _ensureLoaded();
    return memory.getUpcoming();
  }

  @override
  Future<List<Appointment>> getPast() async {
    await _ensureLoaded();
    return memory.getPast();
  }

  @override
  Future<void> create(Appointment appointment) async {
    await _ensureLoaded();
    return memory.create(appointment);
  }
}
