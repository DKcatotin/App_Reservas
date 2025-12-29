import 'customer.dart';
import 'staff.dart';
import 'status.dart';
import 'source.dart';
import 'appointment_service.dart';

class Appointment {
  final String id;
  final String ownerId;
  final String branchId;
  final String customerId;
  final String staffId;
  final DateTime startAt;
  final DateTime endAt;
  final String? notes;
  final Status status;
  final Source source;
  final Customer customer;
  final Staff staff;
  final List<AppointmentService> services;

  Appointment({
    required this.id,
    required this.ownerId,
    required this.branchId,
    required this.customerId,
    required this.staffId,
    required this.startAt,
    required this.endAt,
    this.notes,
    required this.status,
    required this.source,
    required this.customer,
    required this.staff,
    required this.services,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      ownerId: json['owner_id'],
      branchId: json['branch_id'],
      customerId: json['customer_id'],
      staffId: json['staff_id'],
      startAt: DateTime.parse(json['start_at']),
      endAt: DateTime.parse(json['end_at']),
      notes: json['notes'],
      status: Status.fromJson(json['status']),
      source: Source.fromJson(json['source']),
      customer: Customer.fromJson(json['customer']),
      staff: Staff.fromJson(json['staff']),
      services: (json['services'] as List)
          .map((e) => AppointmentService.fromJson(e))
          .toList(),
    );
  }
}
