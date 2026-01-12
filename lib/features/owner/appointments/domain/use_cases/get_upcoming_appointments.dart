import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';
import '../utils/date_utils.dart';

class GetUpcomingAppointmentsUseCase {
  final AppointmentsRepository repository;

  GetUpcomingAppointmentsUseCase(this.repository);

  /// Obtiene todas las citas futuras (desde mañana en adelante)
  Future<List<AppointmentEntity>> call() async {
    final all = await repository.getAll();
    final today = DateTime.now();

    final result = all.where((a) {
      final d = a.startAt;
      return !isSameDate(d, today) && d.isAfter(today);
    }).toList();

    result.sort((a, b) => a.startAt.compareTo(b.startAt));
    return result;
  }

  /// Obtiene citas de la próxima semana
  Future<List<AppointmentEntity>> nextWeek() async {
    final upcoming = await call();
    final nextWeek = DateTime.now().add(const Duration(days: 7));

    return upcoming
        .where((a) => a.startAt.isBefore(nextWeek))
        .toList();
  }

  /// Obtiene citas del próximo mes
  Future<List<AppointmentEntity>> nextMonth() async {
    final upcoming = await call();
    final nextMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      DateTime.now().day,
    );

    return upcoming
        .where((a) => a.startAt.isBefore(nextMonth))
        .toList();
  }
}
