import '../../domain/entities/source_entity.dart';

class Source {
  final String id;  // ✅ UUID
  final String code;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String name;
  final bool enabled;
  final bool required;
  final int sort;
  final String type;
  final String? description;

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
      id: json['id'] as String,  // ✅ UUID
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sort: (json['sort'] as num).toInt(),
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
      'description': description,
      'required': required,
      'sort': sort,
      'type': type,
    };
  }

  SourceEntity toEntity() {
    return SourceEntity(
      id: id,  // ✅ UUID
      code: code,
      name: name,
      description: description,
      sort: sort,
    );
  }

  factory Source.fromEntity(SourceEntity entity) {
    return Source(
      id: entity.id,  // ✅ UUID
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      enabled: true,
      code: entity.code,
      name: entity.name,
      description: entity.description,
      required: false,
      type: 'appointment_source',
      sort: entity.sort,
    );
  }
}