import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

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
  logger.d('🔍 [MODEL] Parseando customer: ${json.toString()}');

  final user = json['user'] as Map<String, dynamic>?;

  return Customer(
    id: (json['id'] ?? '').toString(),
    userId: (json['userId'] ?? json['user_id'] ?? '').toString(),
    referredBy: (json['referralId'] ?? json['referred_by'])?.toString(),
    taxIdentification: (json['taxIdentification'] ?? json['tax_identification'])?.toString(),
    taxName: (json['taxName'] ?? json['tax_name'])?.toString(),
    allergies: (json['allergies'])?.toString(),

    // Campos del user (JOIN)
    fullName: user != null
        ? '${user['name'] ?? ''} ${user['lastname'] ?? ''}'.trim()
        : (json['full_name'] ?? json['fullName'])?.toString(),

    email: user != null
        ? (user['email']?.toString())
        : (json['email']?.toString()),

    phone: user != null
        ? (user['cellPhone']?.toString() ?? user['phone']?.toString())
        : (json['phone']?.toString()),
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
}
