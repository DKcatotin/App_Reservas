import '../../domain/entities/staff_entity.dart';

class Staff {
  final String id;
  final String userId;
  final String? positionId;
  final String? photoUrl;
  final String displayName;
  final String? specialty;
  final String? colorTag;
  final String? commissionType;
  final double? commissionValue;

  Staff({
    required this.id,
    required this.userId,
    this.positionId,
    this.photoUrl,
    required this.displayName,
    this.specialty,
    this.colorTag,
    this.commissionType,
    this.commissionValue,
  });

  // JSON → Model
  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      positionId: json['position_id'] as String?,
      photoUrl: json['photo_url'] as String?,
      displayName: json['display_name'] as String,
      specialty: json['specialty'] as String?,
      colorTag: json['color_tag'] as String?,
      commissionType: json['commission_type'] as String?,
      commissionValue: json['commission_value'] != null
          ? (json['commission_value'] as num).toDouble()
          : null,
    );
  }

  // Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'position_id': positionId,
      'photo_url': photoUrl,
      'display_name': displayName,
      'specialty': specialty,
      'color_tag': colorTag,
      'commission_type': commissionType,
      'commission_value': commissionValue,
    };
  }

  // Model → Entity
  StaffEntity toEntity() {
    return StaffEntity(
      id: id,
      userId: userId,
      positionId: positionId,
      photoUrl: photoUrl,
      displayName: displayName,
      specialty: specialty,
      colorTag: colorTag,
      commissionType: commissionType,
      commissionValue: commissionValue,
    );
  }

  // Entity → Model
  factory Staff.fromEntity(StaffEntity entity) {
    return Staff(
      id: entity.id,
      userId: entity.userId,
      positionId: entity.positionId,
      photoUrl: entity.photoUrl,
      displayName: entity.displayName,
      specialty: entity.specialty,
      colorTag: entity.colorTag,
      commissionType: entity.commissionType,
      commissionValue: entity.commissionValue,
    );
  }
}
