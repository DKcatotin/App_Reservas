class CustomerEntity {
  final String id;
  final String userId;              //  NUEVO - FK obligatoria
  final String? referredBy;
  final String? taxIdentification;
  final String? taxName;
  final String? allergies;
  
  // Campos de users (obtenidos por JOIN)
  final String? fullName;
  final String? email;
  final String? phone;

  CustomerEntity({
    required this.id,
    required this.userId,           //  NUEVO
    this.referredBy,
    this.taxIdentification,
  /// Creates a copy of this [CustomerEntity] but with the given fields
  /// replaced with the new values.
  ///
  /// [id], [taxIdentification], [fullName], [phone], [email] and [allergies]
  /// are optional and default to the current value if not specified.
    this.taxName,
    this.allergies,
    this.fullName,
    this.email,
    this.phone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
