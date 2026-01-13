class CustomerEntity {
  final String id;
  final String name;
  final String phone;
  final String? idNumber; // ✅ AGREGAR

  const CustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.idNumber, // ✅ AGREGAR
  });

  CustomerEntity copyWith({
    String? id,
    String? name,
    String? phone,
    String? idNumber, // ✅ AGREGAR
  }) {
    return CustomerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      idNumber: idNumber ?? this.idNumber, // ✅ AGREGAR
    );
  }
}