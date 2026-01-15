class Service {
  final String id;
  final String? branchId;
  final String? categoryId;
  final String name;
  final String? description;
  final int durationMin;        // ✅ Cambiar de durationMinutes
  final double? basePrice;
  final bool? enabled;

  Service({
    required this.id,
    this.branchId,
    this.categoryId,
    required this.name,
    this.description,
    required this.durationMin,  // ✅ Cambiar
    this.basePrice,
    this.enabled,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String? ?? '',
      branchId: json['branch_id'] as String?,
      categoryId: json['category_id'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      durationMin: (json['duration_min'] as num?)?.toInt() ?? 0,  // ✅
      basePrice: json['base_price'] != null
          ? (json['base_price'] as num).toDouble()
          : null,
      enabled: json['enabled'] as bool?,
    );
  }

  Duration get duration => Duration(minutes: durationMin);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'duration_min': durationMin,  // ✅
      'base_price': basePrice,
      'enabled': enabled,
    };
  }
}
