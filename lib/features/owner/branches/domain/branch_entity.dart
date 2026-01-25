import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_entity.freezed.dart';

@freezed
class BranchEntity with _$BranchEntity {
  const factory BranchEntity({
    required String id,
    required String name,
    required String phone,
    required String email,
    required String address,
    required String city,
    required bool enabled,
  }) = _BranchEntity;
}
