class SourceEntity {
  final String id;
  final String code;
  final String name;
  final String? description;
  final int sort;

  const SourceEntity({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.sort,
  });

  SourceEntity copyWith({
    String? id,
    String? code,
    String? name,
    String? description,
    int? sort,
  }) {
    return SourceEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      sort: sort ?? this.sort,
    );
  }
}
