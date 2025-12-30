class StaffFull {
  final String id;
  final String name;
  final String colorTag;
  final String specialty;

  StaffFull({
    required this.id,
    required this.name,
    required this.colorTag,
    required this.specialty,
  });

  factory StaffFull.fromJson(Map<String, dynamic> json) {
    return StaffFull(
      id: json['id'] as String,
      name: json['name'] as String,
      colorTag: json['color_tag'] as String,
      specialty: json['specialty'] as String,
    );
  }
}