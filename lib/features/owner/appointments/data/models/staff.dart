class Staff {
  final String id;
  final String name;
  final String? specialty; //  OPCIONAL: agregar especialidad
  final String? colorTag;  //  OPCIONAL: para UI de agenda

  Staff({
    required this.id,
    required this.name,
    this.specialty,
    this.colorTag,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      colorTag: json['color_tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'color_tag': colorTag,
    };
  }
}
