class CustomerEntity {
  final String id;
  final String name;
  final String phone;

  const CustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
  });

  CustomerEntity copyWith({
    String? id,
    String? name,
    String? phone,
  }) {
    return CustomerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}
