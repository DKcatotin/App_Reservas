import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa al propietario/admin
class Owner extends Equatable {
  final String id;
  final String fullName;
  final String username;
  final String identification;
  final String? lastname;

  const Owner({
    required this.id,
    required this.fullName,
    required this.username,
    required this.identification,
    this.lastname,
  });

  @override
  List<Object?> get props => [id, fullName, username, identification, lastname];
}
