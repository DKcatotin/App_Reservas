import '../models/appointment.dart';
import '../models/customer.dart';
import '../models/staff.dart';
import '../models/status.dart';
import '../models/source.dart';
import '../models/appointment_service.dart';

class AppointmentsMockApi {
  Future<List<Appointment>> getToday() async {
    await Future.delayed(const Duration(milliseconds: 250));

    final now = DateTime.now();

    return [
      Appointment(
        id: 'a1',
        ownerId: 'owner1',
        branchId: 'branch1',
        customerId: 'c1',
        staffId: 's1',
        startAt: DateTime(now.year, now.month, now.day, 10, 0),
        endAt: DateTime(now.year, now.month, now.day, 11, 0),
        notes: null,
        status: Status(code: 'pending', label: 'Pendiente'),
        source: Source(type: 'manual'),
        customer: Customer(
          id: 'c1',
          name: 'María',
          phone: '099999999',
        ),
        staff: Staff(
          id: 's1',
          name: 'Andrea',
        ),
        services: [
          AppointmentService(
            id: 'sv1',
            name: 'Uñas acrílicas',
            durationMinutes: 60,
          ),
        ],
      ),
    ];
  }
}
