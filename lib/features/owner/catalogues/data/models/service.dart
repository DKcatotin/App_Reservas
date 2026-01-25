import '../../domain/entities/service_entity.dart';

class Service {
  final String id;
  final String branchId;
  final String? categoryId;
  final String name;
  final String? description;
  final int durationMin;
  final double basePrice;
  final bool enabled;

  Service({
    required this.id,
    required this.branchId,
    this.categoryId,
    required this.name,
    this.description,
    required this.durationMin,
    required this.basePrice,
    required this.enabled,
  });

  // JSON → Model
 factory Service.fromJson(Map<String, dynamic> json) {
  return Service(
    id: json['id'] as String,
    branchId: json['branchId'] as String,
    categoryId: json['categoryId'] as String?,
    name: json['name'] as String,
    description: json['description'] as String?,
    durationMin: json['durationMin'] as int,
    basePrice: double.parse(json['basePrice'].toString()), // ← IMPORTANTE: convertir de String
    enabled: json['isEnabled'] as bool? ?? json['enabled'] as bool? ?? true,
  );
}

  // Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branchId': branchId,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'durationMin': durationMin,
      'basePrice': basePrice,
      'enabled': enabled,
    };
  }

  // Model → Entity (para pasar a domain layer)
  ServiceEntity toEntity() {
    return ServiceEntity(
      id: id,
      branchId: branchId,
      categoryId: categoryId,
      name: name,
      description: description,
      durationMin: durationMin,
      basePrice: basePrice,
      enabled: enabled,
    );
  }

  // Entity → Model (para guardar)
  factory Service.fromEntity(ServiceEntity entity) {
    return Service(
      id: entity.id,
      branchId: entity.branchId,
      categoryId: entity.categoryId,
      name: entity.name,
      description: entity.description,
      durationMin: entity.durationMin,
      basePrice: entity.basePrice,
      enabled: entity.enabled,
    );
  }
}
