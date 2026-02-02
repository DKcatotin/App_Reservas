import 'package:agenda_app/features/owner/catalogues/domain/entities/status_entity.dart';
import '../entities/appointment_entity.dart';
import '../inputs/create_appointement_input.dart';
import '../repositories/appointments_repository.dart';
import 'package:agenda_app/core/logger/app_logger.dart';

class CreateAppointmentUseCase {
  final AppointmentsRepository repository;

  CreateAppointmentUseCase(this.repository);

  /// Crear una nueva cita SIN servicios
  /// Los servicios se asignan después cuando se EDITA la cita
  Future<void> call(CreateAppointmentInput input) async {
    // 1. Validar input
    _validateInput(input);

    // 2. Limpiar notas
    final notes = input.notes?.trim();
    final cleanNotes = (notes == null || notes.isEmpty) ? null : notes;

    // 3. Crear entidad Appointment SIN servicios
    final appointment = AppointmentEntity(
  id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
  branch: input.branch,
  customerId: input.customerId,
  staffProfileId: null,
  startAt: input.startAt,
  endAt: input.endAt,
  notes: cleanNotes,
  status: StatusEntity.pending,
  source: input.source,
  customer: input.customer,
  staff: null,

  /// ✅ Ahora sí manda lo seleccionado
  services: input.selectedServices,
);


    // 4. Guardar en repositorio
    AppLogger.d('[USE_CASE] Creando appointment: ${appointment.id}');
    await repository.create(appointment);
    AppLogger.d('[USE_CASE] Appointment creado exitosamente');
  }

  void _validateInput(CreateAppointmentInput input) {
    if (input.customerId.trim().isEmpty) {
      throw ArgumentError('El cliente es requerido');
    }

    if (input.startAt.isBefore(DateTime.now())) {
      throw ArgumentError('La fecha de inicio no puede ser en el pasado');
    }

    if (input.endAt.isBefore(input.startAt)) {
      throw ArgumentError('La fecha de fin debe ser después de la fecha de inicio');
    }

    if (input.source.id.isEmpty) {
      throw ArgumentError('Debe seleccionar una fuente de cita');
    }

    if (input.branch.id.isEmpty) {
      throw ArgumentError('La sucursal es requerida');
    }
  }
}