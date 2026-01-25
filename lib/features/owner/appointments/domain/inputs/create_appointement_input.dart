import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/branches/domain/branch_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';

class CreateAppointmentInput {
  final String customerId;
  final CustomerEntity customer;
  final DateTime startAt;
  final List<ServiceEntity> services;
  final SourceEntity source;
  final String? notes;
  final BranchEntity branch;  // ← Cambiar de branchId a branch

  CreateAppointmentInput({
    required this.customerId,
    required this.customer,
    required this.startAt,
    required this.services,
    required this.source,
    required this.branch,  // ← REQUERIDO
    this.notes,
  });
}



