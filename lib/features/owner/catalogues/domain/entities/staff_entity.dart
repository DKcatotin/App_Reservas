class StaffEntity {
  final String id;
  final String userId;              // FK a users (requerido)
  final String? positionId;         
  final String? photoUrl;           
  final String displayName;         
  final String? specialty;          
  final String? colorTag;           
  final String? commissionType;     // percent|fixed|none
  final double? commissionValue; 

  const StaffEntity({
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

  StaffEntity copyWith({
    String? id,
    String? userId,
    String? positionId,
    String? photoUrl,
    String? displayName,
    String? specialty,
    String? colorTag,
    String? commissionType,
    double? commissionValue,
  }) {
    return StaffEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      positionId: positionId ?? this.positionId,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
      specialty: specialty ?? this.specialty,
      colorTag: colorTag ?? this.colorTag,
      commissionType: commissionType ?? this.commissionType,
      commissionValue: commissionValue ?? this.commissionValue,
    );
  }
}
