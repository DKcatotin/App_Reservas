import '../models/appointment.dart';
import '../../domain/entities/appointment_entity.dart';

import 'package:agenda_app/features/owner/catalogues/data/models/status.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';
import 'package:agenda_app/features/owner/branches/data/models/branch.dart';  // ← AGREGAR
import 'package:agenda_app/features/owner/appointments/data/models/source.dart';
import 'package:agenda_app/features/owner/appointments/data/models/customer.dart';
import 'package:agenda_app/features/owner/appointments/data/models/appointment_service.dart';

class AppointmentMapper {
  // FIX: customer puede venir "plano" o dentro de {customer: {...}}
  static Customer customerFromJson(dynamic json) {
    if (json == null) {
      return Customer(
        id: '',
        userId: '',
        taxIdentification: null,
        taxName: null,
        allergies: null,
        referredBy: null,
        fullName: null,
        email: null,
        phone: null,
      );
    }

    // Caso 1: viene anidado { customer: {...} }
    if (json is Map<String, dynamic> && json.containsKey('customer')) {
      final customerJson = json['customer'];
      if (customerJson is Map<String, dynamic>) {
        return Customer.fromJson(customerJson);
      }
    }

    // Caso 2: viene normal {...}
    if (json is Map<String, dynamic>) {
      return Customer.fromJson(json);
    }

    throw Exception('Formato inválido para customer: $json');
  }

  /// MODEL -> ENTITY
  static AppointmentEntity toEntity(Appointment model) {
    return AppointmentEntity(
      id: model.id,
      branch: model.branch.toEntity(),  // ← CAMBIAR de branchId a branch
      customerId: model.customerId,
      staffProfileId: model.staffProfileId,
      startAt: model.startAt,
      endAt: model.endAt,
      notes: model.notes,

      status: model.status.toEntity(),
      source: model.source.toEntity(),
      customer: model.customer.toEntity(),
      staff: model.staff?.toEntity(),

      services: model.services.map((s) {
        return Service(
          id: s.serviceId,
          branchId: s.branchId ?? '',
          categoryId: s.categoryId,
          name: s.serviceName ?? '',
          description: s.description,
          durationMin: s.durationMin,
          basePrice: s.basePrice ?? 0.0,
          enabled: s.enabled ?? true,
        ).toEntity();
      }).toList(),
    );
  }

  /// ENTITY -> MODEL
  static Appointment toModel(AppointmentEntity entity) {
    return Appointment(
      id: entity.id,
      branch: Branch.fromEntity(entity.branch),  // ← CAMBIAR de branchId a branch
      customerId: entity.customerId,
      staffProfileId: entity.staffProfileId,
      startAt: entity.startAt,
      endAt: entity.endAt,
      notes: entity.notes,

      status: Status.fromEntity(entity.status),
      source: Source.fromEntity(entity.source),
      customer: Customer.fromEntity(entity.customer),
      staff: entity.staff != null ? Staff.fromEntity(entity.staff!) : null,

      services: entity.services.map((s) {
        return AppointmentService(
          id: '',
          appointmentId: entity.id,
          serviceId: s.id,
          durationMin: s.durationMin,
          price: s.basePrice,
          serviceName: s.name,
          branchId: entity.branch.id,  // ← Usar entity.branch.id
          categoryId: s.categoryId,
          description: s.description,
          basePrice: s.basePrice,
          enabled: s.enabled,
        );
      }).toList(),
    );
  }
}
