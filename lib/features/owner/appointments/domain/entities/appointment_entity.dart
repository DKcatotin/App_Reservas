import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/staff_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/status_entity.dart';

part 'appointment_entity.freezed.dart';

@freezed
class AppointmentEntity with _$AppointmentEntity {
  const AppointmentEntity._(); // ✅ para poder tener getters (lógica)

  const factory AppointmentEntity({
    required String id,
    required String branchId,
    required String customerId,
    String? staffProfileId,
    required DateTime startAt,
    required DateTime endAt,
    String? notes,
    required StatusEntity status,
    required SourceEntity source,
    required CustomerEntity customer,
    StaffEntity? staff,
    required List<ServiceEntity> services,
  }) = _AppointmentEntity;

  // ✅ lógica de negocio sigue existiendo normal
  Duration get totalDuration => endAt.difference(startAt);
  bool get isPast => endAt.isBefore(DateTime.now());
  bool get isFuture => startAt.isAfter(DateTime.now());

  bool get isInProgress {
    final now = DateTime.now();
    return startAt.isBefore(now) && endAt.isAfter(now);
  }
}
