class ClienteModel {
  final String cedula;
  final String nombre;
  final String celular;

  ClienteModel({
    required this.cedula,
    required this.nombre,
    required this.celular,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      cedula: json['cedula'],
      nombre: json['nombre'],
      celular: json['celular'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cedula': cedula,
      'nombre': nombre,
      'celular': celular,
    };
  }
}