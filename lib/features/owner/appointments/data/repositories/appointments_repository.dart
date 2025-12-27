import '../models/appointment.dart';
import '../models/test_item.dart';
import '../sources/appointments_mock_api.dart';
import '../sources/appointments_api.dart';

class AppointmentsRepository {
  final AppointmentsMockApi mockApi;
  final AppointmentsApi api;

  AppointmentsRepository({
    required this.mockApi,
    required this.api,
  });

  // Agenda local (JSON)
  Future<List<Appointment>> getToday() {
    return mockApi.getToday();
  }

  // Ruta privada backend
  Future<List<TestItem>> getTest1() {
    return api.getTest1();
  }
}
