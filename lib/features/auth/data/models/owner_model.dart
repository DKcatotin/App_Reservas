import 'package:equatable/equatable.dart';
import '../../domain/entities/owner.dart';

class OwnerModel extends Owner with EquatableMixin {
  const OwnerModel({
    required super.id,
    required super.fullName,
    required super.username,
    required super.identification,
    super.lastname,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'] ?? '',
      fullName: '${json['name'] ?? ''} ${json['lastname'] ?? ''}'.trim(),
      username: json['username'] ?? '',
      identification: json['identification'] ?? '',
      lastname: json['lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': fullName.split(' ').first,
      'lastname': lastname,
      'username': username,
      'identification': identification,
    };
  }

  @override
  List<Object?> get props => [id, fullName, username, identification, lastname];

  OwnerModel copyWith({
    String? id,
    String? fullName,
    String? username,
    String? identification,
    String? lastname,
  }) {
    return OwnerModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      identification: identification ?? this.identification,
      lastname: lastname ?? this.lastname,
    );
  }
}
