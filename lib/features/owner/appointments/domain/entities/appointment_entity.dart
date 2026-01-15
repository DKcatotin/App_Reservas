import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/service_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/staff_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/status_entity.dart';

class AppointmentEntity {
  final String id;
  // ❌ ELIMINAR: final String ownerId;
  final String branchId;
  final String customerId;
  final String? staffId;
  final DateTime startAt;
  final DateTime endAt;
  final String? notes;
  final StatusEntity status;
  final SourceEntity source;
  final CustomerEntity customer;
  final StaffEntity? staff;
  final List<ServiceEntity> services;

  const AppointmentEntity({
    required this.id,
    // ❌ ELIMINAR: required this.ownerId,
    required this.branchId,
    required this.customerId,
    this.staffId,
    required this.startAt,
    required this.endAt,
    this.notes,
    required this.status,
    required this.source,
    required this.customer,
    this.staff,
    required this.services,
  });

  Duration get totalDuration => endAt.difference(startAt);
  bool get isPast => endAt.isBefore(DateTime.now());
  bool get isFuture => startAt.isAfter(DateTime.now());
  
  bool get isInProgress {
    final now = DateTime.now();
    return startAt.isBefore(now) && endAt.isAfter(now);
  }

  AppointmentEntity copyWith({
    String? id,
    // ❌ ELIMINAR: String? ownerId,
    String? branchId,
    String? customerId,
    String? staffId,
    DateTime? startAt,
    DateTime? endAt,
    String? notes,
    StatusEntity? status,
    SourceEntity? source,
    CustomerEntity? customer,
    StaffEntity? staff,
    List<ServiceEntity>? services,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      // ❌ ELIMINAR: ownerId: ownerId ?? this.ownerId,
      branchId: branchId ?? this.branchId,
      customerId: customerId ?? this.customerId,
      staffId: staffId ?? this.staffId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      source: source ?? this.source,
      customer: customer ?? this.customer,
      staff: staff ?? this.staff,
      services: services ?? this.services,
    );
  }
}
