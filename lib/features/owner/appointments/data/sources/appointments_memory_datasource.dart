import '../models/appointment.dart';
import 'appointments_datasource.dart';

class AppointmentsMemoryDatasource implements AppointmentsDatasource {
  final List<Appointment> _items = [];

  @override
  Future<List<Appointment>> getToday() async {
    return _items.where((a) => _isToday(a.startAt)).toList();
  }

  @override
  Future<List<Appointment>> getUpcoming() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _items.where((a) {
      final aDate = DateTime(
        a.startAt.year,
        a.startAt.month,
        a.startAt.day,
      );
      return aDate.isAfter(today);
    }).toList();
  }

  @override
  Future<List<Appointment>> getPast() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _items.where((a) {
      final aDate = DateTime(
        a.startAt.year,
        a.startAt.month,
        a.startAt.day,
      );
      return aDate.isBefore(today);
    }).toList();
  }

  @override
  Future<void> create(Appointment appointment) async {
    _items.add(appointment);
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year &&
        d.month == now.month &&
        d.day == now.day;
  }
}
