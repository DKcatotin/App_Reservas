import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';

class CreateAppointmentInput {
  final String customerId;
  final CustomerEntity customer;
  final DateTime startAt;
  final List<ServiceEntity> services;
  final SourceEntity source;  // ← CAMBIAR de String a SourceEntity
  final String? notes;

  CreateAppointmentInput({
    required this.customerId,
    required this.customer,
    required this.startAt,
    required this.services,
    required this.source,  // ← Ya no es String
    this.notes,
  });
}

