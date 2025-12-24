import '../models/appointment.dart';
import '../sources/appointments_mock_api.dart';

class AppointmentsRepository {
  final AppointmentsMockApi mockApi;

  AppointmentsRepository({required this.mockApi});

  Future<List<Appointment>> getToday() => mockApi.getToday();
}
