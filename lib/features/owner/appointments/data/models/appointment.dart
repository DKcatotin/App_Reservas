import 'package:agenda_app/features/owner/catalogues/data/models/staff.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/status.dart';
import 'customer.dart';
import 'source.dart';
import 'appointment_service.dart';

class _Unset {
  const _Unset();
}
const _unset = _Unset();

class Appointment {
  final String id;
  final String branchId;
  final String customerId;
  final String? staffId;
  final DateTime startAt;
  final DateTime endAt;
  final String? notes;
  final Status status;
  final Source source;
  final Customer customer;
  final Staff? staff;
  final List<AppointmentService> services;

  const Appointment({
    required this.id,
    required this.branchId,
    required this.customerId,
    required this.staffId,
    required this.startAt,
    required this.endAt,
    required this.notes,
    required this.status,
    required this.source,
    required this.customer,
    required this.staff,
    required this.services,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      branchId: json['branch_id'],
      customerId: json['customer_id'],
      staffId: json['staff_profile_id'],
      startAt: DateTime.parse(json['start_at']),
      endAt: DateTime.parse(json['end_at']),
      notes: json['notes'],
      status: Status.fromJson(json['status']),
      source: Source.fromJson(json['source']),
      customer: Customer.fromJson(json['customer']),
      staff: json['staff'] != null ? Staff.fromJson(json['staff']) : null,
      services: (json['services'] as List)
          .map((e) => AppointmentService.fromJson(e))
          .toList(),
    );
  }

  Appointment copyWith({
    String? id,
    String? branchId,
    String? customerId,
    String? staffId,
    DateTime? startAt,
    DateTime? endAt,
    Object? notes = _unset,
    Status? status,
    Source? source,
    Customer? customer,
    Staff? staff,
    List<AppointmentService>? services,
  }) {
    return Appointment(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      customerId: customerId ?? this.customerId,
      staffId: staffId ?? this.staffId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      notes: notes == _unset ? this.notes : notes as String?,
      status: status ?? this.status,
      source: source ?? this.source,
      customer: customer ?? this.customer,
      staff: staff ?? this.staff,
      services: services ?? this.services,
    );
  }
}
