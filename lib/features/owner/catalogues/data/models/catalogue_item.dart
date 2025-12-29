class CatalogueItem {
  final String code;
  final String name;

  const CatalogueItem({
    required this.code,
    required this.name,
  });

  factory CatalogueItem.fromJson(Map<String, dynamic> json) {
    return CatalogueItem(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
