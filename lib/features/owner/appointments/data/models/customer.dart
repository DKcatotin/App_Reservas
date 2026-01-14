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
  return Customer(
    id: json['id'] as String? ?? '',
    userId: json['user_id'] as String? ?? '',
    referredBy: json['referred_by'] as String?,
    taxIdentification: json['tax_identification'] as String?,
    taxName: json['tax_name'] as String?,
    allergies: json['allergies'] as String?,
    fullName: json['user']?['full_name'] as String? ?? 
              json['full_name'] as String? ?? 
              '',
    email: json['user']?['email'] as String? ?? 
           json['email'] as String? ?? 
           '',
    phone: json['user']?['phone'] as String? ?? 
           json['phone'] as String? ?? 
           '',
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
