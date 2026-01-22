import 'package:equatable/equatable.dart';

class Owner extends Equatable {
  final String id;
  final String username;
  final String identification;
  final String? name;
  final String? lastname;
  final String? email;
  final String? phone;
  final bool? isActive;
  final String? branchId;
  final String? roleId;

  const Owner({
    required this.id,
    required this.username,
    required this.identification,
    this.name,
    this.lastname,
    this.email,
    this.phone,
    this.isActive,
    this.branchId,
    this.roleId,
  });

  String get fullName => '${name ?? ''} ${lastname ?? ''}'.trim();

  @override
  List<Object?> get props => [
    id,
    username,
    identification,
    name,
    lastname,
    email,
    phone,
    isActive,
    branchId,
    roleId,
  ];
}
