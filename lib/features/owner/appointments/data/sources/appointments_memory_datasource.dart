import '../models/appointment.dart';
import 'appointments_datasource.dart';

class AppointmentsMemoryDatasource implements AppointmentsDatasource {
  final List<Appointment> _items = [];

  @override
  Future<List<Appointment>> getAll() async {
    return List<Appointment>.from(_items);
  }

  @override
  Future<void> create(Appointment appointment) async {
    _items.add(appointment);
  }
}

