import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';

class CreateAppointmentInput {
  final String customerId;
  final CustomerEntity customer; //  NUEVO
  final DateTime startAt;
  final String source;
  final List<ServiceEntity> services;
  final String? notes;

  CreateAppointmentInput({
    required this.customerId,
    required this.customer,
    required this.startAt,
    required this.source,
    required this.services,
    this.notes,
  });
}
