class ServiceEntity {
  final String id;
  final String? branchId;
  final String? categoryId;
  final String name;
  final String? description;
  final int durationMin;
  final double? basePrice;
  final bool? enabled;

  const ServiceEntity({
    required this.id,
    this.branchId,
    this.categoryId,
    required this.name,
    this.description,
    required this.durationMin,
    this.basePrice,
    this.enabled,
  });

  Duration get duration => Duration(minutes: durationMin);

  String get durationLabel {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  ServiceEntity copyWith({
    String? id,
    String? branchId,
    String? categoryId,
    String? name,
    String? description,
    int? durationMin,
    double? basePrice,
    bool? enabled,
  }) {
    return ServiceEntity(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      durationMin: durationMin ?? this.durationMin,
      basePrice: basePrice ?? this.basePrice,
      enabled: enabled ?? this.enabled,
    );
  }
}
