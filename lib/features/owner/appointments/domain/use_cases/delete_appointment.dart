import 'package:agenda_app/core/logger/app_logger.dart';

import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class DeleteAppointmentUseCase {
  final AppointmentsRepository repository;

  DeleteAppointmentUseCase(this.repository);

  /// Elimina una cita por su ID
  Future<void> call(String appointmentId) async {
    // 1. Validar que el ID no esté vacío
    if (appointmentId.trim().isEmpty) {
      throw ArgumentError('El ID de la cita no puede estar vacío');
    }

    // 2. Eliminar del repository
    await repository.delete(appointmentId);
  }

  /// Elimina una cita usando la entidad completa
  Future<void> deleteEntity(AppointmentEntity appointment) async {
    // Validar que la cita pueda ser eliminada
    _validateDeletion(appointment);

    await call(appointment.id);
  }

  /// Cancela en lugar de eliminar (soft delete)
  /// Esto es más recomendable para mantener historial
  Future<void> cancelInsteadOfDelete(
    AppointmentEntity appointment,
  ) async {
    // En lugar de eliminar, cambiar el estado a cancelado
    // Esto requiere el UpdateAppointmentUseCase
    throw UnimplementedError(
      'Usa UpdateAppointmentUseCase.cancel() en lugar de eliminar',
    );
  }

  /// Elimina múltiples citas
  Future<void> deleteMultiple(List<String> appointmentIds) async {
    for (final id in appointmentIds) {
      await call(id);
    }
  }

  /// Validaciones antes de eliminar
  void _validateDeletion(AppointmentEntity appointment) {
    // No permitir eliminar citas completadas (opcional, según tu lógica)
    if (appointment.status.code == 'completed') {
      throw StateError(
        'No se puede eliminar una cita completada. '
        'Considera cancelarla en su lugar.',
      );
    }

    // No permitir eliminar citas que ya empezaron (opcional)
    if (appointment.isInProgress) {
      throw StateError(
        'No se puede eliminar una cita que está en curso',
      );
    }

    // Advertencia si la cita es muy próxima (puedes lanzar excepción o solo log)
    final hoursUntilAppointment = appointment.startAt.difference(DateTime.now()).inHours;
    if (hoursUntilAppointment < 2 && hoursUntilAppointment > 0) {
      // Podrías lanzar una excepción o solo hacer un log
      AppLogger.d(' Advertencia: Eliminando cita que comienza en menos de 2 horas');
    }
  }

  /// Elimina todas las citas de un cliente (usar con precaución)
  Future<void> deleteAllByCustomer(String customerId) async {
    // Esta funcionalidad requeriría un método en el repository
    // para obtener todas las citas de un cliente
    throw UnimplementedError(
      'Necesita implementación en repository: getAllByCustomer()',
    );
  }

  /// Elimina todas las citas canceladas (limpieza de datos)
  Future<void> deleteCancelled() async {
    // Esta funcionalidad requeriría un método en el repository
    throw UnimplementedError(
      'Necesita implementación en repository: getAllCancelled()',
    );
  }
}
