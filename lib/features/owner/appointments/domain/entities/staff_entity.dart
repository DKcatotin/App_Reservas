class StaffEntity {
  final String id;
  final String name;
  final String? specialty;
  final String? colorTag;

  const StaffEntity({
    required this.id,
    required this.name,
    this.specialty,
    this.colorTag,
  });

  StaffEntity copyWith({
    String? id,
    String? name,
    String? specialty,
    String? colorTag,
  }) {
    return StaffEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      colorTag: colorTag ?? this.colorTag,
    );
  }
}
