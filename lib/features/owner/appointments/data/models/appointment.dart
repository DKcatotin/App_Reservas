import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agenda_app/features/owner/catalogues/data/models/staff.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/status.dart';
import 'package:agenda_app/features/owner/branches/data/models/branch.dart';  // ← AGREGAR

import 'customer.dart';
import 'source.dart';
import 'appointment_service.dart';
import '../mappers/appointment_mapper.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required Branch branch,  
    required String customerId,
    String? staffProfileId,
    required DateTime startAt,
    required DateTime endAt,
    String? notes,
    required Status status,
    required Source source,

    @JsonKey(fromJson: AppointmentMapper.customerFromJson)
    required Customer customer,

    Staff? staff,
    List<AppointmentService>? services,  // ← Cambiar a nullable
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}



