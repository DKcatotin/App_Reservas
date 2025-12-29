class Staff {
  final String id;
  final String name;

  Staff({required this.id, required this.name});

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
    );
  }
}
