import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/branches/domain/branch_entity.dart';

/// ✅ CORRECCIÓN: Crear cita SIN servicios
/// Los servicios se asignan DESPUÉS en una edición
class CreateAppointmentInput {
  final String customerId;
  final CustomerEntity customer;
  final DateTime startAt;
  final DateTime endAt;  // ✅ Ya calculado desde el frontend
  final SourceEntity source;
  final String? notes;
  final BranchEntity branch;

  CreateAppointmentInput({
    required this.customerId,
    required this.customer,
    required this.startAt,
    required this.endAt,
    required this.source,
    required this.branch,
    this.notes,
  });
}