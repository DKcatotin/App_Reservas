// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: json['id'] as String,
      branch: Branch.fromJson(json['branch'] as Map<String, dynamic>),
      customerId: json['customerId'] as String,
      staffProfileId: json['staffProfileId'] as String?,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      notes: json['notes'] as String?,
      status: Status.fromJson(json['status'] as Map<String, dynamic>),
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
      customer: AppointmentMapper.customerFromJson(json['customer']),
      staff: json['staff'] == null
          ? null
          : Staff.fromJson(json['staff'] as Map<String, dynamic>),
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => AppointmentService.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch': instance.branch,
      'customerId': instance.customerId,
      'staffProfileId': instance.staffProfileId,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'notes': instance.notes,
      'status': instance.status,
      'source': instance.source,
      'customer': instance.customer,
      'staff': instance.staff,
      'services': instance.services,
    };
