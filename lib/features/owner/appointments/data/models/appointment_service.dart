class AppointmentService {
  final String id;
  final String? branchId;
  final String? categoryId;
  final String name;
  final String? description;
  final int durationMin;        // ✅ Asegúrate que sea int, no double
  final double? basePrice;
  final bool? enabled;

  AppointmentService({
    required this.id,
    this.branchId,
    this.categoryId,
    required this.name,
    this.description,
    required this.durationMin,
    this.basePrice,
    this.enabled,
  });

  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    return AppointmentService(
      id: json['id'] as String? ?? '',
      branchId: json['branch_id'] as String?,
      categoryId: json['category_id'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      durationMin: (json['duration_min'] as num?)?.toInt() ?? 0,  // ✅ Convertir a int
      basePrice: json['base_price'] != null
          ? (json['base_price'] as num).toDouble()
          : null,
      enabled: json['enabled'] as bool?,
    );
  }

  Duration get duration => Duration(minutes: durationMin);

  String get durationLabel {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'duration_min': durationMin,
      'base_price': basePrice,
      'enabled': enabled,
    };
  }
}
