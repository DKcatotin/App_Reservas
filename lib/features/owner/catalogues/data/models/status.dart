import '../../domain/entities/status_entity.dart';

class Status {
  final String id;  // ✅ UUID en lugar de int
  final String code;
  final String name;

  Status({
    required this.id,
    required this.code,
    required this.name,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] as String,  // ✅ UUID
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
    };
  }

  StatusEntity toEntity() {
    return StatusEntity(
      id: id,  // ✅ UUID
      code: code,
      name: name,
    );
  }

  factory Status.fromEntity(StatusEntity entity) {
    return Status(
      id: entity.id,
      code: entity.code,
      name: entity.name,
    );
  }
}