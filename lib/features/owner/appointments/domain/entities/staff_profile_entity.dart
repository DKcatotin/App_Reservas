class StaffProfileEntity {
  final String id;
  final String userId;              // ✅ NUEVO
  final String? positionId;         // ✅ NUEVO
  final String? photoUrl;           // ✅ NUEVO
  final String? displayName;        // ✅ CAMBIO: name → displayName
  final String? specialty;          // ✅ OK
  final String? colorTag;           // ✅ OK
  final String? commissionType;     // ✅ NUEVO (percent|fixed|none)
  final double? commissionValue;    // ✅ NUEVO

  const StaffProfileEntity({
    required this.id,
    required this.userId,
    this.positionId,
    this.photoUrl,
    this.displayName,
    this.specialty,
    this.colorTag,
    this.commissionType,
    this.commissionValue,
  });

  StaffProfileEntity copyWith({
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
    return StaffProfileEntity(
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
