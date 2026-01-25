import 'package:agenda_app/features/owner/catalogues/domain/entities/status_entity.dart';
import '../entities/appointment_entity.dart';
import '../inputs/create_appointement_input.dart';
import '../repositories/appointments_repository.dart';
import 'package:agenda_app/core/logger/app_logger.dart';

class CreateAppointmentUseCase {
  final AppointmentsRepository repository;

  CreateAppointmentUseCase(this.repository);

  /// Crear una nueva cita
  Future<void> call(CreateAppointmentInput input) async {
    // 1. Validar input
    _validateInput(input);

    // 2. Limpiar notas
    final notes = input.notes?.trim();
    final cleanNotes = (notes == null || notes.isEmpty) ? null : notes;

    // 3. Calcular duración total de los servicios
    final int totalMinutes =
        input.services.fold(0, (sum, s) => sum + s.durationMin);

    // 4. Crear entidad Appointment
    final appointment = AppointmentEntity(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      branch: input.branch,  // ← Usar input.branch
      customerId: input.customerId,
      staffProfileId: null,
      startAt: input.startAt,
      endAt: input.startAt.add(Duration(minutes: totalMinutes)),
      notes: cleanNotes,
      status: StatusEntity.pending,  // ← Constante, no función
      source: input.source,
      customer: input.customer,
      staff: null,
      services: input.services,
    );

    // 5. Guardar en repositorio
    AppLogger.d('[USE_CASE] Creando appointment: ${appointment.id}');
    await repository.create(appointment);
    AppLogger.d('[USE_CASE] Appointment creado exitosamente');
  }

  void _validateInput(CreateAppointmentInput input) {
    if (input.customerId.trim().isEmpty) {
      throw ArgumentError('El cliente es requerido');
    }

    if (input.services.isEmpty) {
      throw ArgumentError('Debe seleccionar al menos un servicio');
    }

    if (input.startAt.isBefore(DateTime.now())) {
      throw ArgumentError('La fecha de inicio no puede ser en el pasado');
    }

    if (input.source.id.isEmpty) {
      throw ArgumentError('Debe seleccionar una fuente de cita');
    }

    if (input.branch.id.isEmpty) {
      throw ArgumentError('La sucursal es requerida');
    }
  }
}
