// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppointmentEntity {
  String get id => throw _privateConstructorUsedError;
  String get branchId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String? get staffProfileId => throw _privateConstructorUsedError;
  DateTime get startAt => throw _privateConstructorUsedError;
  DateTime get endAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  StatusEntity get status => throw _privateConstructorUsedError;
  SourceEntity get source => throw _privateConstructorUsedError;
  CustomerEntity get customer => throw _privateConstructorUsedError;
  StaffEntity? get staff => throw _privateConstructorUsedError;
  List<ServiceEntity> get services => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentEntityCopyWith<AppointmentEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentEntityCopyWith<$Res> {
  factory $AppointmentEntityCopyWith(
          AppointmentEntity value, $Res Function(AppointmentEntity) then) =
      _$AppointmentEntityCopyWithImpl<$Res, AppointmentEntity>;
  @useResult
  $Res call(
      {String id,
      String branchId,
      String customerId,
      String? staffProfileId,
      DateTime startAt,
      DateTime endAt,
      String? notes,
      StatusEntity status,
      SourceEntity source,
      CustomerEntity customer,
      StaffEntity? staff,
      List<ServiceEntity> services});
}

/// @nodoc
class _$AppointmentEntityCopyWithImpl<$Res, $Val extends AppointmentEntity>
    implements $AppointmentEntityCopyWith<$Res> {
  _$AppointmentEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentEntity
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
              as StatusEntity,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as SourceEntity,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerEntity,
      staff: freezed == staff
          ? _value.staff
          : staff // ignore: cast_nullable_to_non_nullable
              as StaffEntity?,
      services: null == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<ServiceEntity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentEntityImplCopyWith<$Res>
    implements $AppointmentEntityCopyWith<$Res> {
  factory _$$AppointmentEntityImplCopyWith(_$AppointmentEntityImpl value,
          $Res Function(_$AppointmentEntityImpl) then) =
      __$$AppointmentEntityImplCopyWithImpl<$Res>;
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
      StatusEntity status,
      SourceEntity source,
      CustomerEntity customer,
      StaffEntity? staff,
      List<ServiceEntity> services});
}

/// @nodoc
class __$$AppointmentEntityImplCopyWithImpl<$Res>
    extends _$AppointmentEntityCopyWithImpl<$Res, _$AppointmentEntityImpl>
    implements _$$AppointmentEntityImplCopyWith<$Res> {
  __$$AppointmentEntityImplCopyWithImpl(_$AppointmentEntityImpl _value,
      $Res Function(_$AppointmentEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppointmentEntity
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
    return _then(_$AppointmentEntityImpl(
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
              as StatusEntity,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as SourceEntity,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerEntity,
      staff: freezed == staff
          ? _value.staff
          : staff // ignore: cast_nullable_to_non_nullable
              as StaffEntity?,
      services: null == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<ServiceEntity>,
    ));
  }
}

/// @nodoc

class _$AppointmentEntityImpl extends _AppointmentEntity {
  const _$AppointmentEntityImpl(
      {required this.id,
      required this.branchId,
      required this.customerId,
      this.staffProfileId,
      required this.startAt,
      required this.endAt,
      this.notes,
      required this.status,
      required this.source,
      required this.customer,
      this.staff,
      required final List<ServiceEntity> services})
      : _services = services,
        super._();

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
  final StatusEntity status;
  @override
  final SourceEntity source;
  @override
  final CustomerEntity customer;
  @override
  final StaffEntity? staff;
  final List<ServiceEntity> _services;
  @override
  List<ServiceEntity> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  @override
  String toString() {
    return 'AppointmentEntity(id: $id, branchId: $branchId, customerId: $customerId, staffProfileId: $staffProfileId, startAt: $startAt, endAt: $endAt, notes: $notes, status: $status, source: $source, customer: $customer, staff: $staff, services: $services)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentEntityImpl &&
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

  /// Create a copy of AppointmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentEntityImplCopyWith<_$AppointmentEntityImpl> get copyWith =>
      __$$AppointmentEntityImplCopyWithImpl<_$AppointmentEntityImpl>(
          this, _$identity);
}

abstract class _AppointmentEntity extends AppointmentEntity {
  const factory _AppointmentEntity(
      {required final String id,
      required final String branchId,
      required final String customerId,
      final String? staffProfileId,
      required final DateTime startAt,
      required final DateTime endAt,
      final String? notes,
      required final StatusEntity status,
      required final SourceEntity source,
      required final CustomerEntity customer,
      final StaffEntity? staff,
      required final List<ServiceEntity> services}) = _$AppointmentEntityImpl;
  const _AppointmentEntity._() : super._();

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
  StatusEntity get status;
  @override
  SourceEntity get source;
  @override
  CustomerEntity get customer;
  @override
  StaffEntity? get staff;
  @override
  List<ServiceEntity> get services;

  /// Create a copy of AppointmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentEntityImplCopyWith<_$AppointmentEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
