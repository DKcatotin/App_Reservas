import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class GetAppointmentsByDayUseCase {
  final AppointmentsRepository repository;

  GetAppointmentsByDayUseCase(this.repository);

  /// Obtiene todas las citas de un día específico, ordenadas por hora
  Future<List<AppointmentEntity>> call(DateTime day) async {
    // Normalizar la fecha (ignorar hora, minuto, segundo)
    final normalizedDay = DateTime(day.year, day.month, day.day);
    
    // Obtener citas del día
    final appointments = await repository.getByDay(normalizedDay);

    // Las citas ya vienen ordenadas por startAt desde el repository
    return appointments;
  }

  /// Obtiene las citas de hoy
  Future<List<AppointmentEntity>> today() async {
    return call(DateTime.now());
  }

  /// Obtiene las citas de mañana
  Future<List<AppointmentEntity>> tomorrow() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return call(tomorrow);
  }

  /// Obtiene las citas de una semana específica
  Future<Map<DateTime, List<AppointmentEntity>>> getWeek(DateTime startOfWeek) async {
    final Map<DateTime, List<AppointmentEntity>> weekAppointments = {};

    // Iterar los 7 días de la semana
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final normalizedDay = DateTime(day.year, day.month, day.day);
      final appointments = await call(normalizedDay);
      
      if (appointments.isNotEmpty) {
        weekAppointments[normalizedDay] = appointments;
      }
    }

    return weekAppointments;
  }

  /// Filtra citas por estado
  List<AppointmentEntity> filterByStatus(
    List<AppointmentEntity> appointments,
    String statusCode,
  ) {
    return appointments
        .where((a) => a.status.code == statusCode)
        .toList();
  }

  /// Filtra citas por staff
  List<AppointmentEntity> filterByStaff(
    List<AppointmentEntity> appointments,
    String staffId,
  ) {
    return appointments
        .where((a) => a.staffProfileId == staffId)
        .toList();
  }
}
