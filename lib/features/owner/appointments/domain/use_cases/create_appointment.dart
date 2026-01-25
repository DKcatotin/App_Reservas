import 'package:agenda_app/features/owner/catalogues/domain/entities/status_entity.dart';

import '../entities/appointment_entity.dart';
import '../entities/source_entity.dart';
import '../inputs/create_appointement_input.dart';
import '../repositories/appointments_repository.dart';
import '../utils/id_generator.dart';

class CreateAppointmentUseCase {
  final AppointmentsRepository repository;

  CreateAppointmentUseCase(this.repository);

  Future<void> call(CreateAppointmentInput input) async {
    // 1. Validar input
    _validateInput(input);

    // 2. Limpiar notas
    final notes = input.notes?.trim();
    final cleanNotes = (notes == null || notes.isEmpty) ? null : notes;

    // 3. Calcular duración total
    final int totalMinutes =
        input.services.fold(0, (sum, s) => sum + s.durationMin);

    // 4. Crear entidad Appointment
    final appointment = AppointmentEntity(
      id: IdGenerator.generate('appointment'),
      branchId: 'branch1', // Obtener del contexto sesión
      customerId: input.customerId,
      staffProfileId: null,
      startAt: input.startAt,
      endAt: input.startAt.add(Duration(minutes: totalMinutes)),
      notes: cleanNotes,
      status: StatusEntity.pending,
      source: input.source, // ← CAMBIO: Ya viene como SourceEntity
      customer: input.customer,
      staff: null,
      services: input.services,
    );

    // 5. Guardar en repositorio
    await repository.create(appointment);
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
  }
}
