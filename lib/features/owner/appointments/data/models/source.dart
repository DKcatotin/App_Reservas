import '../../domain/entities/source_entity.dart';

class Source {
  final String id;  // ← CAMBIAR de int a String (UUID)
  final String code;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String name;
  final bool enabled;
  final bool required;
  final int sort;
  final String type;
  final String? description;  // ← AGREGAR (viene en el JSON)

  Source({
    required this.id,
    required this.code,
    required this.name,
    required this.updatedAt,
    required this.createdAt,
    required this.enabled,
    required this.required,
    required this.sort,
    required this.type,
    this.description,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] as String,  // ← CAMBIAR: String, no int
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,  // ← AGREGAR
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sort: (json['sort'] as num).toInt(),  // ← SAFER: permite int o double
      enabled: json['enabled'] as bool,
      required: json['required'] as bool,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'enabled': enabled,
      'code': code,
      'name': name,
      'description': description,  // ← AGREGAR
      'required': required,
      'sort': sort,
      'type': type,
    };
  }

  // MODEL → ENTITY
  SourceEntity toEntity() {
    return SourceEntity(
      id: id,  // ← Ya es String, no necesita toString()
      code: code,
      name: name,
      description: description,  // ← AGREGAR
      sort: sort,
    );
  }

  // ENTITY → MODEL
  factory Source.fromEntity(SourceEntity entity) {
    return Source(
      id: entity.id,  // ← Ya es String, no necesita parse
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      enabled: true,
      code: entity.code,
      name: entity.name,
      description: entity.description,  // ← AGREGAR
      required: false,
      type: 'appointment_source',
      sort: entity.sort,
    );
  }
}
