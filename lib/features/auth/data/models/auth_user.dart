import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String username;
  final String name;
  final String lastname;
  final String identification;

  const AuthUser({
    required this.id,
    required this.username,
    required this.name,
    required this.lastname,
    required this.identification,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] ?? '') as String,
      username: (json['username'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      lastname: (json['lastname'] ?? '') as String,
      identification: (json['identification'] ?? '') as String,
    );
  }

  @override
  List<Object?> get props => [id, username, name, lastname, identification];
}
