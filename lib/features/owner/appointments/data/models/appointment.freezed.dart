// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Appointment _$AppointmentFromJson(Map<String, dynamic> json) {
  return _Appointment.fromJson(json);
}

/// @nodoc
mixin _$Appointment {
  String get id => throw _privateConstructorUsedError;
  String get branchId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String? get staffProfileId => throw _privateConstructorUsedError;
  DateTime get startAt => throw _privateConstructorUsedError;
  DateTime get endAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  Status get status => throw _privateConstructorUsedError;
  Source get source => throw _privateConstructorUsedError;
  @JsonKey(fromJson: AppointmentMapper.customerFromJson)
  Customer get customer => throw _privateConstructorUsedError;
  Staff? get staff => throw _privateConstructorUsedError;
  List<AppointmentService> get services => throw _privateConstructorUsedError;

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentCopyWith<Appointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentCopyWith<$Res> {
  factory $AppointmentCopyWith(
          Appointment value, $Res Function(Appointment) then) =
      _$AppointmentCopyWithImpl<$Res, Appointment>;
  @useResult
  $Res call(
      {String id,
      String branchId,
      String customerId,
      String? staffProfileId,
      DateTime startAt,
      DateTime endAt,
      String? notes,
      Status status,
      Source source,
      @JsonKey(fromJson: AppointmentMapper.customerFromJson) Customer customer,
      Staff? staff,
      List<AppointmentService> services});
}

/// @nodoc
class _$AppointmentCopyWithImpl<$Res, $Val extends Appointment>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? customerId = null,
    Object? staffProfileId = freezed,
    Object? startAt = null,
    Object? endAt = null,
    Object? notes = freezed,
    Object? status = null,
    Object? source = null,
    Object? customer = null,
    Object? staff = freezed,
    Object? services = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      branchId: null == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      staffProfileId: freezed == staffProfileId
          ? _value.staffProfileId
          : staffProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      startAt: null == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: null == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as Source,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as Customer,
      staff: freezed == staff
          ? _value.staff
          : staff // ignore: cast_nullable_to_non_nullable
              as Staff?,
      services: null == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<AppointmentService>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentImplCopyWith<$Res>
    implements $AppointmentCopyWith<$Res> {
  factory _$$AppointmentImplCopyWith(
          _$AppointmentImpl value, $Res Function(_$AppointmentImpl) then) =
      __$$AppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String branchId,
      String customerId,
      String? staffProfileId,
      DateTime startAt,
      DateTime endAt,
      String? notes,
      Status status,
      Source source,
      @JsonKey(fromJson: AppointmentMapper.customerFromJson) Customer customer,
      Staff? staff,
      List<AppointmentService> services});
}

/// @nodoc
class __$$AppointmentImplCopyWithImpl<$Res>
    extends _$AppointmentCopyWithImpl<$Res, _$AppointmentImpl>
    implements _$$AppointmentImplCopyWith<$Res> {
  __$$AppointmentImplCopyWithImpl(
      _$AppointmentImpl _value, $Res Function(_$AppointmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? customerId = null,
    Object? staffProfileId = freezed,
    Object? startAt = null,
    Object? endAt = null,
    Object? notes = freezed,
    Object? status = null,
    Object? source = null,
    Object? customer = null,
    Object? staff = freezed,
    Object? services = null,
  }) {
    return _then(_$AppointmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      branchId: null == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      staffProfileId: freezed == staffProfileId
          ? _value.staffProfileId
          : staffProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      startAt: null == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: null == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as Source,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as Customer,
      staff: freezed == staff
          ? _value.staff
          : staff // ignore: cast_nullable_to_non_nullable
              as Staff?,
      services: null == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<AppointmentService>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentImpl implements _Appointment {
  const _$AppointmentImpl(
      {required this.id,
      required this.branchId,
      required this.customerId,
      this.staffProfileId,
      required this.startAt,
      required this.endAt,
      this.notes,
      required this.status,
      required this.source,
      @JsonKey(fromJson: AppointmentMapper.customerFromJson)
      required this.customer,
      this.staff,
      required final List<AppointmentService> services})
      : _services = services;

  factory _$AppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentImplFromJson(json);

  @override
  final String id;
  @override
  final String branchId;
  @override
  final String customerId;
  @override
  final String? staffProfileId;
  @override
  final DateTime startAt;
  @override
  final DateTime endAt;
  @override
  final String? notes;
  @override
  final Status status;
  @override
  final Source source;
  @override
  @JsonKey(fromJson: AppointmentMapper.customerFromJson)
  final Customer customer;
  @override
  final Staff? staff;
  final List<AppointmentService> _services;
  @override
  List<AppointmentService> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  @override
  String toString() {
    return 'Appointment(id: $id, branchId: $branchId, customerId: $customerId, staffProfileId: $staffProfileId, startAt: $startAt, endAt: $endAt, notes: $notes, status: $status, source: $source, customer: $customer, staff: $staff, services: $services)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.staffProfileId, staffProfileId) ||
                other.staffProfileId == staffProfileId) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.staff, staff) || other.staff == staff) &&
            const DeepCollectionEquality().equals(other._services, _services));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      branchId,
      customerId,
      staffProfileId,
      startAt,
      endAt,
      notes,
      status,
      source,
      customer,
      staff,
      const DeepCollectionEquality().hash(_services));

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      __$$AppointmentImplCopyWithImpl<_$AppointmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentImplToJson(
      this,
    );
  }
}

abstract class _Appointment implements Appointment {
  const factory _Appointment(
      {required final String id,
      required final String branchId,
      required final String customerId,
      final String? staffProfileId,
      required final DateTime startAt,
      required final DateTime endAt,
      final String? notes,
      required final Status status,
      required final Source source,
      @JsonKey(fromJson: AppointmentMapper.customerFromJson)
      required final Customer customer,
      final Staff? staff,
      required final List<AppointmentService> services}) = _$AppointmentImpl;

  factory _Appointment.fromJson(Map<String, dynamic> json) =
      _$AppointmentImpl.fromJson;

  @override
  String get id;
  @override
  String get branchId;
  @override
  String get customerId;
  @override
  String? get staffProfileId;
  @override
  DateTime get startAt;
  @override
  DateTime get endAt;
  @override
  String? get notes;
  @override
  Status get status;
  @override
  Source get source;
  @override
  @JsonKey(fromJson: AppointmentMapper.customerFromJson)
  Customer get customer;
  @override
  Staff? get staff;
  @override
  List<AppointmentService> get services;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
