// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BranchEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchEntityCopyWith<BranchEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchEntityCopyWith<$Res> {
  factory $BranchEntityCopyWith(
          BranchEntity value, $Res Function(BranchEntity) then) =
      _$BranchEntityCopyWithImpl<$Res, BranchEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String phone,
      String email,
      String address,
      String city,
      bool enabled});
}

/// @nodoc
class _$BranchEntityCopyWithImpl<$Res, $Val extends BranchEntity>
    implements $BranchEntityCopyWith<$Res> {
  _$BranchEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = null,
    Object? email = null,
    Object? address = null,
    Object? city = null,
    Object? enabled = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BranchEntityImplCopyWith<$Res>
    implements $BranchEntityCopyWith<$Res> {
  factory _$$BranchEntityImplCopyWith(
          _$BranchEntityImpl value, $Res Function(_$BranchEntityImpl) then) =
      __$$BranchEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String phone,
      String email,
      String address,
      String city,
      bool enabled});
}

/// @nodoc
class __$$BranchEntityImplCopyWithImpl<$Res>
    extends _$BranchEntityCopyWithImpl<$Res, _$BranchEntityImpl>
    implements _$$BranchEntityImplCopyWith<$Res> {
  __$$BranchEntityImplCopyWithImpl(
      _$BranchEntityImpl _value, $Res Function(_$BranchEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = null,
    Object? email = null,
    Object? address = null,
    Object? city = null,
    Object? enabled = null,
  }) {
    return _then(_$BranchEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BranchEntityImpl implements _BranchEntity {
  const _$BranchEntityImpl(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.address,
      required this.city,
      required this.enabled});

  @override
  final String id;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String email;
  @override
  final String address;
  @override
  final String city;
  @override
  final bool enabled;

  @override
  String toString() {
    return 'BranchEntity(id: $id, name: $name, phone: $phone, email: $email, address: $address, city: $city, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, phone, email, address, city, enabled);

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchEntityImplCopyWith<_$BranchEntityImpl> get copyWith =>
      __$$BranchEntityImplCopyWithImpl<_$BranchEntityImpl>(this, _$identity);
}

abstract class _BranchEntity implements BranchEntity {
  const factory _BranchEntity(
      {required final String id,
      required final String name,
      required final String phone,
      required final String email,
      required final String address,
      required final String city,
      required final bool enabled}) = _$BranchEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get phone;
  @override
  String get email;
  @override
  String get address;
  @override
  String get city;
  @override
  bool get enabled;

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchEntityImplCopyWith<_$BranchEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
