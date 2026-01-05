import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';

class CreateAppointmentInput {
  final String customerName;
  final String customerPhone;
  final DateTime startAt;
  final List<Service> services;
  final String source;
  final String notes;

  CreateAppointmentInput({
    required this.customerName,
    required this.customerPhone,
    required this.startAt,
    required this.services,
    required this.source,
    required this.notes,
  });
}
