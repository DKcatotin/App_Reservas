class Staff {
  final String id;
  final String? userId;
  final String displayName;
  final String? specialty;
  final String? colorTag;
  final String? commissionType;
  final double? commissionValue;

  Staff({
    required this.id,
    this.userId,
    required this.displayName,
    this.specialty,
    this.colorTag,
    this.commissionType,
    this.commissionValue,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String?,
      displayName: json['display_name'] as String? ?? '',
      specialty: json['specialty'] as String?,
      colorTag: json['color_tag'] as String?,
      commissionType: json['commission_type'] as String?,
      commissionValue: json['commission_value'] != null
          ? (json['commission_value'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'display_name': displayName,
      'specialty': specialty,
      'color_tag': colorTag,
      'commission_type': commissionType,
      'commission_value': commissionValue,
    };
  }
}
