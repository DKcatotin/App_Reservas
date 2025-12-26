import '../models/appointment.dart';

class AppointmentsMockApi {
  Future<List<Appointment>> getToday() async {
    await Future.delayed(const Duration(milliseconds: 250));

    final now = DateTime.now();
    return [
      Appointment(
        id: 'a1',
        startAt: DateTime(now.year, now.month, now.day, 10, 0),
        customerName: 'María',
        serviceName: 'Uñas acrílicas',
        status: 'pending',
      ),
      Appointment(
        id: 'a2',
        startAt: DateTime(now.year, now.month, now.day, 12, 30),
        customerName: 'Daniela',
        serviceName: 'Manicure',
        status: 'confirmed',
      ),
      Appointment(
        id: 'a3',
        startAt: DateTime(now.year, now.month, now.day, 16, 0),
        customerName: 'Sofi',
        serviceName: 'Pedicure',
        status: 'done',
      ),
    ];
  }
}
