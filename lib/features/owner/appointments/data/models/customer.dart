import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';

class Customer {
  final String id;
  final String userId;              // NUEVO
  final String? referredBy;
  final String? taxIdentification;
  final String? taxName;
  final String? allergies;
  final String? fullName;
  final String? email;
  final String? phone;

  Customer({
    required this.id,
    required this.userId,           //  NUEVO
    this.referredBy,
    this.taxIdentification,
    this.taxName,
    this.allergies,
    this.fullName,
    this.email,
    this.phone,
  });

factory Customer.fromJson(Map<String, dynamic> json) {
  print('🔍 [MODEL] Parseando customer: ${json.toString()}');

  final user = json['user'] as Map<String, dynamic>?;

  // Construir nombre completo desde user.name + user.lastname si fullName viene null
  String? resolvedFullName;
  if (user != null) {
    resolvedFullName = user['fullName'] as String?;
    if (resolvedFullName == null) {
      final name = user['name'] as String?;
      final lastname = user['lastname'] as String?;
      if (name != null || lastname != null) {
        resolvedFullName = [name, lastname].where((e) => e != null && e.isNotEmpty).join(' ');
      }
    }
  }

  return Customer(
    id: json['id'] as String? ?? '',
    // el backend envía userId en camelCase
    userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
    referredBy: json['referred_by'] as String?,
    // backend: taxIdentification (camelCase)
    taxIdentification:
        json['taxIdentification']?.toString() ?? json['tax_identification']?.toString(),
    // backend: taxName
    taxName: json['taxName'] as String? ?? json['tax_name'] as String?,
    allergies: json['allergies'] as String?,
    fullName: resolvedFullName ?? json['full_name'] as String?,
    email: user?['email'] as String? ?? json['email'] as String?,
    // preferir cellPhone si viene
    phone: user?['cellPhone'] as String? ?? user?['phone'] as String? ?? json['phone'] as String?,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,                        //  NUEVO
      'referred_by': referredBy,
      'tax_identification': taxIdentification,
      'tax_name': taxName,
      'allergies': allergies,
      'full_name': fullName,
      'email': email,
      'phone': phone,
    };
  }

  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      userId: userId,                           //  NUEVO
      referredBy: referredBy,
      taxIdentification: taxIdentification,
      taxName: taxName,
      allergies: allergies,
      fullName: fullName,
      email: email,
      phone: phone,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Customer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
