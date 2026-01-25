import 'package:agenda_app/features/owner/branches/domain/branch_entity.dart';


class Branch {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String city;
  final bool enabled;

  Branch({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.enabled,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      enabled: json['enabled'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'city': city,
      'enabled': enabled,
    };
  }

  BranchEntity toEntity() {
    return BranchEntity(
      id: id,
      name: name,
      phone: phone,
      email: email,
      address: address,
      city: city,
      enabled: enabled,
    );
  }

  factory Branch.fromEntity(BranchEntity entity) {
    return Branch(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      address: entity.address,
      city: entity.city,
      enabled: entity.enabled,
    );
  }
}
