class CustomerEntity {
  final String id;
  final String? taxIdentification;  // Para buscar por cédula
  final String? fullName;
  final String? phone;
  final String? email;
  final String? allergies;

  const CustomerEntity({
    required this.id,
    this.taxIdentification,
    this.fullName,
    this.phone,
    this.email,
    this.allergies,
  });

  CustomerEntity copyWith({
    String? id,
    String? taxIdentification,
    String? fullName,
    String? phone,
    String? email,
    String? allergies,
  }) {
    return CustomerEntity(
      id: id ?? this.id,
      taxIdentification: taxIdentification ?? this.taxIdentification,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      allergies: allergies ?? this.allergies,
    );
  }
}
