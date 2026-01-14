import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';


class Customer {
  final String id;
  final String? userId;
  final String? taxIdentification;  // Cédula/RUC
  final String? taxName;
  final String? allergies;
  // Datos de la tabla users (anidados o directos según backend)
  final String? fullName;
  final String? email;
  final String? phone;

  Customer({
    required this.id,
    this.userId,
    this.taxIdentification,
    this.taxName,
    this.allergies,
    this.fullName,
    this.email,
    this.phone,
  });

  // Mapeo desde JSON del backend
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      taxIdentification: json['tax_identification'] as String?,
      taxName: json['tax_name'] as String?,
      allergies: json['allergies'] as String?,
      // Si el backend devuelve el user anidado o directo
      fullName: json['user']?['full_name'] as String? ?? json['full_name'] as String?,
      email: json['user']?['email'] as String? ?? json['email'] as String?,
      phone: json['user']?['phone'] as String? ?? json['phone'] as String?,
    );
  }

  // Mapeo hacia JSON para enviar al backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tax_identification': taxIdentification,
      'tax_name': taxName,
      'allergies': allergies,
      'full_name': fullName,
      'email': email,
      'phone': phone,
    };
  }

  // Conversión a Entity (Domain)
  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      taxIdentification: taxIdentification,
      fullName: fullName,
      phone: phone,
      email: email,
      allergies: allergies,
    );
  }

  // Conversión desde Entity
  factory Customer.fromEntity(CustomerEntity entity) {
    return Customer(
      id: entity.id,
      taxIdentification: entity.taxIdentification,
      fullName: entity.fullName,
      phone: entity.phone,
      email: entity.email,
      allergies: entity.allergies,
    );
  }
}
