import 'package:equatable/equatable.dart';
import '../../domain/entities/owner.dart';

class OwnerModel extends Equatable {
  final String id;
  final String username;
  final String identification;
  final String? name;
  final String? lastname;

  const OwnerModel({
    required this.id,
    required this.username,
    required this.identification,
    this.name,
    this.lastname,
  });

  String get fullName => '${name ?? ''} ${lastname ?? ''}'.trim();

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      identification: json['identification'] ?? '',
      name: json['name'],
      lastname: json['lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'identification': identification,
      'name': name,
      'lastname': lastname,
    };
  }

  Owner toEntity() {
    return Owner(
      id: id,
      username: username,
      identification: identification,
      name: name,
      lastname: lastname,
    );
  }

  OwnerModel copyWith({
    String? id,
    String? username,
    String? identification,
    String? name,
    String? lastname,
  }) {
    return OwnerModel(
      id: id ?? this.id,
      username: username ?? this.username,
      identification: identification ?? this.identification,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
    );
  }

  @override
  List<Object?> get props => [id, username, identification, name, lastname];
}