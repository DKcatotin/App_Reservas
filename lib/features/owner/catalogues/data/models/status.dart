import '../../domain/entities/status_entity.dart';

class Status {
  final int id;
  final String code;
  final String name;

  Status({
    required this.id,
    required this.code,
    required this.name,
  });

  // JSON → Model
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  // Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
    };
  }

  // Model → Entity
  StatusEntity toEntity() {
    return StatusEntity(
      id: id,
      code: code,
      name: name,
    );
  }

  // Entity → Model
  factory Status.fromEntity(StatusEntity entity) {
    return Status(
      id: entity.id,
      code: entity.code,
      name: entity.name,
    );
  }
}
