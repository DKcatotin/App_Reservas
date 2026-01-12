import '../entities/service_entity.dart';

class CreateAppointmentInput {
  final String customerName;
  final String customerPhone;
  final DateTime startAt;
  final List<ServiceEntity> services;  // ← CAMBIAR a ServiceEntity
  final String source;
  final String? notes;

  CreateAppointmentInput({
    required this.customerName,
    required this.customerPhone,
    required this.startAt,
    required this.services,
    required this.source,
    this.notes,
  });

  // Método auxiliar para calcular duración total
  int get totalDurationMinutes {
    return services.fold<int>(
      0,
      (sum, service) => sum + service.durationMinutes,
    );
  }

  // Método auxiliar para calcular hora de fin
  DateTime get endAt {
    return startAt.add(Duration(minutes: totalDurationMinutes));
  }
}
