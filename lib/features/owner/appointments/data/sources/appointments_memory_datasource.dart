import '../models/appointment.dart';
import 'appointments_datasource.dart';

class AppointmentsMemoryDatasource implements AppointmentsDatasource {
  final List<Appointment> _items = [];

  @override
  Future<List<Appointment>> getAll() async {
    return List<Appointment>.from(_items);
  }
@override
  Future<void> update(Appointment appointment) async {
    final index = _items.indexWhere((a) => a.id == appointment.id);
    if (index == -1) return;

    _items[index] = appointment;
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((a) => a.id == id);
  }
  @override
  Future<void> create(Appointment appointment) async {
    _items.add(appointment);
  }
}

