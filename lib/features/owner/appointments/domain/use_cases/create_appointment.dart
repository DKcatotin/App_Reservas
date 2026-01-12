import '../entities/appointment_entity.dart';
import '../entities/customer_entity.dart';
import '../entities/source_entity.dart';
import '../entities/status_entity.dart';
import '../inputs/create_appointement_input.dart';
import '../repositories/appointments_repository.dart';
import '../utils/id_generator.dart';

class CreateAppointmentUseCase {
  final AppointmentsRepository repository;

  CreateAppointmentUseCase(this.repository);

  /// Crea una nueva cita a partir del input del formulario
  Future<void> call(CreateAppointmentInput input) async {
    // 1. Validar input
    _validateInput(input);

    // 2. Limpiar notas
    final notes = input.notes?.trim();
    final cleanNotes = (notes == null || notes.isEmpty) ? null : notes;

    // 3. Crear entidad Customer
    final customer = CustomerEntity(
      id: IdGenerator.generate('customer'),
      name: input.customerName.trim(),
      phone: input.customerPhone.trim(),
    );

    // 4. Calcular duración total
    final int totalMinutes =
        input.services.fold(0, (sum, s) => sum + s.durationMinutes);

    // 5. Crear entidad Appointment
    final appointment = AppointmentEntity(
      id: IdGenerator.generate('appointment'),
      ownerId: 'owner1', // TODO: Obtener del contexto/sesión
      branchId: 'branch1', // TODO: Obtener del contexto/sesión
      customerId: customer.id,
      staffId: null, // Se asignará después en edición
      startAt: input.startAt,
      endAt: input.startAt.add(Duration(minutes: totalMinutes)),
      notes: cleanNotes,
      status: StatusEntity.pending,
      source: SourceEntity(code: input.source, name: _getSourceName(input.source)),
      customer: customer,
      staff: null,
      services: input.services,
    );

    // 6. Guardar en repositorio
    await repository.create(appointment);
  }

  /// Valida que el input tenga todos los campos requeridos
  void _validateInput(CreateAppointmentInput input) {
    if (input.customerName.trim().isEmpty) {
      throw ArgumentError('El nombre del cliente es requerido');
    }

    if (input.customerPhone.trim().isEmpty) {
      throw ArgumentError('El teléfono del cliente es requerido');
    }

    if (input.services.isEmpty) {
      throw ArgumentError('Debe seleccionar al menos un servicio');
    }

    if (input.startAt.isBefore(DateTime.now())) {
      throw ArgumentError('La fecha de inicio no puede ser en el pasado');
    }
  }

  /// Mapea el código de source a un nombre legible
  String _getSourceName(String code) {
    switch (code) {
      case 'web':
        return 'Web';
      case 'app':
        return 'Aplicación';
      case 'whatsapp':
        return 'WhatsApp';
      case 'call':
        return 'Llamada';
      case 'in_person':
        return 'Presencial';
      default:
        return 'Desconocido';
    }
  }
}
