import '../../domain/entities/source_entity.dart';

class Source {
  final int id;
  final String code;
  final String name;

  Source({
    required this.id,
    required this.code,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
    };
  }

  // ✅ MODEL → ENTITY
  SourceEntity toEntity() {
    return SourceEntity(
      id: id,
      code: code,
      name: name,
    );
  }

  // ✅ ENTITY → MODEL
  factory Source.fromEntity(SourceEntity entity) {
    return Source(
      id: entity.id,
      code: entity.code,
      name: entity.name,
    );
  }
}
