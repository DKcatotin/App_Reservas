class TestItem {
  final String code;
  final String name;

  const TestItem({required this.code, required this.name});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
