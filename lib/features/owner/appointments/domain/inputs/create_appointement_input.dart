import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/branches/domain/branch_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';

class CreateAppointmentInput {
  final String customerId;
  final CustomerEntity customer;
  final DateTime startAt;
  final DateTime endAt;
  final SourceEntity source;
  final String? notes;
  final BranchEntity branch;

  /// ✅ NUEVO: servicios seleccionados (catálogo)
  final List<ServiceEntity> selectedServices;

  CreateAppointmentInput({
    required this.customerId,
    required this.customer,
    required this.startAt,
    required this.endAt,
    required this.source,
    required this.branch,
    required this.selectedServices,
    this.notes,
  });
}
