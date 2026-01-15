import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class UpdateAppointmentUseCase {
  final AppointmentsRepository repository;

  UpdateAppointmentUseCase(this.repository);

  /// Actualiza una cita existente
  Future<void> call(AppointmentEntity updatedAppointment) async {
    // 1. Validaciones
    _validateAppointment(updatedAppointment);

    // 2. Verificar que la cita exista (opcional, depende de tu lógica)
    // Si el repository lanza error si no existe, no es necesario

    // 3. Actualizar en el repository
    await repository.update(updatedAppointment);
  }

  /// Actualiza solo el staff de una cita
  Future<void> updateStaff({
    required AppointmentEntity appointment,
    required String? newStaffId,
  }) async {
    final updated = appointment.copyWith(staffId: newStaffId);
    await call(updated);
  }

  /// Actualiza el estado de una cita
  Future<void> updateStatus({
    required AppointmentEntity appointment,
    required String statusCode,
    required String statusLabel,
  }) async {
    final updated = appointment.copyWith(
      status: appointment.status.copyWith(
        code: statusCode,
        name: statusLabel, // 
      ),
    );
    await call(updated);
  }

  /// Confirma una cita (cambia estado a 'confirmed')
  Future<void> confirm(AppointmentEntity appointment) async {
    await updateStatus(
      appointment: appointment,
      statusCode: 'confirmed',
      statusLabel: 'Confirmada',
    );
  }

  /// Cancela una cita (cambia estado a 'cancelled')
  Future<void> cancel(AppointmentEntity appointment) async {
    await updateStatus(
      appointment: appointment,
      statusCode: 'cancelled',
      statusLabel: 'Cancelada',
    );
  }
// Cambia el estado de la cita a 'pending'
  Future<void> reset(AppointmentEntity appointment) async {
    await updateStatus(
      appointment: appointment,
      statusCode: 'pending',
      statusLabel: 'Pendiente',
    );
  }
  
  /// Reagenda una cita (cambia fecha/hora)
  Future<void> reschedule({
    required AppointmentEntity appointment,
    required DateTime newStartAt,
  }) async {
    // Calcular nueva hora de fin basada en la duración original
    final duration = appointment.endAt.difference(appointment.startAt);
    final newEndAt = newStartAt.add(duration);

    final updated = appointment.copyWith(
      startAt: newStartAt,
      endAt: newEndAt,
    );

    await call(updated);
  }

  /// Actualiza las notas de una cita
  Future<void> updateNotes({
    required AppointmentEntity appointment,
    required String? notes,
  }) async {
    final cleanNotes = notes?.trim();
    final finalNotes = (cleanNotes == null || cleanNotes.isEmpty) ? null : cleanNotes;

    final updated = appointment.copyWith(notes: finalNotes);
    await call(updated);
  }

  /// Validaciones de negocio
  void _validateAppointment(AppointmentEntity appointment) {
    // Validar que la fecha de inicio sea válida
    if (appointment.startAt.isAfter(appointment.endAt)) {
      throw ArgumentError('La fecha de inicio debe ser antes que la fecha de fin');
    }

    // Validar que la cita no esté en el pasado (excepto si ya está completada)
    if (appointment.status.code != 'completed' &&
        appointment.status.code != 'cancelled' &&
        appointment.endAt.isBefore(DateTime.now())) {
      throw ArgumentError('No se puede actualizar una cita que ya pasó');
    }

    // Validar que tenga al menos un servicio
    if (appointment.services.isEmpty) {
      throw ArgumentError('La cita debe tener al menos un servicio');
    }
  }
}
