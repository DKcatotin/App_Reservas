import 'package:agenda_app/core/logger/app_logger.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';

class Customer {
  final String id;
  final String userId;
  final String? referredBy;
  final String? taxIdentification;
  final String? taxName;
  final String? allergies;
  final String? fullName;
  final String? email;
  final String? phone;

  Customer({
    required this.id,
    required this.userId,
    this.referredBy,
    this.taxIdentification,
    this.taxName,
    this.allergies,
    this.fullName,
    this.email,
    this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    AppLogger.d('[CUSTOMER MODEL] Parseando: ${json.toString()}');

    Map<String, dynamic> customerData = json;
    
    if (json.containsKey('customer') && json['customer'] is Map) {
      customerData = json['customer'] as Map<String, dynamic>;
      AppLogger.d('[CUSTOMER MODEL] Customer anidado detectado');
    }

    // ✅ Extraer user si existe (JOIN)
    final user = customerData['user'] as Map<String, dynamic>?;

    final customer = Customer(
      id: (customerData['id'] ?? '').toString(),
      userId: (customerData['userId'] ?? customerData['user_id'] ?? '').toString(),
      referredBy: (customerData['referralId'] ?? customerData['referred_by'])?.toString(),
      taxIdentification: (customerData['taxIdentification'] ?? customerData['tax_identification'])?.toString(),
      taxName: (customerData['taxName'] ?? customerData['tax_name'])?.toString(),
      allergies: customerData['allergies']?.toString(),

      // ✅ PRIORIDAD: user JOIN
      fullName: user != null
          ? '${user['name'] ?? ''} ${user['lastname'] ?? ''}'.trim()
          : (customerData['taxName'] ?? customerData['tax_name'])?.toString(),

      email: user != null
          ? user['email']?.toString()
          : customerData['email']?.toString(),

      // ✅ FIX: cellPhone es el campo correcto en user
      phone: user != null
          ? (user['cellPhone']?.toString() ?? user['phone']?.toString())
          : customerData['phone']?.toString(),
    );

    AppLogger.d('[CUSTOMER MODEL] ✅ Parseado: ${customer.fullName} - ${customer.phone}');
    return customer;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
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
      userId: userId,
      referredBy: referredBy,
      taxIdentification: taxIdentification,
      taxName: taxName,
      allergies: allergies,
      fullName: fullName,
      email: email,
      phone: phone,
    );
  }

  factory Customer.fromEntity(CustomerEntity entity) {
    return Customer(
      id: entity.id,
      userId: entity.userId,
      referredBy: entity.referredBy,
      taxIdentification: entity.taxIdentification,
      taxName: entity.taxName,
      fullName: entity.fullName,
      phone: entity.phone,
      email: entity.email,
      allergies: entity.allergies,
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