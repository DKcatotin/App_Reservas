class Customer {
  final String id;      // UUID interno (del JSON o de BD)
  final String cedula;  // Lo que ingresa el usuario
  final String nombre;
  final String celular;
  

  Customer({
    required this.id,
    required this.cedula,
    required this.nombre,
    required this.celular,
    
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      // Por ahora usamos el id del JSON como cédula mock
      cedula: json['cedula'] as String? ?? json['id'] as String,
      nombre: json['nombre'] as String? ?? json['name'] as String,
      celular: json['celular'] as String? ?? json['phone'] as String,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cedula': cedula,
      'nombre': nombre,
      'celular': celular,
      
    };
  }
}
